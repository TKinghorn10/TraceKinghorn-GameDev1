// Trace Kinghorn | September 17 2025 | SpaceGame
int sc, t, hp, h, pt, l;
float sh, sf;
String gameState = "start"; // Could be start, playing, won, or lost
import processing.sound.*;
SoundFile sound, back, laserz, shrink, explode, relaser, fix, owie;
PImage start, lose, win;
Spaceship marcus;
ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<PowerUp> powerup = new ArrayList<PowerUp>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
ArrayList<Star> stars = new ArrayList<Star>();
Timer johnny, david;
void setup() {
  size(600, 700);
  background(10, 10, 50);
  marcus=new Spaceship(this);
  sc=0;
  t=700;
  l=0;
  pt=10000;
  hp=100;
  h=0;
  sh=0;
  sf=0;
  johnny=new Timer(t);
  johnny.start();
  david=new Timer(pt);
  david.start();
  start = loadImage("start.png");
  lose = loadImage("lose.png");
  win = loadImage("win.png");
  sound = new SoundFile(this, "sound.mp3");
  back = new SoundFile(this, "back.mp3");
  laserz = new SoundFile(this, "laserz.mp3");
  shrink = new SoundFile(this, "explode.mp3");
  explode = new SoundFile(this, "esplode.mp3");
  relaser = new SoundFile(this, "relaser.mp3");
  fix = new SoundFile(this, "fix.mp3");
  owie = new SoundFile(this, "owie.mp3");
}

void draw() {
  if (gameState.equals("lost")) {
    gameOver();
  } else if (gameState.equals("won")) {
    winScreen();
  } else if (gameState.equals("start")) {
    startScreen();
  } else if (gameState.equals("playing")) {
    background(10, 10, 25);
    scorePanel();

    //Distrite stars
    stars.add(new Star());

    //Rock timer for distribution
    if (johnny.isFinished()) {
      rocks.add(new Rock());
      johnny=new Timer(t);
      johnny.start();
    }
    //PowerUp timer for distribution
    if (david.isFinished()) {
      powerup.add(new PowerUp(this));
      david=new Timer(pt);
      david.start();
    }
    //Display/movement of all rocks
    for (int i = 0; i < rocks.size(); i++) {
      Rock r = rocks.get(i);
      r.display();
      r.move();
      if (marcus.intersect(r)) {
        rocks.remove(r);
        hp-=10;
        sc-=25;
        owie.play();
      }
      if (r.reachedBottom()) {
        sc-=10;
        if (sc<9500) {
          hp-=5;
        }
        rocks.remove(r);
        i--;
      }
      println("Rocks:"+rocks.size());
    }
    //Display of ship & hiding mouse
    marcus.display();
    marcus.move(mouseX, mouseY);
    if (mousePressed) {
      noCursor();
    }
    //FOR loop for lasers display & removal
    for (int i =  lasers.size()-1; i>0; i--) {
      Laser l = lasers.get(i);
      for (int j=0; j<rocks.size(); j++) {
        Rock r=rocks.get(j);
        if (l.intersect(r)) {
          lasers.remove(l);
          h=1;
          sh+=1;
          if (r.rhp==10) {
            r.hit();
            shrink.play();
            h=1;
          } else if (l.intersect(r) && r.rhp==5 && h==1) {
            rocks.remove(r);
            explode.play();
            sc+=50;
            i--;
          }
        }
      }
      l.display();
      l.move();
      if (l.reachedTop()) {
        lasers.remove(l);
      }
      println("Lasers:"+lasers.size());
    }

    for (int i = 0; i < stars.size(); i++) {
      Star star = stars.get(i);
      star.display();
      star.move();
      if (star.reachedBottom()) {
        stars.remove(star);
        i--;
      }
      println("Rocks:"+rocks.size());
    }
    for (int i=0; i<powerup.size(); i++) {
      PowerUp pu = powerup.get(i);
      pu.display();
      pu.move();
      if (marcus.intersect(pu)) {
        if (pu.type==1) {
          marcus.lc+=200;
          relaser.play();
        } else if (pu.type==0) {
          hp+=25;
          fix.play();
        }
        powerup.remove(pu);
      }
    }
    if (back.isPlaying()) {
      back.stop();
    }
    if (!sound.isPlaying()) {
      sound.play();
    }
  }
  //Levels of difficulty
  if (l==1) {
    t=600;
  } else if (l==2) {
    t=500;
  } else if (l==3) {
    t=400;
  } else if (l==4) {
    t=300;
  } else if (l==5) {
    t=1;
  }
}
void mousePressed() {
  if (marcus.fire()) {
    lasers.add(new Laser(marcus.x, marcus.y));
    lasers.add(new Laser(marcus.x+32, marcus.y));
    if (sc<9500) {
      marcus.lc-=2;
    }
    laserz.play();
    sf+=2;
  }
  noCursor();
}
void scorePanel() {
  fill(100, 100);
  rect(0, 0, 200, 140);
  fill(255);
  textSize(2);
  text("--------------------------------------------------------------------------------------------------------------", 5, 15);
  textSize(10);
  text("Information", 5, 10);
  textSize(20);
  text("Score:"+sc, 5, 30);
  text("Health:"+hp, 5, 50);
  text("Lasers remaining:"+marcus.lc, 5, 70);
  text("Lasers fired:"+sf, 5, 90);
  text("Shots hit:"+sh, 5, 110);
  if (sf==0) {
    text ("Accuracy:100", 5, 130);
  } else text("Accuracy:"+(sh/sf)*100, 5, 130);
  if (sc>=1500 && sc<=1550) {
    text("Level up!", 5, 155);
    l=1;
  } else if (sc>=3000 && sc<=3050) {
    text("Level up!", 5, 155);
    l=2;
  } else if (sc>=4500 && sc<=4500) {
    text("Level up!", 5, 155);
    l=3;
  } else if (sc>=7000 && sc<=7050) {
    text("Level up!", 5, 155);
    l=4;
  } else if (sc>=9500 &&sc<=9550) {
    l=5;
    text("Level up! Go, go, go!", 5, 155);
  } else if (sc>=12000) {
    gameState = "won";
    return;
  }
  if (hp<=0) {
    gameState = "lost";
    return;
  }


  //if(mousePressed) {
  //  marcus.lc-=2;
  //}
}
void gameOver() {
  if (sound.isPlaying()) {
    sound.stop();
  }
  imageMode(CORNER);
  image(lose, 0, 0);
  fill(175);
  textSize(40);
  text("Your final score was: "+sc, 100, 525);
  text("Press 'Esc' to exit.", 150, 600);
}

void startScreen() {
  image(start, 0, 0);
  if (keyCode == 32) {
    gameState = "playing";
  }
  if (!back.isPlaying()) {
    back.play();
  }
}
void winScreen() {
  imageMode(CORNER);
  image(win, 0, 0);
  fill(200);
  text("Press [ESC] to close.", 200, 500);
  if (!back.isPlaying()) {
    back.play();
  }
  if (sound.isPlaying()) {
    sound.stop();
  }
}
