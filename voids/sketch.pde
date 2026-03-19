// @doc This is our main list of 'Boids'. Each Boid is a single bird-like object in our simulation.
// We also track 'flashes' for the visual effects when adding or removing boids.
ArrayList<Boid> boids;
ArrayList<Flash> flashes;

// --- CONFIGURATION ---

// @doc These constants define the colors and visual properties used across the simulation.
// Using named constants makes the code much easier to read and maintain.
final color COLOR_BG         = color(255);
final color COLOR_BORDER     = color(230);
final color COLOR_FLASH_ADD  = color(59, 130, 246, 150);  // Blue
final color COLOR_FLASH_REM  = color(239, 68, 68, 150);  // Red
final color COLOR_MOUSE_ATTR = color(52, 211, 153, 60);   // Emerald Green
final color COLOR_MOUSE_REPU = color(248, 113, 113, 60);  // Rose Red

final int INTERACT_STEER   = 0;
final int INTERACT_REPULSE = 1;
int interactionMode = INTERACT_STEER;
boolean showTrails  = false;

// @doc The 'setup' function runs once when the program starts.
// We set the canvas size, enable smooth graphics, and create our first 10 boids at random positions.
void setup() {
  size(1200, 420);
  smooth();

  boids = new ArrayList<Boid>();
  flashes = new ArrayList<Flash>();
  
  int initialBoids = 10;
  for (int i = 0; i < initialBoids; i++) {
    boids.add(new Boid(random(width), random(height)));
  }
}

// @doc The 'draw' function runs 60 times per second. 
// It clears the background, draws the world borders, and updates every boid's movement.
void draw() {
  background(COLOR_BG);

  // Draw World Borders
  noFill();
  stroke(COLOR_BORDER);
  strokeWeight(2);
  rect(0, 0, width, height);

  // Update and Render Boids
  for (int i = 0; i < boids.size(); i++) {
    Boid b = boids.get(i);
    b.flock(boids);
    applyMouseInteraction(b);
    b.update();
    b.wrapEdges();
    b.render();
  }

  drawMouseFeedback();

  // Update and remove finished animations
  for (int i = flashes.size() - 1; i >= 0; i--) {
    Flash f = flashes.get(i);
    f.update();
    f.render();
    if (f.isDone()) {
      flashes.remove(i);
    }
  }
}

// @doc These functions allow the website's buttons to control the simulation.
// They handle adding/removing boids and toggling interaction modes.
void addBoid() {
  float x = random(width);
  float y = random(height);
  boids.add(new Boid(x, y));
  flashes.add(new Flash(x, y, COLOR_FLASH_ADD));
}

void removeBoid() {
  if (boids.size() > 0) {
    Boid b = boids.get(boids.size() - 1);
    flashes.add(new Flash(b.position.x, b.position.y, COLOR_FLASH_REM));
    boids.remove(boids.size() - 1);
  }
}

void setInteractionMode(int mode) {
  interactionMode = (mode == INTERACT_REPULSE) ? INTERACT_REPULSE : INTERACT_STEER;
}

int getInteractionMode() { return interactionMode; }
void setShowTrails(boolean show) { showTrails = show; }
boolean getShowTrails() { return showTrails; }

// @doc This function draws the pulsing green/red circle when you click the canvas.
// It uses a 'sin' (sine wave) function to make the circle pulse in and out smoothly.
void drawMouseFeedback() {
  if (!mousePressed) return;
  if (mouseX < 0 || mouseX > width || mouseY < 0 || mouseY > height) return;

  // Pulse animation constants
  float baseRadius = 15.0;
  float pulseAmplitude = 5.0;
  float pulseSpeed = 0.2;
  float pulse = baseRadius + sin(frameCount * pulseSpeed) * pulseAmplitude;
  
  noStroke();
  fill(interactionMode == INTERACT_STEER ? COLOR_MOUSE_ATTR : COLOR_MOUSE_REPU);
  ellipse(mouseX, mouseY, pulse * 2, pulse * 2);
  
  // Outer faint ring for extra "pulse" feel
  noFill();
  stroke(interactionMode == INTERACT_STEER ? COLOR_MOUSE_ATTR : COLOR_MOUSE_REPU);
  strokeWeight(1);
  float outerRingOffset = 5.0;
  ellipse(mouseX, mouseY, (pulse + outerRingOffset) * 2, (pulse + outerRingOffset) * 2);
}

