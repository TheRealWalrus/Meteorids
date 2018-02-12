class Partickle {
  PVector location;
  PVector velocity;
  int duration;
  int timer;
  boolean isFinished = false;
  
  Partickle(PVector _location, int _type) {
    location = _location.copy();
    velocity = PVector.fromAngle(random(2 * PI));
    velocity.mult(random(1, 3));
    timer = millis();
    
    if (_type == 1) {
      duration = 500;
    } else if (_type == 2) {
      duration = 300;
    } else if (_type == 3) {
      duration = 150;
    }
  }
  
  void display() {
    noStroke();
    fill(255);
    ellipse(location.x, location.y, 2, 2);
  }
  
  void update() {
    location.add(velocity);
    if (millis() > timer + duration) {
      isFinished = true;
    }
  }
}