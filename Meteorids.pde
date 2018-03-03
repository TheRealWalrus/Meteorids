//TO DO:

//alien spawn
//ship-alien collision
//end game screen

//main menu
//multiplayer

//improve particle effects

int testCounter = 0;

Ship ship;
Hud hud;
Alien alien;
ArrayList<PlayerProjectile> playerProjectiles;
ArrayList<AlienProjectile> alienProjectiles;
ArrayList<Asteroid> asteroids;
ArrayList<Partickle> partickles;

int hudHeight = 55;
int lives = 1;
int level = 1;
int score = 0;
PFont fontMain;
int astSizeLimit = 40;
int nextLevelTimer = -1;
int playerRespawnTimer = -1;
int endGameTimer = -1;

int alienFrequency = 840;
int aliensPerLevel = 5;
int alienCounter = 0;
int state = 1;

void setup() {
  size(853, 480);
  fontMain = loadFont("OCRAExtended-48.vlw");
  textFont(fontMain);

  ship = new Ship(width / 2, height / 2);
  hud = new Hud();
  playerProjectiles = new ArrayList();
  alienProjectiles = new ArrayList();
  asteroids = new ArrayList();
  partickles = new ArrayList();
  alien = new Alien(width / 2, height / 2, true);
  alien.isAlive = false;
  spawnAsteroids();
}

void draw() {
  background(0);
  if (state == 1) {
    runGame();
  } else if (state == 2) {
    endGameScreen();
  }
}

void endGameScreen() {
}

void runGame() {
  if (ship.isAlive) {
    ship.display();
    ship.update();
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
        explosion(target.location, target.type);
      }
    }
    //PLAYER IS HIT
    if (ship.isAlive && !ship.invincible) {
      if (polyLine(ship.vertices, bullet.location, bullet.lastLoc)) {
        ship.isAlive = false;
        lives--;
        explosion(ship.location, 4);
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
        if (target.type < 3) {
          asteroids.add(new Asteroid(target.location.x, target.location.y, target.type + 1));
          asteroids.add(new Asteroid(target.location.x, target.location.y, target.type + 1));
        }
        target.isFinished = true;
        bullet.isFinished = true;
        explosion(target.location, target.type);
      }
    }
    // ALIEN HIT DETECTION
    if (alien.isAlive) {
      if (polyLine(alien.verticesAbs, bullet.location, bullet.lastLoc)) {
        alien.isAlive = false;
        score += alien.scoreValue;
        int expType;
        if (alien.isBig) {
          expType = 1;
        } else {
          expType = 2;
        }
        explosion(alien.location, expType);
      }
    }
  }

  for (int i = 0; i < asteroids.size(); i++) {
    Asteroid part = asteroids.get(i);
    part.display();
    part.update();

    //SHIP COLLISION
    if (ship.isAlive && !ship.invincible) {
      if (polyCircle(ship.vertices, part.location, part.r)) {
        ship.isAlive = false;
        lives--;
        //ENHANCED LOOP NEEDS TO BE REPLACED
        if (part.type < 3) {
          asteroids.add(new Asteroid(part.location.x, part.location.y, part.type + 1));
          asteroids.add(new Asteroid(part.location.x, part.location.y, part.type + 1));
        }
        part.isFinished = true;
        explosion(part.location, part.type);
        explosion(ship.location, 4);
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
  checkAlienSpawn();
  checkNextLevel();
  checkEndGame();
}

//void checkPlayerRespawn() {
//  if (!ship.isAlive && playerRespawnTimer < 0) {
//    playerRespawnTimer = millis();
//  }

//  if (playerRespawnTimer >= 0 && millis() > playerRespawnTimer + 3000) {
//    ship = new Ship(width / 2, height / 2);
//    ship.invincible = true;
//    ship.invTimer = millis();
//    playerRespawnTimer = -1;
//  }
//}

void checkEndGame() {
  if (0 > lives && 0 > endGameTimer) {
    endGameTimer = millis();
  }

  if (endGameTimer >= 0 && millis() > endGameTimer + 3000) {
    state = 2;
  }
}

void keyPressed() {
  ship.setMove(keyCode, true);

  //NEXT LEVEL CHEAT
  if (keyCode == 67) { // "C" KEY
    for (int i = asteroids.size() - 1; i >= 0; i--) {
      asteroids.remove(i);
    }
  }

  //SPAWN ALIEN
  if (keyCode == 65) { // "A" KEY
    spawnAlien();
  }
}

void keyReleased() {
  ship.setMove(keyCode, false);
}

void checkPlayerRespawn() {
  if (!ship.isAlive && playerRespawnTimer < 0) {
    playerRespawnTimer = millis();
  }

  if (playerRespawnTimer >= 0 && millis() > playerRespawnTimer + 3000) {
    ship = new Ship(width / 2, height / 2);
    ship.invincible = true;
    ship.invTimer = millis();
    playerRespawnTimer = -1;
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

void explosion(PVector _location, int _type) {
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
    partickles.add(new Partickle(_location, _type));
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

  Partickle(PVector _location, int _type) {
    location = _location.copy();
    velocity = PVector.fromAngle(random(2 * PI));
    velocity.mult(random(1, 3));
    timer = millis();
    type = _type;

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
      fill(255);
      ellipse(location.x, location.y, 2, 2);
    } else {
      pushMatrix();

      stroke(ship.playerColor);
      fill(255, 0, 0);
      translate(location.x, location.y);
      rotate(theta);
      //ellipse(0, 0, 5, 5);
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