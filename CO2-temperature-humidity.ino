#include <CCS811.h>
#include <DHT.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>
#include <SoftwareSerial.h>
#include "rgb_lcd.h"
#define DHT_PIN 7
#define DHT_MODEL DHT11


/*

 * IIC address default 0x5A, the address becomes 0x5B if the ADDR_SEL is soldered.

 */

//CCS811 sensor(&Wire, /*IIC_ADDRESS=*/0x5A);

CCS811 sensor;

DHT dht(DHT_PIN, DHT_MODEL);
rgb_lcd lcd;
SoftwareSerial ss(2, 3);

void setup(void)

{

  Serial.begin(9600);
  delay(10);
  ss.begin(9600);
  dht.begin();
  lcd.begin(16, 2);
  /*Wait for the chip to be initialized completely, and then exit*/

  while(sensor.begin() != 0){

    Serial.println("failed to init chip, please check if the chip connection is fine");

    delay(1000);

  }
  lcd.setRGB(255, 255, 255);
  lcd.setCursor(0, 0);
  lcd.print("wait...");

  /**

   * @brief Set measurement cycle

   * @param cycle:in typedef enum{

   *                  eClosed,      //Idle (Measurements are disabled in this mode)

   *                  eCycle_1s,    //Constant power mode, IAQ measurement every second

   *                  eCycle_10s,   //Pulse heating mode IAQ measurement every 10 seconds

   *                  eCycle_60s,   //Low power pulse heating mode IAQ measurement every 60 seconds

   *                  eCycle_250ms  //Constant power mode, sensor measurement every 250ms

   *                  }eCycle_t;

   */

  sensor.setMeasCycle(sensor.eCycle_250ms);

}


bool check(int temp, int humi) {
  int hukai;
  bool ans = false;
  hukai = 0.81 * temp + 0.01 * humi * (0.99 * temp - 14.3) + 46.3;

  if (60 <= hukai and hukai <= 75)
  {
    ans = true;
  }
  else {
    ans = false;
  }

  return ans;
}

void loop() {

  delay(1000);

  if(sensor.checkDataReady() == true){
    
    //Serial.print("CO2: ");
    int ans = sensor.getCO2PPM();
    //Serial.println(sensor.getCO2PPM());
    double Humidity = dht.readHumidity();          // 湿度の読み取り
    double Temperature = dht.readTemperature();    // 温度の読み取り(摂氏)

    delay(500);
    lcd.setCursor(0, 0);
    lcd.print(Temperature); lcd.println("[℃]");
    lcd.setCursor(0, 1);
    lcd.print(Humidity); lcd.println("%");
    lcd.display();
    //co2
    if (ans < 1500) {
      Serial.println("co2 is good");
      if ( check(Humidity, Temperature) == true){
        Serial.println("---------------------------------");
        Serial.print(Temperature);
        Serial.print("[℃]");
        Serial.print(Humidity);
        Serial.println("[%]");
        Serial.println("---------------------------------");
      }
      if (isnan(Humidity) || isnan(Temperature)) {  // 読み取りのチェック
        Serial.println("ERROR");
      }
    }
    else if (1500 <= ans and ans < 40000) {
      Serial.println("bad");
      Serial.println("換気しろ");
      if (check(Humidity, Temperature) == false) {
        Serial.println("---------------------------------");
        Serial.println("不快な状態です。");
        Serial.println("適切な温室度にしましょう。");
        Serial.println("温室度は以下の通りです。");
        Serial.print(Temperature);
        Serial.print("[℃]");
        Serial.print(Humidity);
        Serial.println("[%]");
        Serial.println("---------------------------------");
      }
      if (isnan(Humidity) || isnan(Temperature)) {  // 読み取りのチェック
        Serial.println("ERROR");
        }
      }
    }
    else {
      Serial.println("Data is not ready!");
  }

  sensor.writeBaseLine(0x847B);

  //delay cannot be less than measurement cycle

  //delay(1000);

}
