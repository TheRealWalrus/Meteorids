class Ship {
  PVector location;
  PVector velocity;
  PVector acceleration;

  PVector[] vertices;
  PVector[] flameVertices;

  boolean shipUp, shipLeft, shipRight, shipFire;

  float angVel = 0.1;
  int weaponTimer = 0;
  float heat = 0;
  boolean overheat = false;
  float cooldown = 1;
  color playerColor;
  float invTimer;
  boolean invincible = false;
  int invDuration = 2000;
  boolean isAlive = true;
  boolean visible = true;
  int visiTimer;
  int player;

  Ship(float _x, float _y, int _player) {
    player = _player;
    if (_player == 1) {
      playerColor = color(0, 255, 255);
    } else {
      playerColor = color(255, 200, 0);
    }
    
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

    for (int i = 0; i < vertices.length; i++) {
      vertices[i].rotate(1.5 * PI);
    }
    for (int i = 0; i < flameVertices.length; i++) {
      flameVertices[i].rotate(1.5 * PI);
    }
    
    setRelative(false);
  }

  void display() {
    if (visible) {
      noFill();

      //Afterburner
      if (shipUp) {
        if (int(random(2)) == 1) {
          stroke(playerColor);
        } else {
          noStroke();
        }
        beginShape();
        for (int i = 0; i < flameVertices.length; i++) {
          vertex(flameVertices[i].x, flameVertices[i].y);
        }
        endShape(CLOSE);
      }

      fill(0);
      stroke(playerColor);
      beginShape();
      for (int i = 0; i < vertices.length; i++) {
        vertex(vertices[i].x, vertices[i].y);
      }
      endShape(CLOSE);
    }
  }

  void update() {
    if (player == 1) {
      shipUp = isUp;
      shipLeft = isLeft;
      shipRight = isRight;
      shipFire = isCtrl;
    } else {
      shipUp = isW;
      shipLeft = isA;
      shipRight = isD;
      shipFire = isF;
    }
    
    acceleration.mult(0);

    //INVINCIVILITY
    if (invincible) {
      if (millis() > visiTimer + 100) {
        visible = !visible;
        visiTimer = millis();
      }
      if (millis() > invTimer + invDuration) {
        invincible = false;
      }
    } else {
      visible = true;
    }

    setRelative(true);

    //TURNING
    for (int i = 0; i < vertices.length; i++) {
      vertices[i].rotate(angVel * (int(shipRight) - int(shipLeft)));
    }
    for (int i = 0; i < flameVertices.length; i++) {
      flameVertices[i].rotate(angVel * (int(shipRight) - int(shipLeft)));
    }

    //THRUST
    if (shipUp) {
      PVector thrust = vertices[0].copy();
      thrust.setMag(0.06);
      applyForce(thrust);
    }

    //SHOOT
    if (shipFire && (millis() - weaponTimer > 200) && !overheat) {
      PVector origo = PVector.add(location, vertices[0]);
      playerProjectiles.add(new PlayerProjectile(origo, velocity, vertices[0]));
      weaponTimer = millis();
      heat += 18;
      //playerShootSound.play();
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

    setRelative(false);
  }

  void setRelative(boolean relative) {
    if (!relative) {
      for (int i = 0; i < vertices.length; i++) {
        vertices[i].add(location);
      }
      for (int i = 0; i < flameVertices.length; i++) {
        flameVertices[i].add(location);
      }
    } else {
      for (int i = 0; i < vertices.length; i++) {
        vertices[i].sub(location);
      }
      for (int i = 0; i < flameVertices.length; i++) {
        flameVertices[i].sub(location);
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

  void turnInvincible() {
    invincible = true;
    invTimer = millis();
    visiTimer = millis();
  }


}

class PlayerProjectile {
  PVector location;
  PVector lastLoc;
  PVector velocity;
  boolean isFinished = false;
  int timer;
  //PVector lastLoc;

  PlayerProjectile(PVector _location, PVector _shipVel, PVector _dir) {
    lastLoc = _location.copy();
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
    //noStroke();
    //fill(ship.playerColor);
    //ellipse(location.x, location.y, 2, 2);

    stroke(ship.playerColor);
    line(lastLoc.x, lastLoc.y, location.x, location.y);
  }

  void update() {
    lastLoc = location.copy();
    location.add(velocity);

    if (millis() - timer > 700) {
      isFinished = true;
    }

    //BEND SPACE
    if (location.x > width) {
      location.x = 0;
      lastLoc.x = 0;
    } else if (location.x < 0) {
      location.x = width;
      lastLoc.x = width;
    }

    if (location.y > height) {
      location.y = hudHeight;
      lastLoc.y = hudHeight;
    } else if (location.y < hudHeight) {
      location.y = height;
      lastLoc.y = height;
    }
  }

  boolean hits(Asteroid target) {
    //return(pointCircle(location, target.location, target.r));
    return(lineCircle(location, lastLoc, target.location, target.r));
  }

  //boolean hitsAlien() {
  //  if (polyPoint(alien.vertexes, location.x, location.y)) {
  //    return true;
  //  }
  //  return false;
  //}
}