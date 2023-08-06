import pathlib
import subprocess


parts = ["full", "lower", "upper"]
openscad_cmd = "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"


def make_empty_direcory(path):
    path.mkdir(exist_ok=True)
    for child in path.iterdir():
        child.unlink()
    return path


def generate_examples(folder):
    templates = [p for p in folder.glob("left_*.scad")]
    for path in templates:
        template = path.read_text()
        for module in ("middle", "right"):
            new_content = (
                template
                .replace("left_inset", f"{module}_inset")
                .replace("WELL_LEFT_", f"WELL_{module.upper()}_")
            )
            new_stem = path.stem.replace("left_", f"{module}_")
            new_path = folder / f"_{new_stem}.scad"
            print(f"Generating template file {new_path.name}")
            new_path.write_text(new_content)
            yield new_path



def get_stem_for_output(path, part, connector):
    old_stem = path.stem.removeprefix("_")

    try:
        *name_parts, _, wells = old_stem.split("_")
    except ValueError:
        return old_stem

    name = " ".join(name_parts)
    wells = f"{wells} wells" if "x" in wells else "base plate"
    conn = ", with connector" if connector == "true" else ""

    new_stem = f"{name} inset, {wells}, {part} part{conn}"
    return new_stem.title()


def print_subrpocess_result(result):
    output_lines = result.stderr.decode("utf-8").splitlines()
    indented = [f">  {line}" for line in output_lines if line.strip()]
    print("\n".join(indented))


def _iter_combinations(source):
    for part in parts:
        yield (part, "false")
        first_part = source.name.split("_")[0]

        # with connector for left insets, large insets and generated examples
        if first_part in {"large", "left", ""}:
            yield (part, "true")


def generate_image_and_model(source):
    for part, connector in _iter_combinations(source):
        stem = get_stem_for_output(source, part, connector)
        image_path = image_dir / f"{stem}.png"
        print(f"Generating image '{image_path.name}'")
        _generate(source, image_path, part, connector)
        stl_path = build_dir / f"{stem}.stl"
        print(f"Generating model '{stl_path.name}'")
        _generate(source, stl_path, part, connector)


def _generate(source, destination, part, connector):
        cmd = [
            openscad_cmd,
            "-o",
            str(destination),
            "-D",
            f'part="{part}"',
            "-D",
            f"connector={connector}",
            str(source),
            "--autocenter",
            "--viewall",
            "--render",
            ]
        result = subprocess.run(cmd, capture_output=True)
        print_subrpocess_result(result)



def generate_models(source, destination):
    for part, connector in _iter_combinations(source):
        stem = get_stem_for_output(source, part, connector)
        if "upper" in stem.lower() and connector:
            # do not generate upper parts with connectors
            continue
        stl_path = destination / f"{stem}.stl"
        print(f"Generating model '{stl_path.name}'")
        cmd = [
            openscad_cmd,
            "-o",
            str(stl_path),
            "-D",
            f'part="{part}"',
            "-D",
            f"connector={connector}",
            str(source),
            "--autocenter",
            "--viewall",
            "--render",
            ]
        continue
        result = subprocess.run(cmd, capture_output=True)
        print_subrpocess_result(result)


if __name__ == "__main__":

    pwd = pathlib.Path(".")
    build_dir = make_empty_direcory(pwd / "builds")
    image_dir = make_empty_direcory(pwd / "images")

    src_dir = pwd / "examples"

    generated_examples = list(generate_examples(src_dir))

    scad_files = src_dir.glob("*.scad")
    not_hidden = [p for p in scad_files if not p.name.startswith(".")]
    src_files = [p for p in not_hidden if not p.is_symlink()]

    for src in src_files:
        print(f"Scad file: {src}")
        generate_image_and_model(src)

    for path in generated_examples:
        path.unlink()
