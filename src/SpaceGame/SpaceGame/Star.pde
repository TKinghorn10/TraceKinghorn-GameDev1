//physics/behaviour for laser
class Star {
  int x, y, w, speed;
  PImage star;
  Star() {
    x=int(random(width));
    y=-10;
    w=int(random(3, 6));
    speed=int(random(3, 6));
    star=loadImage("star.png");
  }
  void display() {
    star.resize(w, w);
    image(star, x, y);
  }
  void move() {
    y+=speed;
  }
  boolean reachedBottom() {
    if (y>=height+10) {
      return true;
    } else {
      return false;
    }
  }
}
