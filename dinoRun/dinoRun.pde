import peasy.PeasyCam;
PeasyCam cam;

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
PShape cactus, cactus2, rock1, rock2, cloud1, cloud2, sun;
PShape road;
PImage rd, ca, rk;
Road[] roads=new Road[15];
ArrayList<Cactus> cates = new ArrayList<Cactus>();
int lockTime = 2*200; //speed and pro
int cactusDis;
boolean onFloor=true;
float dinoHeight=0;
float dinoVel=0;
float jumpVel = 2.5;
float gravity = 0.09;
int golbalSpeed = 2;
boolean gameOver = false;
int score = 0;
PShape world;
PImage panorama;

SoundFile jump, die;

void setup() {
  //size(1920, 900, P3D);
  fullScreen(P3D,2);
  //cam = new PeasyCam(this, 100);

  rock1=loadShape("data/mount.obj");
  cactus2=loadShape("data/bigcactus.obj");
  cloud1=loadShape("data/cloud1.obj");
  cloud2=loadShape("data/cloud2.obj");
  cactus=loadShape("data/cactus.obj");
  sun = loadShape("data/sun.obj");
  jump= new SoundFile(this, "jump.mp3");
  die= new SoundFile(this, "demise.wav");
  world=createShape(SPHERE, 1000);
  panorama=loadImage("data/day.png");
  world.setTexture(panorama);
  world.setStroke(false);
  for (int i=0; i<15; i++) {
    roads[i]=new Road(i);
  }
  cates.add(new Cactus());

  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);

  initCubeMap();
}


void draw() {
  time=1.0*frameCount/393.8;
  background(255);
  //drawCubeMap();
  
  
  pushMatrix();
  translate(width/2, height*0.6-40, height/2+235);
  shape(world);
  //translate(954, 535, 82);
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

  directionalLight(255, 255, 255, 1, -42, 9);
  scale(1, -1, 1);
  for (int i=0; i<cates.size(); i++) {
    Cactus cate = cates.get(i);
    if (!gameOver) {
      cate.display();
      cate.checkDie();
      if (cate.finish()==1) {
        cates.remove(i);
      }
    } else {
      cate.speed=0;
      cate.display();
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

  if (!gameOver) {
    fill(0, 0, 0); 
    score = frameCount/10;
  } else {
    fill(255, 0, 0);
  }
  textSize(60);
  text(str(score), width/2-textWidth(str(score))/2, 100);
  popMatrix();
}

void drawScene() {
  background(255);
  pushMatrix();
  translate(zClippingPlane, zClippingPlane, 0);
  shape(world);

  pushMatrix();
  //translate(width/2, height*0.6, height/2);
  translate(-1, 50, -116);
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
  //drawAxis();
  directionalLight(255, 255, 255, 67, -174, 60);
  scale(1, -1, 1);
  for (int i=0; i<cates.size(); i++) {
    Cactus cate = cates.get(i);
    if (!gameOver) {
      cate.display();
      cate.checkDie();
      if (cate.finish()==1) {
        cates.remove(i);
      }
    } else {
      cate.speed=0;
      cate.display();
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

  if (!gameOver) {
    fill(0, 0, 0); 
    score = frameCount/10;
  } else {
    //fill(249, 142, 123);
    fill(255);
  }
  textSize(60);
  text(str(score), width/2-textWidth(str(score))/2, 100);
  popMatrix();
  popMatrix();
}
void keyPressed() {
  if (key==' ') {
    if (onFloor) {
      jump.play();
      onFloor = false;
      dinoVel=jumpVel;
    }
  }
}

void oscEvent(OscMessage theOscMessage) {
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
  String pattern = theOscMessage.addrPattern();
  println(pattern);
  //float vel = float(pattern);
  
  if (onFloor) {
    jump.play();
    onFloor = false;
    dinoVel=jumpVel;
  }
}
