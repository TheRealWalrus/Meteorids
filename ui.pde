class Hud {
  float lightness;
  int incrementLight;

  Hud() {
    lightness = 0;
    incrementLight = 20;
  }

  void drawHud() {
    //HUD
    fill(100);
    noStroke();
    rect(0, 0, width, hudHeight);

    fill(255);
    textSize(20);
    text("LIVES: " + lives, 5, 20);

    textSize(20);
    text("LEVEL " + level, width / 2 - 45, 20);

    textSize(20);
    text("SCORE: " + score, width - 165, 20);

    textSize(20);
    text("HEAT: ", 5, 45);

    //PLAYER 1 HEAT BAR
    noFill();
    color bar1Color = players.get(0).playerColor;
    if (!players.get(0).overheat) {
      stroke(bar1Color);
    } else {
      stroke(255);
    }

    int heatBarStartX = 70;
    int heatBarLength = width/2 - heatBarStartX - 5;
    rect(heatBarStartX, hudHeight / 2, heatBarLength, hudHeight / 2 - 5);

    noStroke();
    if (!players.get(0).overheat) {
      fill(bar1Color);
    } else {
      fill(255);
    }

    rect(heatBarStartX, hudHeight / 2, map(players.get(0).heat, 0, 100, 0, heatBarLength), hudHeight / 2 - 5);

    //PLAYER 2 HEAT BAR
    if (playerMode == 2) {
      noFill();
      color bar2Color = players.get(1).playerColor;
      if (!players.get(1).overheat) {
        stroke(bar2Color);
      } else {
        stroke(255);
      }

      heatBarStartX = width - heatBarLength - 5;
      rect(heatBarStartX, hudHeight / 2, heatBarLength, hudHeight / 2 - 5);

      noStroke();
      if (!players.get(1).overheat) {
        fill(bar2Color);
      } else {
        fill(255);
      }

      rect(heatBarStartX, hudHeight / 2, map(players.get(1).heat, 0, 100, 0, heatBarLength), hudHeight / 2 - 5);
    }
  }
}

void endGameScreen() {
  fill(255);
  
  textSize(40);
  text("GAME OVER", width / 2 - 120, height / 2 - 40);
  
  textSize(15);
  text("SCORE: " + score, width / 2 - 80, height / 2 + 10);

  textSize(15);
  text("PRESS ANY KEY TO CONTINUE", width / 2 - 120, height / 2 + 120);
}

void mainMenu() {
  for (int i = 0; i < asteroids.size(); i++) {
    Asteroid part = asteroids.get(i);
    part.display();
    part.update();
  }

  ship.display();

  fill(255);
  textSize(40);
  text("METEROIDS", width / 2 - 100, height / 2 - 80);

  textSize(20);
  text("1 PLAYER", width / 2 - 40, height / 2 + 20);
  text("2 PLAYERS", width / 2 - 40, height / 2 + 60);

  fill(100);
  text("BY FERA", width - 120, height -30);
}

void setupMenu() {
  state = 0;
  asteroids = new ArrayList();
  spawnAsteroidsRandom();
  setCursor();
}

void spawnAsteroidsRandom() {
  for (int i = 0; i < 10; i++) {
    asteroids.add(new Asteroid(random(width), random(height), int(random(1, 4))));
  }
}

void setCursor() {
  if (playerMode == 1) {
    ship = new Ship(width / 2 - 80, height / 2 + 14, 1);
  } else {
    ship = new Ship(width / 2 - 80, height / 2 + 54, 1);
  }
  ship.playerColor = 255;
  ship.setRelative(true);
  for (int i = 0; i < ship.vertices.length; i++) {
    ship.vertices[i].rotate(0.5 * PI);
  }
  ship.setRelative(false);
}