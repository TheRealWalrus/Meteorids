class Ship {
  PVector location;
  PVector velocity;
  PVector acceleration;

  PVector nose, mid1, mid2, tail1, tail2, flameBase1, flameBase2, flameTip;

  float angVel = 0.1;
  int weaponTimer = 0;
  float heat = 0;
  boolean overheat = false;
  float cooldown = 1;
  color playerColor;
  float invTimer;
  boolean invincible = false;
  int invDuration = 2000;

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
    flameBase1 = new PVector(-10, -5);
    flameBase2 = new PVector(-10, 5);
    flameTip = new PVector(-20, 0);

    //playerColor = color(255, 200, 0);
    playerColor = color(0, 255, 255);
  }
  void display() {
    noFill();
    //Afterburner
    if (isUp) {
      if (int(random(2)) == 1) {
        stroke(playerColor);
      } else {
        noStroke();
      }
      beginShape();
      drawShip(flameBase1);
      drawShip(flameBase2);
      drawShip(flameTip);
      endShape(CLOSE);
    }

    fill(0);
    stroke(playerColor);
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

    //INVINCIVILITY
    if (invincible) {
      playerColor = color(255, 0, 0);
      if (millis() > invTimer + invDuration) {
        invincible = false;
      }
    } else {
      playerColor = color(0, 255, 255);
    }

    //TURNING
    rotateVertex(nose);
    rotateVertex(tail1);
    rotateVertex(mid1);
    rotateVertex(mid2);
    rotateVertex(tail2);
    rotateVertex(flameBase1);
    rotateVertex(flameBase2);
    rotateVertex(flameTip);

    //THRUST
    if (isUp) {
      PVector thrust = nose.copy();
      thrust.setMag(0.06);
      applyForce(thrust);
    }

    //SHOOOT
    if (isSpace && (millis() - weaponTimer > 200) && !overheat) {
      PVector origo = PVector.add(location, nose);
      playerProjectiles.add(new PlayerProjectile(origo, velocity, nose));
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

    //BEND SPACE
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

  void rotateVertex(PVector vector) {
    vector.rotate(angVel * (int(isRight) - int(isLeft)));
  }
}

class PlayerProjectile {
  PVector location;
  PVector velocity;
  boolean isFinished = false;
  int timer;

  PlayerProjectile(PVector _location, PVector _shipVel, PVector _dir) {
    location = _location.copy();
    velocity = _dir.copy();
    velocity.setMag(7);
    velocity.add(_shipVel);
    if (velocity.mag() < 7) {
      velocity.setMag(7);
    }
    timer = millis();
  }

  void display() {
    noStroke();
    fill(ship.playerColor);
    ellipse(location.x, location.y, 2, 2);
  }

  void update() {
    location.add(velocity);

    if (millis() - timer > 700) {
      isFinished = true;
    }

    //BEND SPACE
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
    return(pointCircle(location, target.location, target.r));
  }
}