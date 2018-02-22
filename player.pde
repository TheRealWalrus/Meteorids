class Ship {
  PVector location;
  PVector velocity;
  PVector acceleration;

  PVector[] vertices;
  PVector[] flameVertices;


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

    vertices = new PVector[5];
    flameVertices = new PVector[3];

    vertices[0] = new PVector(15, 0);
    vertices[1] = new PVector(-15, -10);
    vertices[2] = new PVector(-10, -8);
    vertices[3] = new PVector(-10, 8);
    vertices[4] = new PVector(-15, 10);

    flameVertices[0] = new PVector(-10, -5);
    flameVertices[1] = new PVector(-10, 5);
    flameVertices[2] = new PVector(-20, 0);

    playerColor = color(0, 255, 255);

    setRelative(false);
  }

  void display() {
    //println(vertices[0].x);
    noFill();
    //Afterburner
    if (isUp) {
      if (int(random(2)) == 1) {
        stroke(playerColor);
      } else {
        noStroke();
      }
      beginShape();
      //drawShip(flameBase1);
      //drawShip(flameBase2);
      //drawShip(flameTip);
      for (int i = 0; i < flameVertices.length; i++) {
        vertex(flameVertices[i].x, flameVertices[i].y);
      }
      endShape(CLOSE);
    }

    fill(0);
    stroke(playerColor);
    beginShape();
    //drawShip(nose);
    //drawShip(tail1);
    //drawShip(mid1);
    //drawShip(mid2);
    //drawShip(tail2);
    for (int i = 0; i < vertices.length; i++) {
      vertex(vertices[i].x, vertices[i].y);
    }
    endShape(CLOSE);
  }

  void update() {
    acceleration.mult(0);

    //INVINCIVILITY
    if (invincible) {
      playerColor = color(255, 200, 0);
      //playerColor = color(255, 0, 0);
      if (millis() > invTimer + invDuration) {
        invincible = false;
      }
    } else {
      playerColor = color(0, 255, 255);
    }
    
    setRelative(true);

    //TURNING
    for (int i = 0; i < vertices.length; i++) {
      vertices[i].rotate(angVel * (int(isRight) - int(isLeft)));
    }
    for (int i = 0; i < flameVertices.length; i++) {
      flameVertices[i].rotate(angVel * (int(isRight) - int(isLeft)));
    }
    
    setRelative(false);

    //THRUST
    if (isUp) {
      PVector thrust = vertices[0].copy();
      thrust.setMag(0.06);
      applyForce(thrust);
    }

    //SHOOOT
    if (isSpace && (millis() - weaponTimer > 200) && !overheat) {
      PVector origo = PVector.add(location, vertices[0]);
      playerProjectiles.add(new PlayerProjectile(origo, velocity, vertices[0]));
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
  
  void setRelative(boolean relative) {
    if (!relative) {
      for (int i = 0; i < vertices.length; i++) {
        vertices[i].add(location);
      }
    } else {
      for (int i = 0; i < vertices.length; i++) {
        vertices[i].sub(location);
      }
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
  //PVector lastLoc;

  PlayerProjectile(PVector _location, PVector _shipVel, PVector _dir) {
    //lastLoc = _location.copy();
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

  //boolean hitsAlien() {
  //  if (polyPoint(alien.vertexes, location.x, location.y)) {
  //    return true;
  //  }
  //  return false;
  //}
}