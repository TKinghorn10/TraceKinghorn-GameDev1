//Cormac Stone, with help from mr gpt
class Player {
  float x, y, w, h;
  float xspeed;
  float vy;
  boolean onGround = false;
  boolean inWater  = false;
  int health = 5;
  int jAvail;
  int tJAvail = 3;
  int iFrames = 0;
  int maxIFrames = 85;
  float knockbackVX = 0;
  float knockFriction = 0.9;
  PImage remmy;

  Player(float x, float y, float w, float h, float xspeed) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.xspeed = xspeed;
  }

  void display() {
    fill(255, 0, 0);
    //rect(x,y,w,h);

    if (right == true)
    {
      remmy = loadImage("remmeigh3-3.png");
    } else {
      remmy = loadImage("remmeigh_left.png");
    }
    imageMode(CORNER);
    image(remmy, x - 40, y - 20);
  }




  void handleMovement() {

    // ----------------------
    // WATER CHECK
    // ----------------------
    int midCol = int((x + w/2) / map.cellSize);
    int midRow = int((y + h/2) / map.cellSize);

    int tile = map.getTile(midCol, midRow);
    inWater = (tile == 2);

    float waterGravity = gravity * 0.2;
    float waterXspeed = xspeed * 0.5;
    float swimForce = -1.5;
    float maxWaterFallSpeed = 2;
    x += knockbackVX;
    knockbackVX *= knockFriction;
    if (abs(knockbackVX) < 0.1) knockbackVX = 0;

    // ----------------------
    // HORIZONTAL MOVEMENT
    // ----------------------
    float horizontalSpeed = inWater ? waterXspeed : xspeed;
    float newX = x;

    if (l) newX -= horizontalSpeed;
    if (r) newX += horizontalSpeed;

    int top = int(y / map.cellSize);
    int bottom = int((y + h - 1) / map.cellSize);

    if (newX > x) {
      int col = int((newX + w - 1) / map.cellSize);
      for (int j = top; j <= bottom; j++) {
        if (map.isSolid(col, j)) {
          newX = col * map.cellSize - w;
          break;
        }
      }
    } else if (newX < x) {
      int col = int(newX / map.cellSize);
      for (int j = top; j <= bottom; j++) {
        if (map.isSolid(col, j)) {
          newX = (col + 1) * map.cellSize;
          break;
        }
      }
    }

    x = newX;


    // ----------------------
    // GRAVITY
    // ----------------------
    if (inWater) {
      vy += waterGravity;
      if (vy > maxWaterFallSpeed) vy = maxWaterFallSpeed;
    } else {
      if (!onGround) vy += gravity;
    }


    // ----------------------
    // VERTICAL MOVEMENT
    // ----------------------
    float newY = y + vy;

    int left = int(x / map.cellSize);
    int right = int((x + w - 1) / map.cellSize);

    onGround = false;

    if (vy > 0) { // falling
      int row = int((newY + h) / map.cellSize);
      for (int c = left; c <= right; c++) {
        if (map.isSolid(c, row)) {
          newY = row * map.cellSize - h;
          vy = 0;
          onGround = true;

          // reset jumps ONLY on real landing
          jAvail = tJAvail;

          break;
        }
      }
    } else if (vy < 0) { // going upward
      int row = int(newY / map.cellSize);
      for (int c = left; c <= right; c++) {
        if (map.isSolid(c, row)) {
          newY = (row + 1) * map.cellSize;
          vy = 0;
          break;
        }
      }
    }

    y = newY;

    if (!inWater) {

      if (jumpPressed && jAvail > 0) {
        vy = jumpForce;
        jAvail--;
        onGround = false;
      }
    } else {
      // swimming
      if (u) vy += swimForce;
      jAvail = tJAvail;  // reset when in water
    }
    // --------------------
    // Enemy Collision
    // --------------------
    if (iFrames <= 0) {
      for (Enemy guy : enemies) {
        if (guy.punkThem()) {

          // Horizontal knock direction
          float dir = ((x + w/2) < (guy.x + guy.w/2)) ? -1 : 1;

          health -= 1;

          // Smooth knockback: set velocity instead of teleport
          knockbackVX = dir * 30; // strength
          vy = -6;               // upward bump

          // Start invincibility
          iFrames = maxIFrames;
        }
      }
    }


    // ----------------------
    // MAP TRANSITION
    // ----------------------
    int leftTile = map.getTile(int(x / map.cellSize), midRow);
    int rightTile = map.getTile(int((x + w - 1) / map.cellSize), midRow);

    if (leftTile == 5) {
      loadNextMap("left");
      return;
    }
    if (rightTile == 5) {
      loadNextMap("right");
      return;
    }
    if (iFrames > 0) iFrames -= 100/60;
    if (health <= 0) screen = 'e';
  }


  void loadNextMap(String e) {
    if (e.equals("left")) currentLevel--;
    if (e.equals("right")) currentLevel++;

    String nextMapFile = currentLevel + ".csv";
    println("Loading next map: " + nextMapFile);

    map = new Map(nextMapFile);

    player.x = 100;
    player.y = 100;
    player.vy = 0;

    camX = 0;
    camY = 0;
    for(int i = 0; i < enemies.size(); i++){
      Enemy enemy = enemies.get(i);
      enemies.remove(enemy);
    }
  }
}
