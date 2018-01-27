class PlayerProjectile {
  PVector location;
  PVector velocity;

  PlayerProjectile(float _x, float _y, float _dir) {
    float speed = 5;

    location = new PVector(_x, _y);
    velocity = new PVector(speed * cos(_dir + 1.5 * PI), speed * sin(_dir + 1.5 * PI));
  }

  void display() {
    noStroke();
    fill(255);
    ellipse(location.x, location.y, 3, 3);
  }
  
  void update() {
    location.add(velocity);
  }
}