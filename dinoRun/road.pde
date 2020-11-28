class Road {

  float pos;
  int id;
  int speed = golbalSpeed;
  int type;
  float cloudX;
  float cloudSize;
  int cactusX;

  Road(int _id) {
    id=_id;
    pos=float(id)*400-1200;
    if (random(1)>0.3) {
      type = 2;
    } else {
      type = 1;
    }
    cloudX = random(-6, 6);
    cloudSize = random(0, 1);
  }

  void display() {
    if (pos>1200) {
      pos=-1200;
    } else {
      if (gameMode==2)
        pos = pos+speed*2;
      else
        pos=pos+speed;   //speed
    }
    pushMatrix();
    translate(0, 0, pos);
    pushMatrix();
    switch(gameMode) {
    case 0:
      break;
    case 1:
      scale(51);
      shape(rock1);
      break;
    case 2:
      if (random(2)>0.5) {
        rotateY(PI);
      }
      scale(51);
      shape(rock2);
      break;
    case 3:
      break;
    default:
      break;
    }
    popMatrix();
    pushMatrix();
    rotateX(PI/2);
    translate(0, 0, 0.001);
    if (!gameOver) {
      switch(gameMode) {
      case 0:
        fill(100, 0, 255);
        break;
      case 1:
        fill(#FAEE8C);
        break;
      case 2:
        fill(#FAEE8C);
        break;
      case 3:
        fill(100, 0, 255);
        break;
      default:
        break;
      }
    }
    noStroke();
    rect(-width/2, 0, width, 400);
    popMatrix();
    if (gameMode==2) {
      scale(50*noise(pos));
    } else
      scale(50);
    translate(cloudX, 3, 0);
    scale(cloudSize);
    if (gameMode==0)
      shape(cloud1);
    else if (gameMode==1)
      shape(cloud2);
    else if (gameMode==2)
      shape(cloud3);
    popMatrix();
  }
}
