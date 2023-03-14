void assignMotorWithPosition() {  // cette onglet inutile pour le moment
  
           for (int i = 0; i < 12; i++) {
      // rev[i]=rev[0];


      //*******************************  ASSIGN MOTOR WITH POSITION

      if (revLfo[i]!=0  && (positionToMotor[i] >  0) ) { // number of revLfoolution is even and rotation is clock wise   
        DataToDueCircularVirtualPosition[i]= int (map (positionToMotor[i], 0,numberOfStep, 0,numberOfStep))+ (revLfo[i]*numberOfStep);
      }

      if (revLfo[i]!=0  && (positionToMotor[i] <  0)) { // number of revLfoolution is even and rotation is Counter clock wise          // pos[i]= int (map (positionToMotor[i], 0, -NumberofStep, 0,numberOfStep))+ (revLfo[i]*NumberofStep);
        DataToDueCircularVirtualPosition[i]= int (map (positionToMotor[i], 0, -numberOfStep,numberOfStep, 0)) +(revLfo[i]*numberOfStep);       //   print ("pos "); print (i); print (" ");println (pos[i]);
      }

      if (revLfo[i]==0 && (positionToMotor[i] < 0) ) { //  number of revLfoolution is 0 and rotation is counter clock wise 
        DataToDueCircularVirtualPosition[i]= int (map (positionToMotor[i], 0, -numberOfStep,numberOfStep, 0));        
      }         
      if  (revLfo[i]==0 && (positionToMotor[i] > 0) ) {  //  number of revLfoolution is 0 and rotation is clock wise     
        DataToDueCircularVirtualPosition[i]= int (map (positionToMotor[i], 0,numberOfStep, 0,numberOfStep));                //      print ("pos "); print (i); print (" CW revLfo=0 ");println (pos[i]);
      }
      
  //    recordLastDataOfMotorPosition[i]=  DataToDueCircularVirtualPosition[i];
    }
  
  }
   
void dataToTeensy() {
    int speedDelta=10;
    int driverOnOff=3;
    int dataToTeensyNoJo=-3; // trig noJoe in Teensy
    String dataMarkedToTeensyNoJo  ="<" // BPM9   

      +   DataToDueCircularVirtualPosition[11]+ ","+DataToDueCircularVirtualPosition[10]+","+DataToDueCircularVirtualPosition[9]+","+DataToDueCircularVirtualPosition[8]+","+DataToDueCircularVirtualPosition[7]+","
      +   DataToDueCircularVirtualPosition[6]+  ","+DataToDueCircularVirtualPosition[5]+","+DataToDueCircularVirtualPosition[4]+","+DataToDueCircularVirtualPosition[3]+","+DataToDueCircularVirtualPosition[2]+","//DataToDueCircularVirtualPosition[2]

      +  (speedDelta) +","+ driverOnOff +","+dataToTeensyNoJo+","
      
  //    + TrigmodPos[11]+","+TrigmodPos[10]+","+TrigmodPos[9]+","+TrigmodPos[8]+","+TrigmodPos[7]+","+TrigmodPos[6]+","+TrigmodPos[5]+","+TrigmodPos[4]+","+TrigmodPos[3]+","+TrigmodPos[2]+","+TrigmodPos[1]+","+TrigmodPos[0]+ ">";  // to manage 12 note

    +0+","+0+","+0+","+0+","+0+","+0+","+0+","+0+","+0+","+0+","+0+">";    

    println(frameCount + ": " +  " addSignalDataMarkedToTeensyNoJo" + ( dataMarkedToTeensyNoJo ));
  //  DueSerialNativeUSBport101.write(dataMarkedToTeensyNoJo);// Send data to Arduino.
    teensyport.write(dataMarkedToTeensyNoJo); // Send data to Teensy. only the movement
 }
 
 /*
   
    // note pour moi!! ATTENTION à rechanger la ligne de dessous 
    // **** for (int i = 2; i <  networkSize-2; i+=1)
  for (int i = 0; i <  networkSize; i+=1)
  { // la premiere celle du fond i=2,  la derniere celle du devant i=11
    oldPositionToMotor[i]=positionToMotor[i];

  if (phases[i][frameCount % nbMaxDelais]>0) 
  {    
    positionToMotor[i]= ((int) map (phases[i][frameCount % nbMaxDelais], 0, TWO_PI, 0, numberOfStep)); //
  }   
  else 
  {
   positionToMotor[i]= ((int) map (phases[i][frameCount % nbMaxDelais], 0, -TWO_PI, numberOfStep,  0)); //
  } 
    
  if (oldPositionToMotor[i]> positionToMotor[i]) //fonction de comptage du nombre de tour. Elle fonctionne seulement de gauche à droite
        {
    revLfo[i]++; // ajoute 1 au compteur quand l'ancienne position > actuelle position   
    }
  } 
  int i = 0;  // imprime les données de la balle samplée uniquement toutes les 10 frames
  if (frameCount%3==0){ //
   print ( " phase "  + phases[i][frameCount % nbMaxDelais] );
  println ( " compteur "  + revLfo[i] +  " position " +  positionToMotor[i] + " temps écoulé " + millis()%1000);  
   }
     assignMotorWithPosition();   //fonction qui calcule et envoye les donnes de position à la carte de controle des moteurs
}
*/
