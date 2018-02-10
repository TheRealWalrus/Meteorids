Ship ship;
Hud hud;
ArrayList<PlayerProjectile> playerProjectiles;
ArrayList<Asteroid> asteroids;

int hudHeight = 55;

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

  for (PlayerProjectile part : playerProjectiles) {
    part.display();
    part.update();
  }

  for (Asteroid part : asteroids) {
    part.display();
    part.update();
  }

  for (int i = playerProjectiles.size() - 1; i >= 0; i--) {
    PlayerProjectile part = playerProjectiles.get(i);
    if (part.isFinished) {
      playerProjectiles.remove(i);
    }
  }
  hud.drawHud();
}

void keyPressed() {
  ship.setMove(keyCode, true);
}

void keyReleased() {
  ship.setMove(keyCode, false);
}

void spawnRock() {
  asteroids.add(new Asteroid(random(width), random(height), int(random(3)) + 1));
}