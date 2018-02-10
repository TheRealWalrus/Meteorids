class PlayerProjectile {
  PVector location;
  PVector velocity;
  boolean isFinished = false;
  int timer;

  PlayerProjectile(PVector _location, PVector _velocity) {
    location = _location.copy();
    velocity = _velocity.copy();
    timer = millis();
  }

  void display() {
    noStroke();
    fill(255);
    ellipse(location.x, location.y, 2, 2);
  }

  void update() {
    location.add(velocity);

    if (millis() - timer > 700) {
      isFinished = true;
    }

    //LOOPING SPACE
    if (location.x > width) {
      location.x = 0;
    } else if (location.x < 0) {
      location.x = width;
    }

    if (location.y > height) {
      location.y = hudHeight;
    } else if (location.y < hudHeight) {
      location.y = height;
    }
  }
}