//ALPHA
//TO DO:
//rewrite spaceship draw without transformations
//implement line-circle col detection 

Ship ship;
Hud hud;
ArrayList<PlayerProjectile> playerProjectiles;
ArrayList<Asteroid> asteroids;
ArrayList<Partickle> partickles;

int hudHeight = 55;
int score = 0;
int level = 0;
PFont fontMain;

void setup() {
  size(853, 480);
  //fullScreen();
  fontMain = loadFont("OCRAExtended-48.vlw");
  textFont(fontMain);

  ship = new Ship(width / 2, height / 2);
  hud = new Hud();
  playerProjectiles = new ArrayList();
  asteroids = new ArrayList();
  partickles = new ArrayList();
}

void draw() {
  background(0);
  ship.display();
  ship.update();

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
  }

  for (Asteroid part : asteroids) {
    part.display();
    part.update();
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
  checkNextLevel();
}

void keyPressed() {
  ship.setMove(keyCode, true);
}

void keyReleased() {
  ship.setMove(keyCode, false);
}

void checkNextLevel() {
  if (asteroids.size() == 0) {
    for (int i = 0; i < level + 4; i++) {
      asteroids.add(new Asteroid(random(width), random(height), 1));
    }
    level++;
  }
}

void explosion(PVector _location,int _type) {
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