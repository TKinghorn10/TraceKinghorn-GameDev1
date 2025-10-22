//Code for rock behaviour & physics
class Rock {
  int x, y, diam, speed, p, rhp;
  PImage rock;
  Rock() {
    x=int(random(width));
    y=-50;
    rhp=10;
    diam=int(random(50, 75));
    speed=int(random(2, 5));
    imageMode(CENTER);
    p=int(random(10));
    if (p>6.6) {
      rock=loadImage("rock.png");
    } else if (p<0.1) {
      rock=loadImage("dwayne.png");
    } else {
      rock=loadImage("pebble.png");
    }
  }
  void display() {
    imageMode(CENTER);
    rock.resize(diam, diam);
    image(rock, x, y);
  }
  void move() {
    y=y+speed;
  }
  boolean reachedBottom() {
    if (y>=height+100) {
      return true;
    } else {
      return false;
    }
  }
  void hit() {
    if (p>6.6 ) {
      rock=loadImage("brock.png");
    } else if (p<0.1) {
      rock=loadImage("bdwayne.png");
    } else {
      rock=loadImage("bpebble.png");
    }
    rhp-=5;
  }
}
