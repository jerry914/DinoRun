void drawAxis() {
  pushMatrix();
  strokeWeight(3);
  stroke(255, 0, 0);
  line(0, 0, 0, 200, 0, 0);

  stroke(0, 255, 0);
  line(0, 0, 0, 0, -200, 0);

  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 200);
  noFill();
  stroke(0,50);

  strokeWeight(1);

  stroke(0,50);
  rotateX(radians(90));
  strokeWeight(1);
  for (int i=0; i<20; i++) {
    for (int j=0; j<20; j++) {
      float x=map(i, 0, 19, -95, 95);
      float y=map(j, 0, 19, -95, 95);
      rect(x, y, 10, 10);
    }
  }

  popMatrix();
}
