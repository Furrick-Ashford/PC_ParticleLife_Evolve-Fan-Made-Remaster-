// An evolutionary version of Particle Life.
// By Terence Soule of Programming Chaos https://www.youtube.com/channel/UC2rO9hEjJkjqzktvtj0ggNQ
// Sets of particles (cells) share forces and share food.
// They can die of starvation or collect enough food to reproduce/
int numTypes = 6;  // 0 is food, plus 5 more, type 1 'eats' food the others just generate forces
int colorStep = 360/numTypes;
float friction = 0.85;
int minPopulation = 15;
int swarmSize = minPopulation;
int maxPopulation = 25;
int numFood = 200; // starting amount of food
int foodRange = 5; // distance to collect food
int foodEnergy = 100; // energy from food
int reproductionEnergy = 1000; 
int startingEnergy = 400;
float K = 0.2;
ArrayList<cell> swarm;
ArrayList<particle> food;
boolean display = true; // whether or not to display, d toggles, used to evolve faster
boolean drawLines = false; // whether or not to draw lines connecting a cell's particles, l to toggle
boolean fullscreen = false; // whether or not to run in fullscreen mode, f to toggle
boolean paused = false; // whether the simulation is paused

// Simulation parameters
float simulationSpeed = 1.0;  // Speed multiplier for the simulation

boolean showRestartConfirmation = false;
String restartConfirmationMessage = "Are you sure you want to restart the simulation?";

void setup() {
  size(1200, 800);
  surface.setResizable(true);
  colorMode(HSB, 360, 100, 100);
  noStroke();
  
  // Initialize simulation
  swarm = new ArrayList<cell>();
  for (int i = 0; i < minPopulation; i++) {
    swarm.add(new cell(random(width), random(height)));
  }
  food = new ArrayList<particle>();
  for (int i = 0; i < numFood; i++) {
    food.add(new particle(new PVector(random(width), random(height)), 0));
  }
  
  // Setup UI
  setupUI();
}

void draw() {
  background(0);
  
  // Draw simulation
  pushMatrix();
  if (showUI) {
    translate(250, 0); // Move simulation to the right of UI
  }
  
  if (!paused) {
    // Update simulation multiple times based on speed
    for (int i = 0; i < simulationSpeed; i++) {
      updateSimulation();
    }
  } else {
    // When paused, just display everything without updating
    for (cell c : swarm) {
      if(display){
        c.display();
      }
    }
  }
  
  if(display){
    for (particle p : food) {
       p.display();
    }
  }
  popMatrix();
  
  // Draw UI
  drawUI();
  
  // Draw restart confirmation if needed
  if (showRestartConfirmation) {
    drawRestartConfirmation();
  }
}

void updateSimulation() {
  for (cell c : swarm) {
    c.update();
    if(display){
      c.display();
    }
  }
  for (int i = swarm.size()-1; i >= 0; i--) {
    cell c = swarm.get(i);
    if (c.energy <= 0) {
      swarm.remove(i);
    }
  }
  eat();
  replace();
  reproduce();
  
  if(frameCount % 5 == 0){
    food.add(new particle(new PVector(random(width - (showUI ? 250 : 0)), random(height)), 0));
  }
}

// for dead cells
void convertToFood(cell c){
  for(particle p: c.swarm){
    food.add(new particle(p.position, 0));
  }
  swarmSize = swarmSize - 1;
}

void reproduce(){
  swarmSize = swarm.size()
;  if(swarmSize == maxPopulation){
  cell c;
  for(int i = swarm.size()-1; i>=0 ;i--){
    c = swarm.get(i);
    if(c.energy > reproductionEnergy){ // if a cell has enough energy 
      cell temp = new cell(random(width), random(height));  // make a new cell at a random location
      temp.copyCell(c); // copy the parent cell's 'DNA'
      c.energy -= startingEnergy;  // parent cell loses energy (daughter cell recieves it) 
      temp.mutateCell(); // mutate the daughter cell
      swarm.add(temp);
    }
    }
  }
}

// If population is below minPopulation add cells by copying and mutating
// randomly selected existing cells.
// Note: if the population all dies simultanious the program will crash - extinction!
void replace(){
  if(swarm.size() < minPopulation){  
    int parent = int(random(swarm.size()));
    cell temp = new cell(random(width), random(height));
    cell parentCell = swarm.get(parent);
    temp.copyCell(parentCell);
    temp.mutateCell();
    swarm.add(temp);
  }
}

void eat() {
  float dis;
  PVector vector = new PVector(0, 0);
  for (cell c : swarm) {  // for every cell
    for (particle p : c.swarm) {  // for every particle in every cell
      if (p.type == 1) { // 1 is the eating type of paricle
        for (int i = food.size()-1; i >= 0; i--) {  // for every food particle - yes this gets slow
          particle f = food.get(i);
          vector.mult(0);
          vector = f.position.copy();
          vector.sub(p.position); 
          if (vector.x > width * 0.5) { vector.x -= width; }
          if (vector.x < width * -0.5) { vector.x += width; }
          if (vector.y > height * 0.5) { vector.y -= height; }
          if (vector.y < height * -0.5) { vector.y += height; }
          dis = vector.mag();
          if(dis < foodRange){
            c.energy += foodEnergy; // gain 100 energy for eating food 
            food.remove(i);
          }
        }
      }
    }
  }
}

void keyPressed() {
  if (key == 'd') {
    display = !display;
  }
  if (key == 'l') {
    drawLines = !drawLines;
  }
  if (key == 'h' || key == 'H') {
    showUI = !showUI;
  }
  if (key == 'f' || key == 'F') {
    if (fullscreen) {
      surface.setSize(1200, 800);
      surface.setLocation(100, 100);
    } else {
      surface.setSize(displayWidth, displayHeight);
      surface.setLocation(0, 0);
    }
    fullscreen = !fullscreen;
  }
  if (key == ' ') {  // Spacebar
    paused = !paused;
  }
  if (key == 'r' || key == 'R') {  // Show restart confirmation
    showRestartConfirmation = true;
  }
  if (key == 't') {
    print("List of swarm IDs: " + swarm);
    print("Size of swarm: " + swarmSize);
  }
}

void drawRestartConfirmation() {
  // Semi-transparent background
  fill(0, 200);
  rect(0, 0, width, height);
  
  // Dialog box
  fill(50);
  stroke(255);
  rectMode(CENTER);
  int dialogWidth = 400;
  int dialogHeight = 200;
  rect(width/2, height/2, dialogWidth, dialogHeight);
  
  // Text
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(16);
  text(restartConfirmationMessage, width/2, height/2 - 30);
  
  // Yes button
  fill(100);
  rect(width/2 - 80, height/2 + 30, 120, 40);
  fill(255);
  text("Yes", width/2 - 80, height/2 + 30);
  
  // No button
  fill(100);
  rect(width/2 + 80, height/2 + 30, 120, 40);
  fill(255);
  text("No", width/2 + 80, height/2 + 30);
  
  rectMode(CORNER);
}

void restartSimulation() {
  // Clear existing simulation
  swarm.clear();
  food.clear();
  
  // Reset simulation parameters
  swarmSize = minPopulation;
  
  // Reinitialize simulation
  for (int i = 0; i < minPopulation; i++) {
    swarm.add(new cell(random(width - (showUI ? 250 : 0)), random(height)));
  }
  for (int i = 0; i < numFood; i++) {
    food.add(new particle(new PVector(random(width - (showUI ? 250 : 0)), random(height)), 0));
  }
  
  // Reset pause state
  paused = false;
}
