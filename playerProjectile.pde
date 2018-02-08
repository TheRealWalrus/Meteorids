class PlayerProjectile {
  PVector location;
  PVector velocity;

  boolean isFinished = false;
  //float distTraveled = 0;
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
    
    if (millis() - timer > 1200) {
      isFinished = true;
    }
    
    /*distTraveled += velocity.mag();
    if (distTraveled > 400) {
      isFinished = true;
    }*/
    
    
  }
}