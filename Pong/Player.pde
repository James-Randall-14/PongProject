public class Player {
  private PVector location;
  private PVector velocity;
  private float pWidth = 20;
  private float pHeight = 80;
  private char upButton;
  private char downButton;
  private int score = 0;
  private final int PADDLE_SPEED = 40;
  private float pErr;
  private float iErr;
  private float dErr;
  private float pGain;
  private float iGain;
  private float dGain;

  public Player(float x, float y, char up, char down) {
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    upButton = up;
    downButton = down;
    pErr = 0;
    iErr = 0;
    dErr = 0;
    pGain = 2.4;
    iGain = 0;
    dGain = 0.1;
  }

  public float getX() {
    return location.x;
  }
  public float getY() {
    return location.y;
  }
  public float getWidth() {
    return pWidth;
  }
  public float getHeight() {
    return pHeight;
  }
  public int getScore() {
    return score;
  }

  public void scorePoint() {
    score++;
  }

  public void render() {
    fill(255);
    stroke(255);
    rect(location.x, location.y, pWidth, pHeight);
  }

  public float playerDV(float dt) {
    float desiredVel = velocity.y;
    if (keyPressed) {
      if (key == upButton) {
        desiredVel = velocity.y - PADDLE_SPEED * dt;
      } else if (key == downButton) {
        desiredVel = velocity.y + PADDLE_SPEED * dt;
      }
    }
    
    if (abs(velocity.y) < 0.2 && !keyPressed) {
      desiredVel = 0;
    }
    return desiredVel;
  }

  public float aiDV(float desiredY) {
    PVector desiredVel = new PVector(location.x, desiredY - location.y);

    float currentErr = desiredVel.mag();
    iErr =  currentErr;
    dErr = currentErr - pErr;
    pErr = currentErr;
    float desiredSpeed = pGain * pErr + iGain * iErr + dGain * dErr;
    
    //Stop motion if we are close enough to 0
    if (abs(currentErr) < 2) {
      desiredSpeed = 0;
    }
    // Limit desiredSpeed to paddle speed
    if (abs(desiredSpeed) > PADDLE_SPEED) {
      desiredSpeed = desiredSpeed / abs(desiredSpeed) * PADDLE_SPEED;
    }
    
    desiredVel.setMag(desiredSpeed);
    return desiredVel.y; // JUST TO GET RID OF ERRORS FOR NOW. DO NOT FORGET TO REMOVE
  }

  // Takes desired velocity and accelerates to it
  // For players, desired velocity is just current + keypress
  // For AI, computed by PID loop
  public void update(float desiredVel) {
    if (location.y == 0 || location.y == height - 80) {
      velocity.mult(0);
    }

    PVector diff = new PVector(velocity.x, desiredVel - velocity.y);
    velocity.add(diff);
    location.add(velocity);
    location.y = constrain(location.y, 0, height - 80);
    if (location.y <= 0 || location.y >= height - 80) {
      velocity.mult(0);
    }
    print("pos: ");
    println(location.y);
  }
}
