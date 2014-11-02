#include <DHT.h>
#define DHTPIN 3
#define DHTTYPE DHT22 
DHT dht(DHTPIN, DHTTYPE);

int lightPin = A0;
int soundPin = A2;

void setup() {
  pinMode(soundPin, INPUT);
  pinMode(lightPin, INPUT);
  Serial.begin(9600);
  dht.begin();
}

void loop() {
  int lightValue = analogRead(lightPin);
  int soundValue = analogRead(soundPin);
  int humidity = dht.readHumidity();
  int temp = dht.readTemperature();

  Serial.print(soundValue);
  Serial.print(", ");
  Serial.print(lightValue);
  Serial.print(", ");
  Serial.print(humidity);
  Serial.print(", ");
  Serial.println(temp);
  delay(30);
}


