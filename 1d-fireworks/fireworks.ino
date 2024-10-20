/*  
 *  LED Fireworks Simulator
 *  WhiskeyTangoHotel.Com
 *  JAN 2024
 *
 *  To vary the effect experiments randomizing variables
 *  within acceptable limits was done.  Otherwise the effect
 *  just looks to same 'shot after shot'.  Other mods as well
  *
 *  Leverage from https://www.Daniel-Westhof.de and
 *  https://www.anirama.com/1000leds/1d-fireworks/
 *
 *  Hardware:  
 *  HiLetgo 1PC ESP8266 NodeMCU CP2102 ESP-12E Development Board and a
 *  WS2812B LED-strip with 300 LEDs (16.5 feet).
 */
 
#include <FastLED.h>
#define NUM_LEDS 150
//#define DATA_PIN 0  // Labeled a D1 on the board.
#define DATA_PIN A1  // Labeled a D1 on the board.
//#define LED_PIN 2  // This is the BLUE LED on board
#define NUM_SPARKS NUM_LEDS/2  // OG: NUM_LEDS/2
 
CRGB leds[NUM_LEDS]; // sets up block of memory
 
float sparkPos[NUM_SPARKS];
float sparkVel[NUM_SPARKS];
float sparkCol[NUM_SPARKS];
float flarePos;
float gravity = -.008; // m/s/s
int launch_delay; // we later randomize seconds between launches
CRGB first;
 
void setup() {
  Serial.begin(115200);
  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS);
  FastLED.clear();
  FastLED.show();
}
 
void loop() {   
  // Delay untill next launch. Blink BLUE on board LED
  Serial.println("  ");
  launch_delay = int(random(5,30)); // Min>=5.  Randomize secs between BOOMs.  
  //launch_delay = 5;
  
  for (int i = (launch_delay - 5); i > 0; i--) {
    Serial.println(String(i + 5) + " seconds to launch...");
    blink(500);
  }

  // Slower timer done .  Fast blink for ~5 seconds to warn of BOOM
  Serial.print("5 seconds to launch!!!");
  for (int i = 50; i > 0; i--) {
    Serial.print(".");
    blink(50);
  }

  Serial.println(".");
  Serial.print("BOOM...");
 
  // send up flare
  flare();
 
  // explode
  explodeLoop();
}

void blink(int milisec) {
    leds[0] = CRGB::White;
    FastLED.show();
    delay(milisec);
    FastLED.clear();
    FastLED.show();
    delay(milisec);    
}
 

void flare() {
  flarePos = 0;  // 0
  // flareVel is how hight the BOOM is.  2.2 is max height
  float flareVel = float(random(127, 134)) / 100; // Start: (180, 195)) / 100; trial and error to get reasonable range
  // float flareVel = 128 / float(100);
  Serial.println(" with flare height of " + String((flareVel*100)/2.2) + "%");  // How high is the BOOM?
  float brightness = 5;   // OG: 1
 
  // initialize launch sparks
  int blast_base = random(5,20);  // number of sparks at blast base.
  for (int i = 0; i < blast_base; i++) {   // OG: int i = 0; i < 5; i++  
    sparkPos[i] = 0; 
    sparkVel[i] = (float(random8()) / 255) * (flareVel / 2); // OG: (float(random8()) / 255) * (flareVel / 5); the / xx); is control value for BURST
    //sparkPos[i] = 0; sparkVel[i] = (float(random8()) / 0.85 * NUM_LEDS) * (flareVel / 2); // OG: (float(random8()) / 255) * (flareVel / 5); the / xx); is control value for BURST
    sparkCol[i] = sparkVel[i] * 1000; sparkCol[i] = constrain(sparkCol[i], 0, 255);
  }  

  // launch
  while (flareVel >= -.2) {   // OG: flareVel >= -.2  when to explode after peak BOOM.  Bigger neg val means more fall before sparks
    // sparks
    for (int i = 0; i < blast_base; i++) {   // OG: int i = 0; i < 5; i++  
      sparkPos[i] += sparkVel[i];
      sparkPos[i] = constrain(sparkPos[i], 0, 120);
      sparkVel[i] += gravity;
      sparkCol[i] += -.8;
      sparkCol[i] = constrain(sparkCol[i], 0, 255);
      leds[int(sparkPos[i])] = HeatColor(sparkCol[i]);
      leds[int(sparkPos[i])] %= 50; // reduce brightness to 50/255
    }
   
    // flare
    leds[int(flarePos)] = CHSV(0, 0, int(brightness * 255));
    FastLED.show();
    delay(5);
    FastLED.clear();
    flarePos += flareVel;
    flarePos = constrain(flarePos, 0, NUM_LEDS-1);
    flareVel += gravity;
    brightness *= .99; // OG = .98
  }  // while (flareVel >= -.2)
}  // end void flare
 
