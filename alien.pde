class Alien {
  PVector location, velocity, velocity2, steeringForce;
  PVector[] vertices;
  PVector[] verticesAbs;

  float scl;
  int weaponTimer;
  float accuracy;
  int scoreValue;
  boolean isAlive = true;
  int alienTimer;

  Alien(float _x, float _y, boolean _isBig) {
    alienTimer = millis();
    location = new PVector(_x, _y);
    if (_isBig) {
      scl = 1.3;
      accuracy = PI / 2;
      scoreValue = 200;
    } else {
      scl = 0.8;
      accuracy = PI / 8;
      scoreValue = 1000;
    }

    velocity = PVector.fromAngle(random(2 * PI));
    steeringForce = velocity.copy();
    steeringForce.rotate(0.5 * PI);
    velocity.mult(2);
    velocity2 = new PVector(0, 0);

    vertices = new PVector[8];
    verticesAbs = new PVector[8];

    vertices[0] = new PVector(5, -10);
    vertices[1] = new PVector(10, -2);
    vertices[2] = new PVector(20, 4);
    vertices[3] = new PVector(10, 10);
    vertices[4] = new PVector(-1 * vertices[3].x, vertices[3].y);
    vertices[5] = new PVector(-1 * vertices[2].x, vertices[2].y);
    vertices[6] = new PVector(-1 * vertices[1].x, vertices[1].y);
    vertices[7] = new PVector(-1 * vertices[0].x, vertices[0].y);

    for (int i = 0; i < vertices.length; i++) {
      vertices[i].mult(scl);
    }

    for (int i = 0; i < verticesAbs.length; i++) {
      verticesAbs[i] = new PVector(0, 0);
    }
  }

  void display() {
    stroke(255);
    fill(0);

    beginShape();
    for (int i = 0; i < vertices.length; i++) {
      verticesAbs[i] = PVector.add(location, vertices[i]);
      vertex(verticesAbs[i].x, verticesAbs[i].y);
    }
    endShape(CLOSE);

    line(verticesAbs[1].x, verticesAbs[1].y, verticesAbs[6].x, verticesAbs[6].y);
    line(verticesAbs[2].x, verticesAbs[2].y, verticesAbs[5].x, verticesAbs[5].y);
  }

  void update() {
    steeringForce.setMag(map(noise(millis() * 0.02), 0, 1, -1, 1));
    velocity2.add(steeringForce);
    velocity2.limit(2);

    //println(velocity.y);
    location.add(velocity);
    location.add(velocity2);

    //BEND SPACE
    if (verticesAbs[5].x > width) {
      location.x -= width + vertices[2].x * 2;
      checkTimer();
    } else if (verticesAbs[2].x < 0) {
      location.x += width + vertices[2].x * 2;
      checkTimer();
    }

    if (verticesAbs[0].y > height) {
      location.y -= height - hudHeight + vertices[3].y * 2;
      checkTimer();
    } else if (verticesAbs[3].y < hudHeight) {
      //println(location.y);
      location.y += height - hudHeight + vertices[3].y * 2;
      checkTimer();
    }
  }

  void checkTimer() {
    if (alienTimer + 10000 < millis()) {
      isAlive = false;
    }
  }

  void shoot() {
    if (millis() - weaponTimer > 1200) {
      PVector porjectileVel = PVector.sub(ship.location, location);
      porjectileVel.rotate(random(accuracy / -2, accuracy / 2));
      alienProjectiles.add(new AlienProjectile(porjectileVel));
      weaponTimer = millis();
    }
  }
}

class AlienProjectile {
  PVector location;
  PVector lastLoc;
  PVector velocity;
  boolean isFinished = false;
  int timer;

  AlienProjectile(PVector _velocity) {
    location = alien.location.copy();
    lastLoc = location.copy();
    velocity = _velocity.copy();
    velocity.setMag(7);
    velocity.add(alien.velocity);
    if (velocity.mag() < 7) {
      velocity.setMag(7);
    }
    timer = millis();
  }

  void display() {
    //noStroke();
    //fill(255);
    //ellipse(location.x, location.y, 2, 2);

    stroke(255);
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
}