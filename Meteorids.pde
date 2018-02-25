//TO DO:
//improve col detection
//add alien ships
//multiplayer
//main menu

int testCounter = 0;

Ship ship;
Hud hud;
Alien alien;
ArrayList<PlayerProjectile> playerProjectiles;
ArrayList<AlienProjectile> alienProjectiles;
ArrayList<Asteroid> asteroids;
ArrayList<Partickle> partickles;

int hudHeight = 55;
int lives = 666;
int level = 1;
int score = 0;
PFont fontMain;
int astSizeLimit = 40;
int nextLevelTimer = -1;
int playerRespawnTimer = -1;

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
    if (ship.isAlive) {
      if (polyLine(ship.vertices, bullet.location, bullet.lastLoc)) {
        ship.isAlive = false;
        lives--;
        //ship.invincible = true;
        //ship.invTimer = millis();
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
    //TESTS ALIEN HIT DETECTION
    if (alien.isAlive) {
      if (polyLine(alien.verticesAbs, bullet.location, bullet.lastLoc)) {
        alien.isAlive = false;
        score += alien.scoreValue;
      }
    }
  }

  for (Asteroid part : asteroids) {
    part.display();
    part.update();

    //SHIP COLLISION
    //PVector noseLoc = PVector.add(ship.nose, ship.location);
    //PVector tail1Loc = PVector.add(ship.tail1, ship.location);
    //PVector tail2Loc = PVector.add(ship.tail2, ship.location);
    //if (lineCircle(noseLoc, tail1Loc, part.location, part.r) || lineCircle(noseLoc, tail2Loc, part.location, part.r)) {
    //  if (!ship.invincible) {
    //    lives--;
    //    ship.invincible = true;
    //    ship.invTimer = millis();
    //  }
    //}
    if (ship.isAlive) {
      if (polyCircle(ship.vertices, part.location, part.r)) {
        ship.isAlive = false;
        lives--;
        //if (!ship.invincible) {
        //  lives--;
        //  ship.invincible = true;
        //  ship.invTimer = millis();
        //}
      }
    }
  }

  for (Partickle part : partickles) {
    part.display();
    part.update();
  }
  hud.drawHud();

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
  checkPlayerRespawn();
  checkNextLevel();
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
    alien = new Alien(random(width), random(height), false);
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
  } else {
    minPartickles = 3;
    maxPartickles = 5;
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

  Partickle(PVector _location, int _type) {
    location = _location.copy();
    velocity = PVector.fromAngle(random(2 * PI));
    velocity.mult(random(1, 3));
    timer = millis();

    if (_type == 1) {
      duration = 500;
    } else if (_type == 2) {
      duration = 300;
    } else if (_type == 3) {
      duration = 150;
    } else {
      
    }
  }

  void display() {
    noStroke();
    fill(255);
    ellipse(location.x, location.y, 2, 2);
  }

  void update() {
    location.add(velocity);
    if (millis() > timer + duration) {
      isFinished = true;
    }
  }
}