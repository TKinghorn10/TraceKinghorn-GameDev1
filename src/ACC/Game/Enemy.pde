//Kolby Green + Maxwell Johnson
class Enemy {
  int w, h, xspeed;
  float  x, y;
  PImage guy;
  String type;
  Enemy(float x, float y, int w, int h, String type) {
    this.x=x;
    this.y=y;
    this.h=h;
    this.w=w;
    xspeed=3;
    this.type= type;
  }

  void display() {
    //rect(x, y, h, w);
    switch (type) {
    case "basic":
      guy = loadImage("guy.png");
      guy.resize (w, h);
      break;
    case "mousetrap":
      guy = loadImage("mousetrap.png");
      guy.resize (w*2, h*2);
      break;
    }
    //rect(x,y,w,h);
    imageMode(CENTER);
    image(guy, x, y);
  }

  void move() {
    PVector dude = new PVector(x, y);
    PVector them = new PVector (player.x-player.w, player.y);
    PVector move = PVector.sub(them, dude);
    move.normalize();
    move.mult(xspeed);
    x+=move.x;
    y+=move.y;
  }

  boolean punkThem() {
    float d = dist(x, y, player.x, player.y);
    if (d<50) {
      return true;
    } else {
      return false;
    }
  }

  boolean tooClose(Enemy guy) {
    float d = dist(x, y, guy.x, guy.y);
    if (d<50) {
      return true;
    } else {
      return false;
    }
  }

  boolean isOnScreen () {
    float d = dist(x, y, player.x, player.y);
    if (d<2000) return true;
    else return false;
  }
}
