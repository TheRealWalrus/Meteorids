class Asteroid {
  PVector location;
  PVector velocity;
  float hypo[];
  float r;
  float theta;
  float angVel;
  boolean isFinished = false;
  int scl = 10;
  float dir = 0;
  int scoreValue;
  int type;

  Asteroid(float _x, float _y, int _type) {
    location = new PVector(_x, _y);
    velocity = PVector.fromAngle(random(2 * PI));
    velocity.mult(random(1.5) + 1.5);
    angVel = random(-0.02, 0.02);
    type = _type;

    if (_type == 1) {
      r = 40;
      scoreValue = 30;
    } else if (_type == 2) {
      r = 20;
      scoreValue = 50;
    } else {
      r = 10;
      scoreValue = 100;
    }

    theta = 2 * PI / scl;
    hypo = new float[scl];
    for (int i = 0; i < hypo.length; i++) {
      hypo[i] = random(r - r * 0.2, r + r * 0.2);
    }
  }

  void display() {
    pushMatrix();
    translate(location.x, location.y);
    rotate(dir);
    
    stroke(255);
    fill(0);

    beginShape();
    int j = 0;
    for (float i = 0; i < 2 * PI; i += theta) {
      float x = hypo[j] * cos(i);
      float y = hypo[j] * sin(i);
      vertex(x + 0, y + 0);
      j++;
    }    
    endShape(CLOSE);

    //SHOW HITBOX
    stroke(255, 0, 0);
    noFill();
    //ellipse(0, 0, r * 2, r * 2);
    popMatrix();
  }

  void update() {
    location.add(velocity);
    
    dir += angVel;
    if (dir > 2 * PI) {
      dir -= 2 * PI;
    } else if (dir < 0) {
      dir += 2 * PI;
    }

    //LOOPING SPACE
    if (location.x > width + r) {
      location.x -= width + 2 * r;
    } else if (location.x < -1 * r) {
      location.x += width + 2 * r;
    }

    if (location.y > height + r) {
      location.y -= height - hudHeight + 2 * r;
    } else if (location.y < hudHeight -1 * r) {
      location.y += height - hudHeight + 2 * r;
    }
  }
}