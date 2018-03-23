//TO DO:

//sounds !!! partially implemented, further research needed
//remove cheats
//Enter to continue

//fullscreen
//decelerating particles

import processing.sound.*;

SoundFile playerShootSound;

boolean isLeft, isRight, isUp, isCtrl, isW, isS, isA, isD, isF;

int state;
int lives;
int level;
int score;
int nextLevelTimer;
int player1RespawnTimer;
int player2RespawnTimer;
int endGameTimer;
int alienCounter;
int nextOneUp;

Ship ship;
Hud hud;
Alien alien;

ArrayList<PlayerProjectile> playerProjectiles;
ArrayList<AlienProjectile> alienProjectiles;
ArrayList<Asteroid> asteroids;
ArrayList<Partickle> partickles;
ArrayList<Ship> players;

PFont fontMain;
int hudHeight = 55;
int astSizeLimit = 40;
int alienFrequency = 840;
int aliensPerLevel = 5;
int playerMode = 1;

void setup() {
  size(853, 480, P2D);

  //playerShootSound = new SoundFile(this, "data/143609__d-w__weapons-synth-blast-03.wav");

  fontMain = loadFont("OCRAExtended-48.vlw");
  textFont(fontMain);
  setupMenu();
}

void setupGame() {
  state = 1;
  lives = 2;
  level = 1;
  score = 0;
  nextLevelTimer = -1;
  player1RespawnTimer = -1;
  player2RespawnTimer = -1;
  endGameTimer = -1;
  alienCounter = 0;
  nextOneUp = 10000;

  hud = new Hud();
  playerProjectiles = new ArrayList();
  alienProjectiles = new ArrayList();
  asteroids = new ArrayList();
  partickles = new ArrayList();
  players = new ArrayList();
  alien = new Alien(width / 2, height / 2, true);
  alien.isAlive = false;
  spawnAsteroids();

  if (playerMode == 1) {
    players.add(new Ship(width / 2, height / 2, 1));
  } else {
    players.add(new Ship(width / 3, height / 2, 1));
    players.add(new Ship(width / 3 * 2, height / 2, 2));
  }
}

void draw() {
  background(0);
  if (state == 1) {
    runGame();
  } else if (state == 2) {
    endGameScreen();
  } else {
    mainMenu();
  }
}

void oneUp() {
  if (score >= nextOneUp) {
    nextOneUp += 10000;
    if (players.get(0).isAlive == false && player1RespawnTimer == -1) {
      player1RespawnTimer = millis();
    } else if (players.get(1).isAlive == false && player2RespawnTimer == -1) {
      player2RespawnTimer = millis();
    } else {
      lives++;
    }
  }
}

void playerDies(Ship player) {
  player.isAlive = false;
  explosion(player.location, 4, player.playerColor);
  if (lives > 0) {
    if (player.player == 1) {
      player1RespawnTimer = millis();
    } else {
      player2RespawnTimer = millis();
    }
    lives--;
  }
}

boolean allPlayersDead() {
  if (playerMode == 1) {
    if (players.get(0).isAlive) {
      return false;
    } else {
      return true;
    }
  } else {
    if (players.get(0).isAlive == false && players.get(1).isAlive == false) {
      return true;
    } else {
      return false;
    }
  }
}

void checkEndGame() {
  if (allPlayersDead() && 0 > endGameTimer && player1RespawnTimer == -1 && player2RespawnTimer == -1) {
    endGameTimer = millis();
  }

  if (endGameTimer >= 0 && millis() > endGameTimer + 3000) {
    state = 2;
  }
}

