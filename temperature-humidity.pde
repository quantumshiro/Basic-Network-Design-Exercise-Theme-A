import processing.serial.*; //Arduinoと通信するためのライブラリの読み込み
Serial myPort;              //シリアル通信を行うための変数を定義
PFont  myFont;              //画面に表示するフォントの指定

int c;
int tempC = 0, humidity = 0;
int x = 200, y = 60;
int val1 = 100;
int val2 = 1000/50;
int val3 = 1000/100;

void serialEvent(Serial p){
  if(myPort.available() > 2){     //データが3以上おくられてきたかの判断
    c = myPort.read();            //スタートデータの読み込み
    if(c == 's'){
      tempC    = myPort.read() / 2;   //温度データの読み取り
      humidity = myPort.read() / 2;   //湿度デーtの読み取り
    }
  }
}

void setup(){
  size(1400,300);                      //ウィンドウサイズ
  background(0,0,0);                   //背景の色
  
  println("Available serial ports:");
  printArray(Serial.list());           //使用できるCOMポートの取得
  //printArray(PFont.list());          //使用できるFontの表示、わからないときに使用
  
  myPort = new Serial(this, Serial.list()[0], 9600); //通信するポートと速度の設定、Arduinoと合わせる必要あり
  myPort.clear();                                    //受信データをクリア
  myFont = createFont("Meiryo UI Bold", 80);         //Font指定、サイズ80pt
  textFont(myFont);
}

void draw(){
  background(0,0,0);          //画面の再描画
  
  //ゲージの下地描画
  fill(100,0,0);              //色指定
  rect(x, y,     1000, 65);   //ゲージの下地描画
  rect(x, y+120, 1000, 65);   //ゲージの下地描画
  
  textSize(40);               //テキストサイズ
  fill(255,0,0);              //色指定
  text("温度", x-100, 110);   //湿度の表示
  fill(0,0,255);              //色指定
  text("湿度", x-100, 230);   //湿度の表示
  
  //横軸表示
  textSize(20);               //テキストサイズ
  textAlign(CENTER);          //中央揃え
  
  fill(255,255,0);               //色指定
  text( 0,   x,        150);     //0
  text( 5,   x+val1,   150);     //5
  text(10,   x+val1*2, 150);     //10
  text(15,   x+val1*3, 150);     //15
  text(20,   x+val1*4, 150);     //20
  text(25,   x+val1*5, 150);     //25
  text(30,   x+val1*6, 150);     //30
  text(35,   x+val1*7, 150);     //35
  text(40,   x+val1*8, 150);     //40
  text(45,   x+val1*9, 150);     //45
  text(50,   x+val1*10, 150);    //50
  text("℃", x+val1*10+40, 150); //温度
  
  fill(0,255,255);               //色指定
  text( 0,   x,        270);     //0
  text(10,   x+val1,   270);     //10
  text(20,   x+val1*2, 270);     //20
  text(30,   x+val1*3, 270);     //30
  text(40,   x+val1*4, 270);     //40
  text(50,   x+val1*5, 270);     //50
  text(60,   x+val1*6, 270);     //60
  text(70,   x+val1*7, 270);     //70
  text(80,   x+val1*8, 270);     //80
  text(90,   x+val1*9, 270);     //90
  text(100,  x+val1*10, 270);    //100
  text("%",  x+val1*10+40, 270); //湿度
  
  //温度ゲージ表示
  fill(255,255,0);               //色指定
  rect(x, y, tempC*val2, 65);    //横棒描画
  
  //温度表示
  fill(255,0,0);                 //色指定
  textSize(60);                  //テキストサイズ
  textAlign(RIGHT);              //右揃え
  text(tempC, 350, 115);         //温度の表示
  textSize(30);                  //テキストサイズ
  textAlign(LEFT);               //左揃え
  text("℃", 355, 115);          //℃表示
  
  
  //湿度ゲージ表示
  fill(0,255,255);                   //色指定
  rect(x, y+120, humidity*val3, 65); //横棒描画
  
  //湿度表示
  fill(0,0,255);                     //色指定
  textSize(60);                      //テキストサイズ
  textAlign(RIGHT);                  //右揃え
  text(humidity, 350, 235);          //湿度の表示
  textSize(30);                      //テキストサイズ
  textAlign(LEFT);                   //左揃え
  text("%", 355, 235);               //%表示

}
