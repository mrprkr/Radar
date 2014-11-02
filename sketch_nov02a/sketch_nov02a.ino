#include <DHT.h>
#define DHTPIN 3
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);

int lightPin = A0;
int soundPin = A2;
int loopCount = 0;
int lightCount = 0;
float humidity = 0;
float temp = 0;
float lightValue = 0;

void setup() {
  pinMode(soundPin, INPUT);
  pinMode(lightPin, INPUT);
  Serial.begin(9600);
  dht.begin();
}

void loop() {
  float soundValue = analogRead(soundPin);

  //only check the temperature and humidity every 100 loops
  if (loopCount > 10000 || loopCount == 0) {
    humidity = dht.readHumidity();
    temp = dht.readTemperature();
    loopCount = 1;
  }
  else {
    loopCount++;
  }

  if (lightCount > 10 || lightCount == 0) {
    lightValue = analogRead(lightPin);
    lightCount = 1;
  }
  else {
    lightCount++;
  }

  Serial.print(soundValue);
  Serial.print(", ");
  Serial.print(lightValue);
  Serial.print(", ");
  Serial.print(humidity);
  Serial.print(", ");
  Serial.println(temp);
  delay(100);
}


