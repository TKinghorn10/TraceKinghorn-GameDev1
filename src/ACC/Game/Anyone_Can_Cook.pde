//Cormac Stone, with help from mr gpt
boolean l, r, u;  // movement keys
boolean onGround;
PImage back;
float gravity = 0.6;
float jumpForce = -12;
float camX = 0;
float camY = 0;
float camSmooth = 0.1;  // smaller = smoother
int currentLevel = 1;
char screen = 's';
boolean jumpPressed = false;
boolean jumpLastFrame = false;
boolean right;
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
Player player;
Map map;
Enemy guy;
Menu menu;
Button btnStart, btnPause, btnMenu, btnSettings, btnSave, btnPlay;

void setup() {
  size(600, 600);
  fullScreen(P2D);
  frameRate(60);//               x,  y, width, height
  back = loadImage("Background.png");
  back.resize(width,height);
  btnStart = new Button("Start", width/2, height/2+200, 140, 50);
  btnSettings = new Button("Settings", width/2-80, height/2+140, 160, 50);
  btnSave = new Button("Save", width/2-80, height/2+70, 160, 50);
  btnPlay = new Button("Unpause", width/2-80, height/2, 160, 50);
  menu = new Menu();
  map = new Map(currentLevel + ".csv");   // loads CSV or defaults if missing
  player = new Player(500, 500, 18, 80, map.cellSize/3); // (x, y, w, h, xspeed)
 // (x,y,w,h)
}

void draw() {
  switch(screen) {
  case 's':
    cursor(ARROW);
    menu.startScreen();
    break;
  case 'p':
    noCursor();
    background(back);
    fill(0);

    // --- Smooth camera follow ---
    float targetCamX = constrain(player.x - width / 2, 0, map.cols * map.cellSize - width);
    float targetCamY = constrain(player.y - height / 2, 0, map.rows * map.cellSize - height);
    camX = lerp(camX, targetCamX, camSmooth);
    camY = lerp(camY, targetCamY, camSmooth);

    // --- Apply camera ---

    pushMatrix();
    translate(-camX, -camY);
    map.drawMap();
    player.display();
    jumpPressed = u && !jumpLastFrame;
    jumpLastFrame = u;
    player.handleMovement();
    for (int i = 0; i < enemies.size(); i++) {
      Enemy guy = enemies.get(i);
      if (guy.isOnScreen()) {
    guy.display();
    guy.move();
    for (int j = 0; j<enemies.size(); j++) {
      if (i==j)continue;
      Enemy enemy = enemies.get(j);
      if (enemy.tooClose(guy)) {
        PVector me = new PVector(enemy.x, enemy.y);
        PVector you = new PVector (guy.x, guy.y);
        PVector move = PVector.sub(me, you);
        move.normalize();
        move.mult(2);
        enemy.x+=move.x;
        enemy.y+=move.y;
      }
    }
  }
    }
    popMatrix();
    textSize(50);
    fill(255,255,0);
    text("Health: " + player.health, 150, 100);
    println(currentLevel);
    //println("player x " + player.x, "player y " + player.y);
    //println("player iframes " + player.iFrames, "player health " + player.health);
    break;
  case 'z':
    cursor(ARROW);
    menu.pauseScreen();
    break;
  case 'e':
    menu.endScreen();
    noLoop();
    break;
  }
}

void keyPressed() {
  if (key == 'a' || keyCode == 37) {
    l = true;
    right = false;
  }
  if (key == 'd' || keyCode == 39) {
    r = true;
    right = true;
  }
  if (key == 'w' || key == ' ' || keyCode == 38) u = true;
  if (key == 'e') menu.display();
  if (key == '-') screen = 'e';
  if (key == 'z') screen = 'z';
}

void keyReleased() {
  if (key == 'a'|| keyCode == 37) l = false;
  if (key == 'd'|| keyCode == 39) r = false;
  if (key == 'w' || key == ' '|| keyCode == 38) u = false;
}

void mousePressed() {
  switch(screen) {
  case 's':
    if (btnStart.clicked()) {
      screen = 'p';
    }
    break;
  case 'z':
    if (btnPlay.clicked()) {
      screen = 'p';
    }
  }
}
