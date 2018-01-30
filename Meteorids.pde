Ship ship;
ArrayList<PlayerProjectile> playerProjectiles;

void setup() {
  size(640, 480);
  ship = new Ship(width / 2, height / 2);
  //playerProjectiles = new ArrayList();
}

void draw() {
  background(0);
  ship.display();
  ship.update();
  for (PlayerProjectile part : playerProjectiles) {
    part.display();
    part.update();
  }
  //fix this
  for (int i = playerProjectiles.size() - 1; i >= 0; i--) {
    PlayerProjectile part = playerProjectiles.get(i);
    if (part.isFinished) {
      playerProjectiles.remove(i);
    }
  }
  println(playerProjectiles.size());
}

void keyPressed() {
  ship.setMove(keyCode, true);
}

void keyReleased() {
  ship.setMove(keyCode, false);
}