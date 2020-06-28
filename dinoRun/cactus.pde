class Cactus {

  float pos;
  int speed=golbalSpeed;
  Cactus() {
    pos=-370;
  }

  void display() {

    pos=pos+speed;   //speed
    pushMatrix();
    translate(0, 0, pos);

    scale(25);
    shape(cactus);

    popMatrix();
  }
  int finish() {
    if (pos>1500) {
      return 1;
    }
    return 0;
  }
  void checkDie() {
    if (pos>130&&pos<140 && onFloor) {
      gameOver = true;
      die.play();
    }
  }
}
