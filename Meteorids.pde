Ship ship;
ArrayList<PlayerProjectile> playerProjectiles;

void setup() {
  size(640, 480);
  ship = new Ship(width / 2, height / 2);
  playerProjectiles = new ArrayList();
}

void draw() {
  background(0);
  ship.display();
  ship.update();
  for (playerProjectile part : playerProjectiles) {
    part.display();
    part.update();
  }
  println(playerProjectiles.size());
}

void keyPressed() {
  ship.setMove(keyCode, true);
}

void keyReleased() {
  ship.setMove(keyCode, false);
}