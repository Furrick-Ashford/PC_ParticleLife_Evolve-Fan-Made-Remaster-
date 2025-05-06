// UI Controls
int sliderWidth = 200;
int sliderHeight = 20;
int buttonWidth = 100;
int buttonHeight = 30;
int margin = 20;
int textHeight = 15;
boolean showUI = true; // whether or not to show the UI, h to toggle

// Slider positions
int frictionY = 40;
int foodEnergyY = 80;
int reproductionEnergyY = 120;
int startingEnergyY = 160;
int numFoodY = 200;
int foodRangeY = 240;
int minPopulationY = 280;
int maxPopulationY = 320;
int speedY = 360;  // New speed control slider position

// Button positions
int displayButtonY = 400;
int linesButtonY = 440;
int pauseButtonY = 480;
int restartButtonY = 520;  // New restart button position
int hideUIButtonY = 560;
int fullscreenButtonY = 600;

void setupUI() {
    // No need for special setup with Processing's built-in UI
}

void drawUI() {
    if (!showUI) return;  // Don't draw UI if hidden
    
    // Draw background panel - make it taller to fit all elements
    fill(50);
    noStroke();
    rect(0, 0, 250, fullscreenButtonY + buttonHeight + margin);
    
    // Draw labels and values
    fill(255);
    textAlign(LEFT, CENTER);
    textSize(12);
    
    // Draw sliders
    drawSlider("Friction: " + nf(friction, 0, 2), friction, 0.1, 1.0, margin, frictionY);
    drawSlider("Food Energy: " + foodEnergy, foodEnergy, 50, 500, margin, foodEnergyY);
    drawSlider("Reproduction Energy: " + reproductionEnergy, reproductionEnergy, 500, 2000, margin, reproductionEnergyY);
    drawSlider("Starting Energy: " + startingEnergy, startingEnergy, 200, 800, margin, startingEnergyY);
    drawSlider("Number of Food: " + numFood, numFood, 50, 500, margin, numFoodY);
    drawSlider("Food Range: " + foodRange, foodRange, 1, 20, margin, foodRangeY);
    drawSlider("Min Population: " + minPopulation, minPopulation, 5, 30, margin, minPopulationY);
    drawSlider("Max Population: " + maxPopulation, maxPopulation, 20, 50, margin, maxPopulationY);
    drawSlider("Speed: " + nf(simulationSpeed, 0, 1) + "x", simulationSpeed, 0.1, 5.0, margin, speedY);
    
    // Draw buttons
    drawButton("Display: " + (display ? "ON" : "OFF"), margin, displayButtonY);
    drawButton("Lines: " + (drawLines ? "ON" : "OFF"), margin, linesButtonY);
    drawButton("Pause (Space): " + (paused ? "ON" : "OFF"), margin, pauseButtonY);
    drawButton("Restart (R)", margin, restartButtonY);
    drawButton("Hide UI (H)", margin, hideUIButtonY);
    drawButton("Fullscreen (F)", margin, fullscreenButtonY);
}

void drawSlider(String label, float value, float min, float max, int x, int y) {
    // Draw label
    fill(255);
    text(label, x, y - 10);
    
    // Draw slider background
    fill(100);
    rect(x, y, sliderWidth, sliderHeight);
    
    // Draw slider value
    float sliderPos = map(value, min, max, x, x + sliderWidth);
    fill(200);
    rect(sliderPos - 5, y - 5, 10, sliderHeight + 10);
}

void drawButton(String label, int x, int y) {
    fill(100);
    rect(x, y, buttonWidth, buttonHeight);
    fill(255);
    textAlign(CENTER, CENTER);
    text(label, x + buttonWidth/2, y + buttonHeight/2);
    textAlign(LEFT, CENTER);
}

