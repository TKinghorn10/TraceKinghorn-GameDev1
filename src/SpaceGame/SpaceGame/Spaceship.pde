import gifAnimation.*;
// behaviour/physics for spaceship
class Spaceship {
  // Member Variables
  int x, y, w, lc, tc;
  Gif ship;
  PApplet parent;
  // Constructor
  Spaceship(PApplet pApp) {
    parent=pApp;
    x=width/2;
    y=height/2;
    w=50;
    lc=200;
    tc=2;
    ship=new Gif(parent, "ship.gif");
    ship.loop();
  }
  // Member Methods
  void display() {
    imageMode(CENTER);
    ship.resize(50, 50);
    image(ship, x, y);
  }
  void move(int x, int y) {
    this.x=x;
    this.y=y;
  }

  boolean fire() {
    if (lc>0) {
      return true;
    } else {
      return false;
    }
  }

  boolean intersect(Rock r) {
    float d=dist(x, y, r.x, r.y);
    if (d<=20) {
      return true;
    } else {
      return false;
    }
  }
  boolean intersect(PowerUp pu) {
    float d=dist(x, y, pu.x, pu.y);
    if (d<=20) {
      return true;
    } else {
      return false;
    }
  }
}
