class Asteroid {
  PVector location;
  PVector velocity;
  
  float r;
  
  Asteroid(float _x, float _y,int _type) {
    location = new PVector(_x, _y);
    velocity = PVector.fromAngle(random(2 * PI));
    velocity.mult(random(1.5) + 1.5);
    
    if (_type == 1) {
      r = 40;
    } else if (_type == 2) {
      r = 20;
    } else {
      r = 10;
    }
  }
  
  void display() {
    stroke(255);
    fill(0);
    ellipse(location.x, location.y, r * 2, r * 2);
  }
  
  void update() {
    location.add(velocity);
    
    if (location.x > width + 2 * r) {
      location.x -= width + 4 * r;
    } else if (location.x < -2 * r) {
      location.x += width + 4 * r;
    }

    if (location.y > height + 2 * r) {
      location.y -= height + 4 * r;
    } else if (location.y < -2 * r) {
      location.y += height + 4 * r;
    }
  }
}