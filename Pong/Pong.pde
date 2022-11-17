Game g;

void setup() {
  size(960, 540);
  g = new Game(this);
  frameRate(120);
}

void draw() {
  g.run(1 / frameRate);
  line(0, height / 2, width, height / 2);
}
