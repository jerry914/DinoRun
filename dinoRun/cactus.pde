class Cactus {

  float pos;
  int speed=golbalSpeed;
  Cactus() {
    pos=-370;
  }

  void display() {
    if (gameMode==2)
      pos = pos+speed*2;
    else
      pos=pos+speed; 
    pushMatrix();
    translate(0, 0, pos);

    switch(gameMode) {
    case 0:
      scale(0.4);
      shape(cactusBig);
      break;
    case 1:
      scale(25);
      shape(cactus);
      break;
    case 2:

      break;
    case 3:

      break;
    default:
      break;
    }


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
