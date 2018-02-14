class Ship {
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  PVector nose, mid1, mid2, tail1, tail2;

  float dir = 1.5 * PI;
  float angVel = 0.1;
  int weaponTimer = 0;
  float heat = 0;
  boolean overheat = false;
  float cooldown = 1;

  boolean isLeft, isRight, isUp, isSpace;

  Ship(float _x, float _y) {
    location = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    
    nose = new PVector(15, 0);
    tail1 = new PVector(-15, -10);
    mid1 = new PVector(-10, -8);
    mid2 = new PVector(-10, 8);
    tail2 = new PVector(-15, 10);
  }
  void display() {

    //Afterburner
    //if (isUp) {
    //  int afterColor = int(random(2)) * 255;
    //  stroke(0, afterColor, afterColor);

    //  line(-10, -5, -20, 0);
    //  line(-10, 5, -20, 0);
    //}

    fill(0);
    stroke(0, 255, 255);
    beginShape();
    drawShip(nose);
    drawShip(tail1);
    drawShip(mid1);
    drawShip(mid2);
    drawShip(tail2);
    endShape(CLOSE);

  }

  void update() {
    acceleration.mult(0);

    //TURNING
    dir = dir + angVel * (int(isRight) - int(isLeft));

    if (dir > 2 * PI) {
      dir -= 2 * PI;
    } else if (dir < 0) {
      dir += 2 * PI;
    }

    //THRUST
    if (isUp) {
      PVector thrust = new PVector(0.06 * cos(dir), 0.06 * sin(dir));
      applyForce(thrust);
    }

    //SHOOOT
    if (isSpace && (millis() - weaponTimer > 200) && !overheat) {
      PVector noseLoc = PVector.fromAngle(dir);
      noseLoc.setMag(15);
      noseLoc.add(location);

      playerProjectiles.add(new PlayerProjectile(noseLoc, velocity, dir));
      weaponTimer = millis();
      heat += 20;
    }

    heat -= cooldown;
    heat = constrain(heat, 0, 100);

    if (heat == 100) {
      overheat = true;
    } else if (heat == 0) {
      overheat = false;
    }

    if (!overheat) {
      cooldown = 1;
    } else {
      cooldown = 0.75;
    }

    friction();

    velocity.add(acceleration);
    velocity.limit(5);
    location.add(velocity);

    //LOOPING SPACE
    if (location.x > width + 15) {
      location.x -= width + 30;
    } else if (location.x < -15) {
      location.x += width + 30;
    }

    if (location.y > height + 15) {
      location.y -= height - hudHeight + 30;
    } else if (location.y < hudHeight -15) {
      location.y += height - hudHeight + 30;
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

  boolean setMove(int k, boolean b) { //"switch" is similar to the "else if" structure 
    switch (k) {
    case UP:
      return isUp = b;

    case LEFT:
      return isLeft = b;

    case RIGHT:
      return isRight = b;

    case CONTROL:
      return isSpace = b;

    default:
      return b;
    }
  }
  
  void drawShip(PVector vector) {
    vertex(vector.x + location.x, vector.y + location.y);
  }
}

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
    fill(0, 255, 255);
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