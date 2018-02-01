class PlayerProjectile {
  PVector location;
  PVector velocity;

  boolean isFinished = false;
  float distTraveled = 0;

  PlayerProjectile(PVector _location, PVector _velocity) {
    location = _location.copy();
    velocity = _velocity.copy();
  }

  void display() {
    noStroke();
    fill(255);
    ellipse(location.x, location.y, 3, 3);
  }

  void update() {
    location.add(velocity);
    distTraveled += velocity.mag();
    if (distTraveled > 400) {
      isFinished = true;
    }
  }
}