void mousePressed() {
    if (showRestartConfirmation) {
        // Check if Yes button is clicked
        if (mouseX > width/2 - 140 && mouseX < width/2 - 20 &&
            mouseY > height/2 + 10 && mouseY < height/2 + 50) {
            restartSimulation();
            showRestartConfirmation = false;
        }
        // Check if No button is clicked
        else if (mouseX > width/2 + 20 && mouseX < width/2 + 140 &&
                 mouseY > height/2 + 10 && mouseY < height/2 + 50) {
            showRestartConfirmation = false;
        }
    }
    // Check if mouse is in UI area and UI is visible
    else if (mouseX < 250 && showUI) {
        // Check sliders
        checkSlider(friction, 0.1, 1.0, margin, frictionY, "friction");
        checkSlider(foodEnergy, 50, 500, margin, foodEnergyY, "foodEnergy");
        checkSlider(reproductionEnergy, 500, 2000, margin, reproductionEnergyY, "reproductionEnergy");
        checkSlider(startingEnergy, 200, 800, margin, startingEnergyY, "startingEnergy");
        checkSlider(numFood, 50, 500, margin, numFoodY, "numFood");
        checkSlider(foodRange, 1, 20, margin, foodRangeY, "foodRange");
        checkSlider(minPopulation, 5, 30, margin, minPopulationY, "minPopulation");
        checkSlider(maxPopulation, 20, 50, margin, maxPopulationY, "maxPopulation");
        checkSlider(simulationSpeed, 0.1, 5.0, margin, speedY, "simulationSpeed");
        
        // Check buttons
        if (mouseY > displayButtonY && mouseY < displayButtonY + buttonHeight) {
            display = !display;
        }
        if (mouseY > linesButtonY && mouseY < linesButtonY + buttonHeight) {
            drawLines = !drawLines;
        }
        if (mouseY > pauseButtonY && mouseY < pauseButtonY + buttonHeight) {
            paused = !paused;
        }
        if (mouseY > restartButtonY && mouseY < restartButtonY + buttonHeight) {
            showRestartConfirmation = true;
        }
        if (mouseY > hideUIButtonY && mouseY < hideUIButtonY + buttonHeight) {
            showUI = !showUI;
        }
        if (mouseY > fullscreenButtonY && mouseY < fullscreenButtonY + buttonHeight) {
            if (fullscreen) {
                surface.setSize(1200, 800);
                surface.setLocation(100, 100);
            } else {
                surface.setSize(displayWidth, displayHeight);
                surface.setLocation(0, 0);
            }
            fullscreen = !fullscreen;
        }
    }
}

void mouseDragged() {
    // Check if mouse is in UI area
    if (mouseX < 250) {
        // Update sliders
        updateSlider(friction, 0.1, 1.0, margin, frictionY, "friction");
        updateSlider(foodEnergy, 50, 500, margin, foodEnergyY, "foodEnergy");
        updateSlider(reproductionEnergy, 500, 2000, margin, reproductionEnergyY, "reproductionEnergy");
        updateSlider(startingEnergy, 200, 800, margin, startingEnergyY, "startingEnergy");
        updateSlider(numFood, 50, 500, margin, numFoodY, "numFood");
        updateSlider(foodRange, 1, 20, margin, foodRangeY, "foodRange");
        updateSlider(minPopulation, 5, 30, margin, minPopulationY, "minPopulation");
        updateSlider(maxPopulation, 20, 50, margin, maxPopulationY, "maxPopulation");
        updateSlider(simulationSpeed, 0.1, 5.0, margin, speedY, "simulationSpeed");
    }
}

void checkSlider(float value, float min, float max, int x, int y, String param) {
    if (mouseY > y - 5 && mouseY < y + sliderHeight + 5) {
        float newValue = map(mouseX, x, x + sliderWidth, min, max);
        newValue = constrain(newValue, min, max);
        updateParameter(param, newValue);
    }
}

void updateSlider(float value, float min, float max, int x, int y, String param) {
    if (mouseY > y - 5 && mouseY < y + sliderHeight + 5) {
        float newValue = map(mouseX, x, x + sliderWidth, min, max);
        newValue = constrain(newValue, min, max);
        updateParameter(param, newValue);
    }
}

void updateParameter(String param, float value) {
    switch(param) {
        case "friction":
            friction = value;
            break;
        case "foodEnergy":
            foodEnergy = (int)value;
            break;
        case "reproductionEnergy":
            reproductionEnergy = (int)value;
            break;
        case "startingEnergy":
            startingEnergy = (int)value;
            break;
        case "numFood":
            int newNumFood = (int)value;
            while (food.size() < newNumFood) {
                food.add(new particle(new PVector(random(width), random(height)), 0));
            }
            while (food.size() > newNumFood) {
                food.remove(food.size() - 1);
            }
            numFood = newNumFood;
            break;
        case "foodRange":
            foodRange = (int)value;
            break;
        case "minPopulation":
            minPopulation = (int)value;
            break;
        case "maxPopulation":
            maxPopulation = (int)value;
            break;
        case "simulationSpeed":
            simulationSpeed = value;
            break;
    }
} 
