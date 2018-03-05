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

    noFill();
    if (!ship.overheat) {
      stroke(ship.playerColor);
    } else {
      stroke(255);
    }
    rect(5, hudHeight / 2, width/2 - 5, hudHeight / 2 - 5);



    noStroke();
    if (!ship.overheat) {
      fill(ship.playerColor);
    } else {
      fill(255);
    }
    rect(5, hudHeight / 2, map(ship.heat, 0, 100, 0, width/2 - 5), hudHeight / 2 - 5);

    //PLAYER 2 HEAT BAR
    //fill(255, 255, 0);
    //rect(width / 2 + 5, hudHeight / 2, 300, hudHeight / 2 - 5);

    //stroke(255, 255, 0);
    //rect(width / 2 + 5, hudHeight / 2, width / 2 - 10, hudHeight / 2 - 5);
  }
}

void endGameScreen() {
    fill(255);
    textSize(40);
    text("FINAL SCORE: " + score, width / 2 - 200, height / 2 - 30);
    
    textSize(15);
    text("PRESS ANY KEY TO CONTINUE", width / 2 - 180, height / 2 + 30);
}

void mainMenu() {
    fill(255);
    textSize(40);
    text("METEROIDS", width / 2 - 100, height / 2 - 80);
    
    textSize(20);
    text("1 PLAYER", width / 2 - 40, height / 2 + 20);
    text("2 PLAYERS", width / 2 - 40, height / 2 + 60);
    
    fill(100);
    text("BY FERA", width - 120, height -30);
}