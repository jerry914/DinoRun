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
      pos=pos+speed;   //speed
    }
    pushMatrix();
    translate(0, 0, pos);
    if (type==1) {
      pushMatrix();
      scale(25);
      shape(cactus2);
      popMatrix();
    }
    scale(51);
    //shape(rock1);
    noStroke();
    pushMatrix();
    rotateX(PI/2);
    translate(-50, 0, 0.001);
    //if (!gameOver) {
    //  fill(#FAEE8C);
    //}
    rect(0, 0, 100, 100);
    popMatrix();
    translate(cloudX, 3, 0);
    scale(cloudSize);
    shape(cloud1);
    popMatrix();
  }
}
