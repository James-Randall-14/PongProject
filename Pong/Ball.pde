public class Ball {
  private PVector location;
  private PVector velocity;
  private float xSpeed;
  private float ySpeed;
  private PVector acceleration;
  private SoundFile cieling;

  public Ball(PApplet p) {
    location = new PVector(width / 2 - 10, height / 2 - 10);
    velocity = new PVector(0, 0);
    xSpeed = random(250, 350);
    ySpeed = random(175, 225);
    acceleration = new PVector(0.01, 0.005);
    randomizeDirections();
    cieling = new SoundFile(p, "cieling.wav");
  }

  public void reset() {
    location = new PVector(width / 2 - 10, height / 2 - 10);
    velocity = new PVector(0, 0);
    xSpeed = random(250, 350);
    ySpeed = random(175, 225);
    acceleration = new PVector(0.01, 0.005);
    randomizeDirections();
  }

  private void randomizeDirections() {
    int xDir = int(random(2));
    int yDir = int(random(2));

    if (xDir == 0) {
      xSpeed *= -1;
    }

    if (yDir == 0) {
      ySpeed *= -1;
    }
  }

  public void render() {
    fill(255);
    stroke(255);
    rect(location.x, location.y, 20, 20);
  }

  public void update(float dt) {
    velocity.x = xSpeed * dt;
    velocity.y = ySpeed * dt;
    location.add(velocity);

    if (location.y < 0) {
      location.y = 0;
      ySpeed *= -1;
      cieling.play();
    } else if (location.y > height - 20) {
      location.y = height - 20;
      ySpeed *= -1;
      cieling.play();
    }
  }

  public void flipDirection() {
    xSpeed *= -1.03;
  }

  public boolean collides(Player p) {
    // check left side of the Ball
    if (location.x > p.getX() + p.getWidth()) {
      return false;
    }
    // check right side of the Ball
    else if (location.x + 20 < p.getX()) {
      return false;
    }
    // check top of the Ball
    else if (location.y > p.getY() + p.getHeight()) {
      return false;
    }
    // check bottom of the Ball
    else if (location.y + 20 < p.getY()) {
      return false;
    }
    return true;
  }

  public boolean isOnLeft(Player p) {
    if (location.x + 10 < p.getX() + p.getWidth()) {
      return true;
    } else {
      return false;
    }
  }

  public boolean isOnRight(Player p) {
    if (location.x + 10 > p.getX()) {
      return true;
    } else {
      return false;
    }
  }
  
  public float calcY() {
    float m = 0;
    float x1 = 0;
    float y1 = height / 2 - 40;
    if (velocity.x > 0) {
      x1 = width - location.x;
      m = velocity.y / velocity.x;
    } else if (velocity.x < 0) {
      x1 = -location.x;
      m = velocity.y / velocity.x;
    }

    if (velocity.y > 0) { //Issues here
      y1 = -abs(m * x1 - location.y) + height - 40;
    } else if (velocity.y < 0) {
      y1 = abs(m * x1 + location.y) - 40;
    }

    // Using + location.y is what is causing the bug
    //y1 = abs(m * x1) - 30;   
    //the 30 is to offset for height of paddle + ball
    print("y1: ");
    println(y1);
    circle(width - 30, y1, 5);
    return y1;
  }
}
