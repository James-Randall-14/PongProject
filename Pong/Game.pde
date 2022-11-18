import processing.sound.*;

public class Game {
  private Player p1;
  private Player p2;
  private Ball b;
  private String gameState = "serve";
  private SoundFile hit;
  private SoundFile point;
  private SoundFile victory;
  
  public Game(PApplet p) {
    p1 = new Player(10, 10, 'w', 's');
    p2 = new Player(width - 30, height - 90, 'i', 'k');
    b = new Ball(p);
    hit = new SoundFile(p, "hit.wav");
    point = new SoundFile(p, "point.wav");
    victory = new SoundFile(p, "victory.wav");
  }

  public void run(float dt) {
    background(40, 45, 52);

    checkState();

    // Update the player1 with the player's input
    p1.update(p1.playerDV(dt));
    // Update the player2 with the AI's input
    p2.update(p2.aiDV(b.calcY()));

    if (gameState.equals("play")) {
      b.update(dt);

      if (b.isOnLeft(p1)) {
        p2.scorePoint();
        point.play();
        b.reset();
        gameState = "serve";
      } else if (b.isOnRight(p2)) {
        p1.scorePoint();
        point.play();
        b.reset();
        gameState = "serve";
      }

      if (b.collides(p1)) {
        b.flipDirection(p1);
        hit.play();
      } else if (b.collides(p2)) {
        b.flipDirection(p2);
        hit.play();
      }

      checkForVictory();
    }

    p1.render();
    p2.render();

    if (!gameState.equals("victory")) {
      b.render();
    }

    if (gameState.equals("serve")) {
      renderScores();
    } else if (gameState.equals("victory")) {
      if (p1.getScore() > p2.getScore()) {
        printWinner(1);
      } else {
        printWinner(2);
      }
    }
  }

  void checkState() {
    if (keyPressed && key == ' ' && gameState.equals("serve")) {
      gameState = "play";
    }
  }

  void renderScores() {
    textSize(96);
    textAlign(CENTER);
    stroke(255);
    text(p1.getScore(), width / 4, 100);
    text(p2.getScore(), 3 * width / 4, 100);
  }

  void checkForVictory() {
    if (p1.getScore() == 9 || p2.getScore() == 9) {
      gameState = "victory";
      victory.play();
    }
  }

  void printWinner(int winner) {
    textSize(72);
    textAlign(CENTER, CENTER);
    stroke(255);
    text("Player " + winner + " wins!", width / 2, height / 2);
  }
}