void runGame() {
  for (Ship part : players) {
    if (part.isAlive) {
      part.display();
      part.update();
    }

    if (alien.isAlive && part.isAlive) {
      if (polyPoly(alien.verticesAbs, part.vertices)) {
        if (alien.isBig) {
          alien.isAlive = false;
          explosion(part.location, 1, 255);
        }
        playerDies(part);
      }
    }
  }

  for (AlienProjectile bullet : alienProjectiles) { //Do not use enhanced loop if you want add or remove elements during the loop
    bullet.display();
    bullet.update();
    for (int j = 0; j < asteroids.size(); j++) {
      Asteroid target = asteroids.get(j);
      if (bullet.hits(target)) {
        if (target.type < 3) {
          asteroids.add(new Asteroid(target.location.x, target.location.y, target.type + 1));
          asteroids.add(new Asteroid(target.location.x, target.location.y, target.type + 1));
        }
        target.isFinished = true;
        bullet.isFinished = true;
        explosion(target.location, target.type, 255);
      }
    }
    //PLAYER IS HIT
    for (Ship part : players) {
      if (part.isAlive && !part.invincible) {
        if (polyLine(part.vertices, bullet.location, bullet.lastLoc)) {
          playerDies(part);
        }
      }
    }
  }

  if (alien.isAlive) {
    alien.display();
    alien.update();
    alien.shoot();
  }

  for (PlayerProjectile bullet : playerProjectiles) { //Do not use enhanced loop if you want add or remove elements during the loop
    bullet.display();
    bullet.update();
    for (int j = 0; j < asteroids.size(); j++) {
      Asteroid target = asteroids.get(j);
      if (bullet.hits(target)) {
        score += target.scoreValue;
        oneUp();
        if (target.type < 3) {
          asteroids.add(new Asteroid(target.location.x, target.location.y, target.type + 1));
          asteroids.add(new Asteroid(target.location.x, target.location.y, target.type + 1));
        }
        target.isFinished = true;
        bullet.isFinished = true;
        explosion(target.location, target.type, 255);
      }
    }
    // ALIEN HIT DETECTION
    if (alien.isAlive) {
      if (polyLine(alien.verticesAbs, bullet.location, bullet.lastLoc)) {
        alien.isAlive = false;
        score += alien.scoreValue;
        oneUp();
        int expType;
        if (alien.isBig) {
          expType = 1;
        } else {
          expType = 2;
        }
        explosion(alien.location, expType, 255);
      }
    }
  }

  for (int i = 0; i < asteroids.size(); i++) {
    Asteroid part = asteroids.get(i);
    part.display();
    part.update();

    //SHIP COLLISION
    for (Ship partShip : players) {
      if (partShip.isAlive && !partShip.invincible) {
        if (polyCircle(partShip.vertices, part.location, part.r)) {
          playerDies(partShip);
          part.isFinished = true;
          explosion(part.location, part.type, 255);
          if (part.type < 3) {
            asteroids.add(new Asteroid(part.location.x, part.location.y, part.type + 1));
            asteroids.add(new Asteroid(part.location.x, part.location.y, part.type + 1));
          }
        }
      }
    }
  }

  for (Partickle part : partickles) {
    part.display();
    part.update();
  }

  //REMOVE LOOPS
  for (int i = playerProjectiles.size() - 1; i >= 0; i--) {
    PlayerProjectile part = playerProjectiles.get(i);
    if (part.isFinished) {
      playerProjectiles.remove(i);
    }
  }

  for (int i = alienProjectiles.size() - 1; i >= 0; i--) {
    AlienProjectile part = alienProjectiles.get(i);
    if (part.isFinished) {
      alienProjectiles.remove(i);
    }
  }

  for (int i = asteroids.size() - 1; i >= 0; i--) {
    Asteroid part = asteroids.get(i);
    if (part.isFinished) {
      asteroids.remove(i);
    }
  }

  for (int i = partickles.size() - 1; i >= 0; i--) {
    Partickle part = partickles.get(i);
    if (part.isFinished) {
      partickles.remove(i);
    }
  }

  hud.drawHud();
  checkPlayerRespawn();
  //println(player1RespawnTimer);
  checkAlienSpawn();
  checkNextLevel();
  checkEndGame();
}

void keyPressed() {
  if (state == 2) {
    setupMenu();
  } else if (state == 0) {
    if (keyCode == UP || keyCode == DOWN) {
      if (playerMode == 1) {
        playerMode = 2;
        setCursor();
      } else if (playerMode == 2) {
        playerMode = 1;
        setCursor();
      }
    }
    if (keyCode == ENTER || keyCode == CONTROL) {
      setupGame();
    }
  } else {

    setMove(keyCode, true);

    //NEXT LEVEL CHEAT
    if (keyCode == 67) { // "C" KEY
      for (int i = asteroids.size() - 1; i >= 0; i--) {
        asteroids.remove(i);
      }
    }

    //SPAWN ALIEN
    if (keyCode == 73) { // "I" KEY
      spawnAlien();
    }
  }
}

void keyReleased() {
  setMove(keyCode, false);
}

boolean setMove(int k, boolean b) { //"switch" is similar to the "else if" structure 
  switch (k) {
  case UP:
    return isUp = b;

  case LEFT:
    return isLeft = b;

  case RIGHT:
    return isRight = b;

  case CONTROL:
    return isCtrl = b;

  case 69:
    return isW = b;

  case 83:
    return isA = b;

  case 70:
    return isD = b;

  case 71:
    return isF = b;

  default:
    return b;
  }
}

