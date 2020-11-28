import peasy.PeasyCam;
PeasyCam cam;

import processing.video.*;
Movie video;
int numPixels;

import processing.sound.*;
import java.nio.IntBuffer;
PShader cubemapShader;
PShape myRect;
IntBuffer fbo;
IntBuffer rbo;
IntBuffer envMapTextureID;
int envMapSize = 1024; 
float zClippingPlane = 2000.0f;
//translate(width/2, height*0.6, height/2);
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;


float time;
PShape cactusBig, cactus, cactus2, rock1, rock2, cloud1, cloud2, cloud3, sun;
PShape road;
PImage rd, ca, rk;
Road[] roads=new Road[15];
ArrayList<Cactus> cates = new ArrayList<Cactus>();
ArrayList<Frame> frames = new ArrayList<Frame>();
int lockTime = 2*200; //speed and pro
int cactusDis;
boolean onFloor=true;
float dinoHeight=0;
float dinoVel=0;
float jumpVel = 3.5;
float gravity = 0.05;
int golbalSpeed = 1;
boolean gameOver = false;
int score = 0;
PShape[] world = new PShape[4];
PImage panorama, tex1, tex2;
PImage[] frame = new PImage[3];

SoundFile jump, die;

boolean goDown = false;

int gameMode = 0;

void setup() {
  //size(1920, 900, P3D);
  fullScreen(P3D, 2);
  //cam = new PeasyCam(this, 100);

  rock1=loadShape("data/mount2.obj");
  rock2=loadShape("data/mount.obj");
  cactusBig=loadShape("data/cactus_big.obj");
  cactus2=loadShape("data/bigcactus.obj");
  cloud1=loadShape("data/cloud1.obj");
  cloud2=loadShape("data/cloud2.obj");
  cloud3=loadShape("data/cloud1.obj");
  cactus=loadShape("data/cactus.obj");
  sun = loadShape("data/sun.obj");
  jump= new SoundFile(this, "jump.mp3");
  die= new SoundFile(this, "demise.wav");
  for (int i=0; i<4; i++) {
    world[i]=createShape(SPHERE, 1000);
    world[i].setStroke(false);
  }
  frame[0] = loadImage("data/frame1.png");
  frame[1] = loadImage("data/frame2.png");
  frame[2] = loadImage("data/frame3.png");
  panorama=loadImage("data/day.png");
  tex1=loadImage("data/tex1.png");
  tex2=loadImage("data/tex2.png");
  world[1].setTexture(panorama);
  world[2].setTexture(tex1);
  rock2.setTexture(tex1);
  cloud3.setTexture(tex2);
  for (int i=0; i<15; i++) {
    roads[i]=new Road(i);
  }
  cates.add(new Cactus());

  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);

  initCubeMap();
  video = new Movie(this, "view1.mp4");
  video.loop();
  //video.stop();
  //video = new Capture(this, 640, 480);
  //video.start();
  //numPixels = video.width * video.height;
  colorMode(HSB, 255);
  imageMode(CENTER);
}
void movieEvent(Movie m) {
  m.read();
}

void draw() {
  time=1.0*frameCount/393.8;
  background(255);
  drawCubeMap();
  //draw3DView();
}
void draw3DView() {
  pushMatrix();
  translate(width/2, height*0.6-40, height/2+235);
  switch(gameMode) {
  case 0:
    WBView();
    break;
  case 1:
    classicalView();
    break;
  case 2:
    vanGoView();
    break;
  case 3:
    realView();
    break;
  default:
    WBView();
    break;
  }
  lights();
  directionalLight(255, 0, 255, 1, -42, 9);


  rotateX(PI*4.0);
  rotateY(0);
  rotateZ(0.0);

  if (!onFloor && !gameOver) {
    dinoVel-=gravity;
    dinoHeight+=dinoVel;
    if (dinoHeight<=0) {
      onFloor=true;
    }
    translate(0, dinoHeight, 0);
  }

  scale(1, -1, 1);
  for (int i=0; i<cates.size(); i++) {
    Cactus cate = cates.get(i);
    if (!gameOver) {
      cate.display();
      //cate.checkDie();
      if (cate.finish()==1) {
        cates.remove(i);
      }
    } else {
      cate.speed=0;
      cate.display();
    }
  }
  for (int i=0; i<frames.size(); i++) {
    Frame fra = frames.get(i);
    fra.display();
    if (fra.finish()==1) {
      frames.remove(i);
    }
  }
  if (!gameOver) {
    cactusDis+=2;
    if (cactusDis>lockTime && random(1)>0.99) {
      cates.add(new Cactus());
      cactusDis=0;
    }
    for (int i=0; i<10; i++) {
      roads[i].display();
    }
  } else {
    for (int i=0; i<10; i++) {
      roads[i].speed=0;
      roads[i].display();
    }
  }

  popMatrix();
}
void drawScene() {
  background(255);
  pushMatrix();
  translate(zClippingPlane, zClippingPlane+50, -300);
  switch(gameMode) {
  case 0:
    WBView();
    break;
  case 1:
    classicalView();
    break;
  case 2:
    vanGoView();
    break;
  case 3:
    realView();
    break;
  default:
    WBView();
    break;
  }
  lights();
  directionalLight(255, 0, 255, 1, -42, 9);

  rotateX(PI*4.0);
  //rotateY(PI/2);
  rotateZ(0.0);

  if (!onFloor && !gameOver) {
    dinoVel-=gravity;
    dinoHeight+=dinoVel;
    if (dinoHeight<=0) {
      onFloor=true;
    }
    translate(0, dinoHeight, 0);
  }

  scale(1, -1, 1);
  
  for (int i=0; i<cates.size(); i++) {
    Cactus cate = cates.get(i);
    if (!gameOver) {
      cate.display();
      //cate.checkDie();
      if (cate.finish()==1) {
        cates.remove(i);
      }
    } else {
      cate.speed=0;
      cate.display();
    }
  }
  for (int i=0; i<frames.size(); i++) {
    Frame fra = frames.get(i);
    fra.display();
    if (fra.finish()==1) {
      frames.remove(i);
    }
  }
  if (!gameOver) {
    cactusDis+=2;
    if (cactusDis>lockTime && random(1)>0.99) {
      cates.add(new Cactus());
      cactusDis=0;
    }
    for (int i=0; i<10; i++) {
      roads[i].display();
    }
  } else {
    for (int i=0; i<10; i++) {
      roads[i].speed=0;
      roads[i].display();
    }
  }
  popMatrix();
}

void WBView() {
  shape(world[0]);
}

void classicalView() {
  shape(world[1]);
}

void vanGoView() {
  shape(world[2]);
}

void realView() {
  shape(world[3]);
}
void mouseClicked() {
  frames.add(new Frame());
}

void keyPressed() {
  if (key==' ') {
    if (onFloor) {
      jump.play();
      onFloor = false;
      dinoVel=jumpVel;
    }
  }
  if (key==DOWN) {
    goDown = true;
  }
  if (key =='1') {
    gameMode=1;
  } else if (key =='2') {
    video.play();
    gameMode=2;
  } else if (key =='3') {
    gameMode=3;
  } else if (key =='0') {
    gameMode=0;
  }
}

void keyReleased() {
  if (key==DOWN) {
    goDown = false;
  }
}

void oscEvent(OscMessage theOscMessage) {
  String pattern = theOscMessage.addrPattern();
  println(pattern);
  //float vel = float(pattern);

  if (onFloor) {
    jump.loop();
    onFloor = false;
    dinoVel=jumpVel;
  }
}
