import gifAnimation.*;
class PowerUp {
  int x, y, diam, speed, p, type;
  Gif pup;
  PApplet parent;
  PowerUp(PApplet pApp) {
    parent=pApp;
    x=int(random(width));
    y=-25;
    diam=50;
    speed=2;
    type=0;
    p=int(random(10));
    if (p>3) {
      pup=new Gif(parent, "lcrystal.gif");
      pup.loop();
      type=1;
    } else if (p<=3) {
      pup=new Gif(parent, "sm.gif");
      type=0;
    }
  }
  void display() {
    imageMode(CENTER);
    pup.resize(50, 50);
    image(pup, x, y);
  }
  void move() {
    y+=speed;
  }
  //void type() {
  //  if (p>5) {
  //    type=1;
  //  } else {
  //    type=0;
  //  }
  //}
  boolean reachedBottom() {
    if (y>=height+50) {
      return true;
    } else {
      return false;
    }
  }
}
