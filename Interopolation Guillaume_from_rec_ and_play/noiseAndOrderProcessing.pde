int recordingTimeSec= 3; // nombre de secondes d'enregistrement

int networkSize = 12; // number of ball
// begin of sampling fonction
ContextG contextG; 
SamplerG samplerG;
BallManager ballManager;
// end of sampling fonction
String debug =""; 

// MANAGE PERSPECTIVE
import peasy.*;
PeasyCam cam;

// MANAGE ARDUINO && TENNSY
import processing.serial.*;
Serial DueSerialNativeUSBport101; //To RECORD positions from the serial port of card.  The native serial port of the DUE finish with 101
Serial teensyport;// To play positions to serial port. 

// change these for screen size
float fov = 45;  // degrees
float w = 1000;
float h = 800;

// don't change these
float cameraZ, zNear, zFar;
float w2 = w / 2;
float h2 = h / 2;

int nbBalls = 12;  // number of ball in function drawBall
int nbMaxDelais= 1000; // delais de suivi entre chaque ball (en frame)

int [] revLfo = new int [networkSize]; //NOT USED to compute the number of round
int numberOfStep = 6400; // 6400 step to do a round
int [] oldPositionToMotor  = new int [networkSize]; //NOT USED 
int [] positionToMotor  = new int [networkSize]; //NOT USED 
int [] DataToDueCircularVirtualPosition = new int [networkSize];  ////NOT USED  position à envoyer à la la carte Teensy pour controler les moteurs


public void settings() {
  size(600, 600, P3D);
}

void setup(){
  //***************************************** SET 3D CAM 
  cam = new PeasyCam(this, 2000);
  cameraZ = (h / 2.0) / tan(radians(fov) / 2.0);
  zNear = cameraZ / 10.0;
  zFar = cameraZ * 10.0;
  println("CamZ: " + cameraZ);
  rectMode(CENTER);
  
  frameRate(30); //30
  
 //  teensyport = new Serial(this,Serial.list()[1],115200); // "/dev/cu.usbmodem142401" GOOD
  recordingTimeSec= 3; // nombre de secondes d'enregistrement
  // setup fonction of sampling
  contextG = new ContextG(recordingTimeSec);
  samplerG = new SamplerG();
  ballManager = new BallManager(nbBalls, nbMaxDelais);
     
}

void draw() 
{ 
  background(0);
  
  PVector position = new PVector(0,0);
  
   translate(0, -800,1000);// To set the center of the perspective. 
   //On peut zoomer ou dezoumer en faisant glisser deux doigts de haut en bas sur le trackpad. Ne pas cliquer sinon on relance l'enregistrement de la sourie.
  
  //****** LES FONCTIONS DE SAMPLING DE GUILLAUME****
  contextG.checkIfSamplingNeedToStopS();
  contextG.display();
  contextG.computeSeconds(); 
  displayMouseAndRecordSampleOrDrawSample();
  //******
  
  
  if(contextG.recording && false == contextG.doneRecording) // Sampling : Record mouseX and mouseY
  { 
    circle( mouseX, mouseY, 10 );
    samplerG.addSample( mouseX, mouseY );
  }
  else 
  {
    if(samplerG.fullTime() > 0)
    {
        // mise à jour de la position avec le sample en cours  
        position = samplerG.getCurrentPosition();

        // affichage des sample
        samplerG.draw(position);

        // affichage du recording avec les vertex
        samplerG.drawRecordingWithVertexes();      
    }
  }  

  rotate(-HALF_PI ); //TO change the beginning of the 0 (cercle trigo) and the cohesion point to - HALF_PI 
  
  float lastBallPosition =  map (position.x, 0, 300, 0, TWO_PI); //netPhase11
  ballManager.updateAndDraw(lastBallPosition);
}
