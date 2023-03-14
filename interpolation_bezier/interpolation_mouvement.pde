int actualSec,lastSec,measure,measureToStartRecording;
boolean preActivateRecording = false;
boolean endRecording =  false;
boolean mouseRecorded = false;

final Path path = new Path();

void setup() {
   size( 800, 800, P3D );
   frameRate( 30 ); 
}

void draw() {
  background(0);
  drawShape();
  
  if    (actualSec!=lastSec){
         lastSec=actualSec;
         measure++;
     }
         actualSec =(int) (millis()*0.001);  // 
         
  if (measure>=measureToStartRecording+2  && actualSec!=lastSec && endRecording == true ) { 
      preActivateRecording = false;
      mouseRecorded = false;
      endSampling();
      endRecording = false;
     }
  text ( " preActivateRecording "+ preActivateRecording + " measure" +  measure + " measureToStartRecording" + measureToStartRecording, 100, 100); 
  path.draw();
}

void drawShape() {
  path.mouseDragged();
}

void mousePressed()  {
  mouseRecorded =true;
  path.startNewSample();
}

void endSampling() {
  path.endSampling();
}

import java.util.function.Predicate;

final class Automater {

  private static final int STEPS = 60;

  private final ArrayList<PVector> anchors;
  private final Anchor head;
  private final Anchor tail;

  Automater(ArrayList<PVector> anchors) {
    this.anchors = new ArrayList<>(anchors);
    head = new Anchor(true);
    tail = new Anchor(false);
  }
  
  ArrayList<PVector> build() {
    final ArrayList<PVector> xys = new ArrayList<>();
    final float x1 = head.loc.x;
    final float y1 = head.loc.y;
    final float x2 = tail.loc.x;
    final float y2 = tail.loc.y;
    for (int i = 0; i < STEPS; i++) {
      final float t = i / (float) STEPS;
      final float x = bezierPoint(
        x1, x1 + head.vel.x,
        x2 + tail.vel.x, x2, t);
      final float y = bezierPoint(
        y1, y1 + head.vel.y,
        y2 + tail.vel.y, y2, t);
      xys.add(new PVector(x, y));
    }
    return xys;
  }

  private final class Anchor {

    private final PVector loc;
    private final PVector vel;

    Anchor(boolean head) {
      final int id = (head) ? anchors.size() - 1 : 0;
      loc = anchors.get(id);
      vel = initVel(head, id).mult((head) ? 1 : -1);
    }

    private PVector initVel(boolean head, int id) {
      final Direction xDir = new Direction();
      final Direction yDir = new Direction();
      for (int i = 1; i < (anchors.size() / 2); i++) {
        final int curr = (head) ? id - i : i;
        final PVector currLoc = anchors.get(curr);
        final PVector prevLoc = anchors.get(curr - 1);
        xDir.update(currLoc.x, prevLoc.x);
        yDir.update(currLoc.y, prevLoc.y);
        if (xDir.done || yDir.done) {
          break;
        }
      }
      return new PVector(xDir.total, yDir.total);
    }

    private class Direction {

      Predicate<Float> test;
      boolean done;
      boolean lock;
      float total;

      private void update(float xyCurr, float xyPrev) {
        final Float vel = xyCurr - xyPrev;
        if (!lock && vel != 0) {
          lock = true;
          test = (vel > 0) ? e -> e >= 0 : e -> e <= 0;
        }
        if (lock) {
          if (!test.test(vel)) {
            done = true;
            return;
          }
        }
        total += vel;
      }
    }
  }
}

final class Path {

  private static final int ANCHOR_SIZE = 8;

  private final ArrayList<PVector> autoAnchors = new ArrayList<>();
  private final ArrayList<PVector> userAnchors = new ArrayList<>();

  void draw() {
    pushStyle();
    ellipseMode(CENTER);
    stroke(0);
    strokeWeight(1);
    drawAnchors(userAnchors, #FFFFFF);
    drawAnchors(autoAnchors, #FF8C00);
    popStyle();
  }

  private void drawAnchors(ArrayList<PVector> anchors, color c) {
    fill(c);
    anchors.stream().forEach(e -> ellipse(e.x, e.y, ANCHOR_SIZE, ANCHOR_SIZE));
  }

  void mouseDragged() {
    
  if  ( preActivateRecording){  //draw vector
        userAnchors.add(new PVector(mouseX, mouseY));
     }
  }
  
  void startNewSample() {
    measureToStartRecording=measure;
    preActivateRecording=true;  
    autoAnchors.clear();
    userAnchors.clear();
    endRecording = true;
 }
 
  void endSampling() {
    final Automater automater = new Automater(userAnchors);
    ArrayList<PVector> anchors = automater.build();
    anchors.stream().forEach(e -> autoAnchors.add(new PVector(e.x, e.y)));
  }
}
