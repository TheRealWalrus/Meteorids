Ship ship;
Hud hud;
ArrayList<PlayerProjectile> playerProjectiles;
ArrayList<Asteroid> asteroids;

int hudHeight = 55;
int score = 0;
int level = 1;
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

  spawnRock();
  spawnRock();
  spawnRock();
  spawnRock();
  spawnRock();
}

void draw() {
  background(0);
  ship.display();
  ship.update();

  for (PlayerProjectile bullet : playerProjectiles) {
    bullet.display();
    bullet.update();
    //for (Asteroid target : asteroids) {
    //  if (bullet.hits(target)) {
    //    score += target.scoreValue;
    //    if (target.type < 3) {
    //      asteroids.add(new Asteroid(target.location.x, target.location.y, target.type + 1));
    //    }
    //    target.isFinished = true;
    //    bullet.isFinished = true;
    //  }
    //}
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
      }
    }
  }

  for (Asteroid part : asteroids) {
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
}

void keyPressed() {
  ship.setMove(keyCode, true);
}

void keyReleased() {
  ship.setMove(keyCode, false);
}

void spawnRock() {
  asteroids.add(new Asteroid(random(width), random(height), 1));
}