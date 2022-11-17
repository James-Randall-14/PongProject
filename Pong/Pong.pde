Game g;

void setup() {
  fullScreen();
  g = new Game(this);
  frameRate(120);
}

void draw() {
  g.run(1 / frameRate);
}