void explodeLoop() {
  int nSpark_var = random(2, 10);  // Bigger number is less BOOM sparks
  int nSparks = flarePos / nSpark_var; // OG: nSparks = flarePos / 2
  //Serial.println(String(nSparks));

   
  // initialize sparks
  for (int i = 0; i < nSparks; i++) {
    sparkPos[i] = flarePos; sparkVel[i] = (float(random(0, 20000)) / 10000.0) - 1.0; // from -1 to 1
    sparkCol[i] = abs(sparkVel[i]) * 500; // set colors before scaling velocity to keep them bright
    sparkCol[i] = constrain(sparkCol[i], 0, 255);
    sparkVel[i] *= flarePos / NUM_LEDS; // proportional to height
  }
  sparkCol[0] = 255; // OG: 255  This will be our known spark
  float dying_gravity = gravity;
  float c1 = random(80,130);  // OG: 120
  float c2 = random(1,30);   // OG: 50
  //Serial.println("c1 is: " + String(c1));
  //Serial.println("c2 is: " + String(c2));
    
 
  while(sparkCol[0] > c2/128) { // OG: (sparkCol[0] > c2/128)  As long as our known spark is lit, work with all the sparks
    int decay_rate = (random(0,50));  // Slow to decay the blast sparks.  (0,50) seems right. Bigger is slower.  OG: delay(0);
    delay(decay_rate);
    //Serial.println(String(decay_rate));
    FastLED.clear();
    
    for (int i = 0; i < nSparks; i++) {   
      sparkPos[i] += sparkVel[i];
      sparkPos[i] = constrain(sparkPos[i], 0, NUM_LEDS-1);
      sparkVel[i] += dying_gravity;
      sparkCol[i] *= .975;
      sparkCol[i] = constrain(sparkCol[i], 0, 255); // RED cross dissolve. OG: constrain(sparkCol[i], 0, 255);
      
      if(sparkCol[i] > c1) { // fade white to yellow
        leds[int(sparkPos[i])] = CRGB(random(0,255), random(200,255), (255 * (sparkCol[i] - c1)) / (255 - c1));  // OG: CRGB(255, 255, (255 * (sparkCol[i] - c1)) / (255 - c1));
      }
      else if (sparkCol[i] < c2) { // fade from red to black
        leds[int(sparkPos[i])] = CRGB((random(200,255) * sparkCol[i]) / c2, 0, 0); // OG: CRGB((255 * sparkCol[i]) / c2, 0, 0);
      }
      else { // fade from yellow to red
        leds[int(sparkPos[i])] = CRGB(random(0,255), (random(200,255) * (sparkCol[i] - c2)) / (c1 - c2), 0);  // OG: CRGB(255, (255 * (sparkCol[i] - c2)) / (c1 - c2), 0);
      }      
    }
    dying_gravity *= .99; // OG: dying_gravity *= .99;  As sparks burn out they fall slower
    FastLED.show();    
  }  // end while(sparkCol)
 
  delay(5);
  FastLED.clear();
  delay(5);  
  FastLED.show();
  Serial.println("Effect Complete!!!");
} // end void explodeLoop() 

