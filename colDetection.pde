//Collision Detection by Jeff Thompson
//http://www.jeffreythompson.org/collision-detection/

// POINT/CIRCLE
boolean pointCircle(PVector point, PVector circle, float r) {
  float distance = PVector.dist(point, circle);
  if (distance <= r) {
    return true;
  }
  return false;
}

// LINE/POINT
boolean linePoint(PVector line1, PVector line2, PVector point) {

  // get distance from the point to the two ends of the line
  float d1 = PVector.dist(line1, point);
  float d2 = PVector.dist(line2, point);

  // get the length of the line
  float lineLen = PVector.dist(line1, line2);

  // since floats are so minutely accurate, add
  // a little buffer zone that will give collision
  float buffer = 0.1;    // higher # = less accurate

  // if the two distances are equal to the line's
  // length, the point is on the line!
  // note we use the buffer here to give a range,
  // rather than one #
  if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer) {
    return true;
  }
  return false;
}

// LINE/CIRCLE
boolean lineCircle(PVector point1, PVector point2, PVector circle, float r) {

  // is either end INSIDE the circle?
  // if so, return true immediately
  boolean inside1 = pointCircle(point1, circle, r);
  boolean inside2 = pointCircle(point2, circle, r);
  if (inside1 || inside2) return true;

  // get length of the line
  float len = PVector.dist(point1, point2);

  // get dot product of the line and circle
  float dot = ( ((circle.x-point1.x)*(point2.x-point1.x)) + ((circle.y-point1.y)*(point2.y-point1.y)) ) / pow(len, 2);

  // find the closest point on the line
  float closestX = point1.x + (dot * (point2.x-point1.x));
  float closestY = point1.y + (dot * (point2.y-point1.y));
  PVector closest = new PVector(closestX, closestY);

  // is this point actually on the line segment?
  // if so keep going, but if not, return false
  boolean onSegment = linePoint(point1, point2, closest);
  if (!onSegment) return false;

  // get distance to closest point
  float distance = PVector.dist(closest, circle);

  if (distance <= r) {
    return true;
  }
  return false;
}

// POLYGON/POINT
boolean polyPoint(PVector[] vertices, float px, float py) {
  boolean collision = false;

  // go through each of the vertices, plus
  // the next vertex in the list
  int next = 0;
  for (int current=0; current<vertices.length; current++) {

    // get next vertex in list
    // if we've hit the end, wrap around to 0
    next = current+1;
    if (next == vertices.length) next = 0;

    // get the PVectors at our current position
    // this makes our if statement a little cleaner
    PVector vc = vertices[current];    // c for "current"
    PVector vn = vertices[next];       // n for "next"

    // compare position, flip 'collision' variable
    // back and forth
    if (((vc.y > py && vn.y < py) || (vc.y < py && vn.y > py)) &&
         (px < (vn.x-vc.x)*(py-vc.y) / (vn.y-vc.y)+vc.x)) {
            collision = !collision;
    }
  }
  return collision;
}

// LINE/LINE
boolean lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

  // calculate the distance to intersection point
  float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

  // if uA and uB are between 0-1, lines are colliding
  if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {

    // optionally, draw a circle where the lines meet
    //float intersectionX = x1 + (uA * (x2-x1));
    //float intersectionY = y1 + (uA * (y2-y1));
    //fill(255,0,0);
    //noStroke();
    //ellipse(intersectionX,intersectionY, 20,20);

    return true;
  }
  return false;
}

// POLYGON/CIRCLE
boolean polyCircle(PVector[] vertices, PVector c, float r) {

  // go through each of the vertices, plus
  // the next vertex in the list
  int next = 0;
  for (int current=0; current<vertices.length; current++) {

    // get next vertex in list
    // if we've hit the end, wrap around to 0
    next = current+1;
    if (next == vertices.length) next = 0;

    // get the PVectors at our current position
    // this makes our if statement a little cleaner
    PVector vc = vertices[current];    // c for "current"
    PVector vn = vertices[next];       // n for "next"

    // check for collision between the circle and
    // a line formed between the two vertices
    boolean collision = lineCircle(vc, vn, c, r);
    if (collision) return true;
  }

  // the above algorithm only checks if the circle
  // is touching the edges of the polygon – in most
  // cases this is enough, but you can un-comment the
  // following code to also test if the center of the
  // circle is inside the polygon

  // boolean centerInside = polygonPoint(vertices, cx,cy);
  // if (centerInside) return true;

  // otherwise, after all that, return false
  return false;
}

// POLYGON/LINE
boolean polyLine(PVector[] vertices, PVector line1, PVector line2) {

  // go through each of the vertices, plus the next
  // vertex in the list
  int next = 0;
  for (int current=0; current<vertices.length; current++) {

    // get next vertex in list
    // if we've hit the end, wrap around to 0
    next = current+1;
    if (next == vertices.length) next = 0;

    // get the PVectors at our current position
    // extract X/Y coordinates from each
    float x3 = vertices[current].x;
    float y3 = vertices[current].y;
    float x4 = vertices[next].x;
    float y4 = vertices[next].y;

    // do a Line/Line comparison
    // if true, return 'true' immediately and
    // stop testing (faster)
    boolean hit = lineLine(line1.x, line1.y, line2.x, line2.y, x3, y3, x4, y4);
    if (hit) {
      return true;
    }
  }

  // never got a hit
  return false;
}

// POLYGON/POLYGON
boolean polyPoly(PVector[] p1, PVector[] p2) {

  // go through each of the vertices, plus the next
  // vertex in the list
  int next = 0;
  for (int current=0; current<p1.length; current++) {

    // get next vertex in list
    // if we've hit the end, wrap around to 0
    next = current+1;
    if (next == p1.length) next = 0;

    // get the PVectors at our current position
    // this makes our if statement a little cleaner
    PVector vc = p1[current];    // c for "current"
    PVector vn = p1[next];       // n for "next"

    // now we can use these two points (a line) to compare
    // to the other polygon's vertices using polyLine()
    boolean collision = polyLine(p2, vc,vn);
    if (collision) return true;

    // optional: check if the 2nd polygon is INSIDE the first
    collision = polyPoint(p1, p2[0].x, p2[0].y);
    if (collision) return true;
  }

  return false;
}