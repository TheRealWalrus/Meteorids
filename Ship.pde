class Ship {
  PVector location;
  PVector velocity;
  PVector acceleration;

  float dir = 0;
  float angVel = 0.1;

  boolean isLeft, isRight, isUp, isSpace;

  Ship(float _x, float _y) {
    location = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }
  void display() {

    pushMatrix();
    translate(location.x, location.y);
    rotate(dir);

    //Afterburner
    if (isUp) {
      stroke(int(random(2)) * 255);
      line(- 5, 10, 0, 20);
      line(5, 10, 0, 20);
    }
    stroke(255);
    line(0, - 15, - 10, 15);
    line(0, - 15, 10, 15);
    line(- 8, 10, 8, 10);


    popMatrix();
  }

  void update() {
    acceleration.mult(0);
    dir = dir + angVel * (int(isRight) - int(isLeft));

    if (dir > 2 * PI) {
      dir -= 2 * PI;
    } else if (dir < 0) {
      dir += 2 * PI;
    }


    if (isUp) {
      PVector thrust = new PVector(0.06 * cos(dir + 1.5 * PI), 0.06 * sin(dir + 1.5 * PI));
      applyForce(thrust);
    }
    
    if (isSpace) {
      playerProjectiles.add(new PlayerProjectile(width / 2, height / 2, 0));
      //println("eddig jó");
    }

    friction();

    velocity.add(acceleration);
    velocity.limit(5);
    location.add(velocity);

    if (location.x > width + 15) {
      location.x -= width + 30;
    } else if (location.x < -15) {
      location.x += width + 30;
    }

    if (location.y > height + 15) {
      location.y -= height + 30;
    } else if (location.y < -15) {
      location.y += height + 30;
    }
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void friction() {
    float fMag = 0.015;
    PVector force = velocity.copy();
    if (velocity.mag() >= fMag) {
      force.setMag(- fMag);
    } else {
      force.setMag(- velocity.mag());
    }
    applyForce(force);
  }

void shoot() {

}


  boolean setMove(int k, boolean b) { //"switch" is similar to "else if" structure 
    switch (k) {
    case UP:
      return isUp = b;

    case LEFT:
      return isLeft = b;

    case RIGHT:
      return isRight = b;
      
    case 32:
      return isSpace = b;

    default:
      return b;
    }
  }
}