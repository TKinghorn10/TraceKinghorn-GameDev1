//physics/behaviour for laser
class Laser {
  //hex code for laser is #dc0000
  PImage laser;
  int x, y, w, h, speed;
  // Constructor
  Laser(int x, int y) {
    this.x=x;
    this.y=y;
    w=5;
    h=20;
    speed=20;
    laser=loadImage("laser.png");
  }
  // Member Methods
  void display() {
    imageMode(CENTER);
    laser.resize(w, h);
    image(laser, x-16, y-43);
    //rectMode(CENTER);
    //fill(255,0,0);
    //rect(x,y,w,h);
  }
  void move() {
    y=y-speed;
  }

  boolean reachedTop() {
    if (y<0-10) {
      return true;
    } else {
      return false;
    }
  }

  boolean intersect(Rock r) {
    float d=dist(x, y, r.x, r.y);
    if (d<=40) {
      return true;
    } else {
      return false;
    }
  }
}