// @doc This handles the attraction or repulsion logic.
// If in 'Steer' mode, boids are pulled toward the mouse. In 'Repulse', they run away.
void applyMouseInteraction(Boid b) {
  if (!mousePressed || mouseX < 0 || mouseX > width || mouseY < 0 || mouseY > height) return;

  PVector mousePoint = new PVector(mouseX, mouseY);

  if (interactionMode == INTERACT_STEER) {
    PVector pull = b.seek(mousePoint);
    float pullStrength = 0.7;
    pull.mult(pullStrength);
    b.applyForce(pull);
  } else {
    float repulseRadius = 120.0;
    PVector push = PVector.sub(b.position, mousePoint);
    float d = push.mag();

    if (d > 0 && d < repulseRadius) {
      push.normalize();
      float maxPushStrength = 0.28;
      float strength = map(d, 0, repulseRadius, maxPushStrength, 0.0);
      push.mult(strength);
      b.applyForce(push);
    }
  }
}

// @doc To make the boids look pretty, we color them based on which direction they are heading.
// This uses 'lerpColor' to smoothly transition between different blue and orange hues.
color colorForHeading(float heading) {
  float t = (heading + PI) / TWO_PI;
  
  // Palette definition
  color c_navy   = color(34, 92, 176);
  color c_sky    = color(92, 182, 234);
  color c_yellow = color(242, 148, 63);
  color c_orange = color(224, 104, 40);

  if (t < 0.25) return lerpColor(c_navy, c_sky, t / 0.25);
  else if (t < 0.5) return lerpColor(c_sky, c_yellow, (t - 0.25) / 0.25);
  else if (t < 0.75) return lerpColor(c_yellow, c_orange, (t - 0.5) / 0.25);
  return lerpColor(c_orange, c_navy, (t - 0.75) / 0.25);
}

// @doc The 'Boid' class is the heart of the simulation.
// It defines how each bird looks, moves, and follows the three rules of flocking.
class Boid {
  PVector position, velocity, acceleration;
  ArrayList<PVector> history;

  // Boid Physical Constants
  final float MAX_SPEED = 2.2;
  final float MAX_FORCE = 0.05;
  final float RADIUS    = 3.0;
  final int   HISTORY_SIZE = 30;

  // Flocking Weight Constants
  final float WEIGHT_SEPARATION = 1.5;
  final float WEIGHT_ALIGNMENT  = 1.0;
  final float WEIGHT_COHESION   = 1.0;

  // Sensing Radius Constants
  final float DIST_SEPARATION = 18.0;
  final float DIST_NEIGHBOR   = 45.0;

  Boid(float x, float y) {
    position = new PVector(x, y);
    velocity = PVector.random2D();
    velocity.mult(random(1.0, 2.0));
    acceleration = new PVector(0, 0);
    history = new ArrayList<PVector>();
  }

