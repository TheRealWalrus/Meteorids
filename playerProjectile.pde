class PlayerProjectile {
  PVector location;
  PVector velocity;
  boolean isFinished = false;
  int timer;

  PlayerProjectile(PVector _location, PVector _shipVel, float _dir) {
    location = _location.copy();
    velocity = PVector.fromAngle(_dir);
    velocity.mult(7);
    velocity.add(_shipVel);
    if (velocity.mag() < 7) {
      velocity.setMag(7);
    }
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
  
  boolean hits(Asteroid target) {
    float d = dist(location.x, location.y, target.location.x, target.location.y);
    if (d <= target.r) {
      return(true);
    } else {
      return(false);
    }
  }
}