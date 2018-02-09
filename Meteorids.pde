Ship ship;
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
  //println(ship.heat);
  
  //HUD
  fill(100);
  noStroke();
  rect(0, 0, width, hudHeight);
  
  fill(255);
  textSize(20);
  text("LIVES: 666", 5, 20);
  
  textSize(20);
  text("LEVEL 13", width / 2 - 45, 20);
  
  textSize(20);
  text("SCORE: 170000", width - 165, 20);
  
  stroke(0, 255, 255);
  noFill();
  rect(5, hudHeight / 2, width/2 - 5, hudHeight / 2 - 5);
  
  stroke(255, 255, 0);
  rect(width / 2 + 5, hudHeight / 2, width / 2 - 10, hudHeight / 2 - 5);
  
  noStroke();
  fill(0, 255, 255);
  rect(5, hudHeight / 2, map(ship.heat, 0, 100, 0, width/2 - 5), hudHeight / 2 - 5);
  
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