  // @doc Flocking is based on three simple rules:
  // 1. Separation (don't crowd neighbors)
  // 2. Alignment (steer in the same direction)
  // 3. Cohesion (stay close to the group center)
  void flock(ArrayList<Boid> others) {
    PVector separation = separate(others);
    PVector alignment = align(others);
    PVector cohesion = cohere(others);

    separation.mult(WEIGHT_SEPARATION);
    alignment.mult(WEIGHT_ALIGNMENT);
    cohesion.mult(WEIGHT_COHESION);

    applyForce(separation);
    applyForce(alignment);
    applyForce(cohesion);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  // @doc Movement updates the velocity based on forces, then moves the position.
  // We also save the last 30 positions if 'trails' are enabled.
  void update() {
    history.add(new PVector(position.x, position.y));
    if (history.size() > HISTORY_SIZE) history.remove(0);

    velocity.add(acceleration);
    velocity.limit(MAX_SPEED);
    position.add(velocity);
    acceleration.mult(0);
  }

  // @doc If a boid goes off one side of the screen, it reappears on the other.
  void wrapEdges() {
    boolean wrapped = false;
    if (position.x < -RADIUS) { position.x = width + RADIUS; wrapped = true; }
    if (position.y < -RADIUS) { position.y = height + RADIUS; wrapped = true; }
    if (position.x > width + RADIUS) { position.x = -RADIUS; wrapped = true; }
    if (position.y > height + RADIUS) { position.y = -RADIUS; wrapped = true; }
    if (wrapped) history.clear();
  }

  // @doc Rendering draws the actual triangle on the screen, rotated to face its velocity.
  // It also includes interactive 'hover' feedback: if the mouse is near a boid, 
  // it displays its velocity vector and its circle of separation influence.
  void render() {
    float heading = velocity.heading();
    color boidColor = colorForHeading(heading);

    // Mouse Hover Detection
    float mouseDist = dist(mouseX, mouseY, position.x, position.y);
    boolean isHovered = (mouseDist < 20.0);

    // Draw diagnostic info if hovered
    if (isHovered) {
      stroke(150, 150, 150, 80); // Subtle Gray
      noFill();
      
      // Circle of Influence (Separation Radius)
      strokeWeight(1);
      ellipse(position.x, position.y, DIST_SEPARATION * 2, DIST_SEPARATION * 2);
      
      // Velocity Vector Line
      float vectorScale = 12.0;
      line(position.x, position.y, position.x + velocity.x * vectorScale, position.y + velocity.y * vectorScale);
    }

    if (showTrails) {
      noFill();
      strokeWeight(1);
      for (int i = 0; i < history.size() - 1; i++) {
        PVector p1 = history.get(i);
        PVector p2 = history.get(i + 1);
        float alpha = map(i, 0, history.size(), 0, 100);
        stroke(red(boidColor), green(boidColor), blue(boidColor), alpha);
        line(p1.x, p1.y, p2.x, p2.y);
      }
    }

    fill(boidColor);
    stroke(boidColor);
    strokeWeight(1);

    pushMatrix();
    translate(position.x, position.y);
    rotate(heading + PI / 2.0);
    beginShape();
    vertex(0, -RADIUS * 2.0);
    vertex(-RADIUS, RADIUS * 2.0);
    vertex(RADIUS, RADIUS * 2.0);
    endShape(CLOSE);
    popMatrix();
  }

  // @doc 'Seek' calculates a force that pulls a boid toward a specific target.
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.normalize();
    desired.mult(MAX_SPEED);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(MAX_FORCE);
    return steer;
  }

  // @doc 'Separate' checks for nearby boids and steers away if they get too close.
  PVector separate(ArrayList<Boid> others) {
    PVector steer = new PVector(0, 0);
    int count = 0;
    for (Boid other : others) {
      float d = PVector.dist(position, other.position);
      if (d > 0 && d < DIST_SEPARATION) {
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) steer.div((float) count);
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(MAX_SPEED);
      steer.sub(velocity);
      steer.limit(MAX_FORCE);
    }
    return steer;
  }

  // @doc 'Align' computes the average velocity of neighbors so boids move together.
  PVector align(ArrayList<Boid> others) {
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : others) {
      float d = PVector.dist(position, other.position);
      if (d > 0 && d < DIST_NEIGHBOR) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float) count);
      sum.normalize();
      sum.mult(MAX_SPEED);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(MAX_FORCE);
      return steer;
    }
    return new PVector(0, 0);
  }

  // @doc 'Cohere' finds the center of the nearby group and pulls the boid toward it.
  PVector cohere(ArrayList<Boid> others) {
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : others) {
      float d = PVector.dist(position, other.position);
      if (d > 0 && d < DIST_NEIGHBOR) {
        sum.add(other.position);
        count++;
      }
    }
    return (count > 0) ? seek(PVector.div(sum, (float)count)) : new PVector(0, 0);
  }
}

// @doc The 'Flash' class handles the short expanding ring animation.
// It slowly fades out over time until its alpha reaches zero.
class Flash {
  float x, y, radius = 0, alpha = 150;
  color c;
  
  final float GROWTH_RATE = 2.5;
  final float FADE_RATE   = 5.0;

  Flash(float x, float y, color c) { this.x = x; this.y = y; this.c = c; }
  void update() { radius += GROWTH_RATE; alpha -= FADE_RATE; }
  void render() {
    noFill();
    stroke(red(c), green(c), blue(c), alpha);
    strokeWeight(2);
    ellipse(x, y, radius * 2, radius * 2);
  }
  boolean isDone() { return alpha <= 0; }
}