void checkPlayerRespawn() {
  //if (!ship.isAlive && playerRespawnTimer < 0) {
  //  playerRespawnTimer = millis();
  //}
  if (player1RespawnTimer >= 0 && millis() > player1RespawnTimer + 3000) {
    if (playerMode == 1) {
      players.set(0, new Ship(width / 2, height / 2, 1));
    } else {
      players.set(0, new Ship(width / 3, height / 2, 1));
    }
    Ship part = players.get(0);
    part.turnInvincible();
    player1RespawnTimer = -1;
  }

  if (player2RespawnTimer >= 0 && millis() > player2RespawnTimer + 3000) {
    players.set(1, new Ship(width / 3 * 2, height / 2, 2));
    Ship part = players.get(1);
    part.turnInvincible();
    player2RespawnTimer = -1;
  }
}

void spawnAsteroids() {
  for (int i = 0; i < level + 4; i++) {
    float spawnX;
    float spawnY;
    int spawnAxis = int(random(2));
    if (spawnAxis == 1) {
      spawnX = random(-astSizeLimit, width + astSizeLimit);
      spawnY = height + astSizeLimit;
    } else {
      spawnX = width + astSizeLimit;
      spawnY = random(-astSizeLimit, height + astSizeLimit);
    }
    asteroids.add(new Asteroid(spawnX, spawnY, 1));
  }
}

void checkNextLevel() {
  if (asteroids.size() == 0 && nextLevelTimer < 0) {
    nextLevelTimer = millis();
  }

  if (nextLevelTimer >= 0 && millis() > nextLevelTimer + 3000) {
    spawnAsteroids();
    alienCounter = 0;
    level++;
    nextLevelTimer = -1;
  }
}

void explosion(PVector _location, int _type, color _color) {
  int minPartickles;
  int maxPartickles;

  if (_type == 1) {
    minPartickles = 5;
    maxPartickles = 8;
  } else if (_type == 2) {
    minPartickles = 4;
    maxPartickles = 6;
  } else if (_type == 3) {
    minPartickles = 3;
    maxPartickles = 5;
  } else {
    minPartickles = 4;
    maxPartickles = 4;
  }

  for (int k = 0; k < int(random(minPartickles, maxPartickles + 1)); k++) {
    partickles.add(new Partickle(_location, _type, _color));
  }
}

class Partickle {
  PVector location;
  PVector velocity;
  int duration;
  int timer;
  boolean isFinished = false;
  float lineLength;
  float angVel = random(0.2);
  float theta;
  int type;
  color pColor;

  Partickle(PVector _location, int _type, color _color) {
    location = _location.copy();
    velocity = PVector.fromAngle(random(2 * PI));
    velocity.mult(random(1, 3));
    timer = millis();
    type = _type;
    pColor = _color;

    if (_type == 1) {
      duration = 500;
    } else if (_type == 2) {
      duration = 300;
    } else if (_type == 3) {
      duration = 150;
    } else {
      duration = 500;
      lineLength = 15;
      theta = 0;
    }
  }

  void display() {
    if (type < 4) {
      noStroke();
      fill(pColor);
      ellipse(location.x, location.y, 2, 2);
    } else {
      pushMatrix();

      stroke(pColor);
      translate(location.x, location.y);
      rotate(theta);
      line(-lineLength / 2, 0, lineLength / 2, 0);
      popMatrix();
    }
  }

  void update() {
    if (type == 4) {
      theta += angVel;
    }
    location.add(velocity);
    if (millis() > timer + duration) {
      isFinished = true;
    }
  }
}

void checkAlienSpawn() {
  if (!alien.isAlive && int(random(0, alienFrequency)) == 0 && alienCounter < aliensPerLevel) {
    spawnAlien();
    alienCounter++;
  }
}

void spawnAlien() {
  float spawnX;
  float spawnY;

  if (randomBool()) {
    spawnX = random(-1 * alien.vertices[2].x, width + alien.vertices[2].x);
    spawnY = height + alien.vertices[3].y;
  } else {
    spawnX = width + alien.vertices[2].x;
    spawnY = random(-1 * alien.vertices[3].y, height + alien.vertices[3].y);
  }
  alien = new Alien(spawnX, spawnY, randomBool());
}

boolean randomBool() {
  if (random(1) > 0.5) {
    return true;
  } else {
    return false;
  }
}