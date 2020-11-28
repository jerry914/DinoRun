class Frame {
  float pos;
  int speed=golbalSpeed;
  Frame() {
    pos=-1200;
  }
  void display() {
    if (gameMode==2)
      pos = pos+speed*2;
    else
      pos=pos+speed; 
    pushMatrix();
    translate(0, 0, pos);
    rotateX(PI);
    switch(gameMode) {
    case 0:
      image(frame[0], 0, -height/4, width/2, height/2);
      break;
    case 1:
      image(frame[1], 0, -height/4, width/2, height/2);
      break;
    case 2:
      pushMatrix();
      image(video, 0, 0, width, height);
      popMatrix();
      image(frame[2], 0, -height/4, width/2, height/2);
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
}
