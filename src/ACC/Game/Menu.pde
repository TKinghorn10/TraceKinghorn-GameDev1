//Kolby Green
class Menu {
  int x, y, w, h;
  PImage img, go;

  Menu() {
    x=width/2;
    y=height/2;
    w=25;
    h=75;
    img = loadImage("ScrollingBackground.png");
    go = loadImage("GameOver.png");
  }
  void display() {
    rect(x, y, w, h);
  }
  void hover() {
  }
  //Trace Kinghorn, Kolby Green
  void startScreen() {
    background(80);
    img.resize(width+400, height);
    int x = frameCount % img.width;
    copy(img, x, 0, img.width, height, 0, 0, img.width, height);
    int x2 = img.width - x;
    if (x2 < width) {
      copy(img, 0, 0, img.width, height, x2, 0, img.width, height);
    }
    textAlign(CENTER);
    text("Start Screen: filler edition", width/2, height/2 - 250);
    btnStart.display();
  }
  //Maxwell Johnson
  void endScreen() {
    cursor(ARROW);
    background(1);
    go.resize(width, height);
    imageMode(CENTER);
    image(go, width/2, height/2);
  }
  //Kolby Green
  void pauseScreen() {
    //background(0);
    textAlign(CENTER);
    cursor(ARROW); 
    textSize(100);
    fill(255);
    text("Pause", width/2, height/4);
    btnSettings.display();
    btnSave.display();
    btnPlay.display();
  }
}
