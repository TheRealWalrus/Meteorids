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
    text("LIVES: 666", 5, 20);

    textSize(20);
    text("LEVEL 13", width / 2 - 45, 20);

    textSize(20);
    text("SCORE: 170000", width - 165, 20);

    if (!ship.overheat) {
      lightness = 0;
    } else {
      //lightness += incrementLight;

      //if (lightness > 255) {
      //  incrementLight = abs(incrementLight) * -1;
      //} else if (lightness < 0) {
      //  incrementLight = abs(incrementLight);
      //}
      lightness = 255;
    }

    stroke(lightness, 255, 255);
    noFill();
    rect(5, hudHeight / 2, width/2 - 5, hudHeight / 2 - 5);

    //PLAYER 2 HEAT BAR
    stroke(255, 255, 0);
    rect(width / 2 + 5, hudHeight / 2, width / 2 - 10, hudHeight / 2 - 5);

    noStroke();
    fill(lightness, 255, 255);
    rect(5, hudHeight / 2, map(ship.heat, 0, 100, 0, width/2 - 5), hudHeight / 2 - 5);
    
    fill(255, 255, 0);
    rect(width / 2 + 5, hudHeight / 2, 300, hudHeight / 2 - 5);
  }
}