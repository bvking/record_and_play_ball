class ContextG
{
    int actualSec,lastSec, secondsSinceRecordingStart, measureToStartRecording;
    boolean recording = false;
    boolean doneRecording = false;
    int currentTime;
    int secondsToRecord; //nb seconds during which we are going to record

    String infoText;

    ContextG(int secs)
    {
      this.secondsToRecord = secs; 
      this.reset();
    }
    
    
    void startRecording()
    {
      // start recording and reset the measure counter to 0
       this.recording = true;  
       this.secondsSinceRecordingStart=0;
    }
    
    
    void reset()
    {
       fill(255);
       this.infoText = "...waiting";
       this.recording = false;
       this.doneRecording = false;
       this.actualSec=0;
       this.lastSec=0;
       this.secondsSinceRecordingStart =0;                 
       this.measureToStartRecording=0;
       this.currentTime=0;     
    }
  
    void computeSeconds()
    {
       this.currentTime = millis();// Get the current time in milliseconds
       int seconds = (this.currentTime / 1000) % 60; // number of seconds that have passed  since the program started running
       this.actualSec = seconds;
    }
    
    
   void display()
   {     
     this.displayTimer();
     displayText(this.infoText);
   }
    
    
   /**
      Increment the measure
      Display the timer (seconds since recording started) when recording
    */
    void displayTimer()
    {
       if  (this.actualSec!= this.lastSec)
       {      
           this.lastSec = this.actualSec;     
           
           if(this.recording && false == this.doneRecording)
           {
              this.secondsSinceRecordingStart++;
              displayValue(this.secondsSinceRecordingStart);
           }       
       }
    }

  
    /**
      Check when to stop the recording based on the number of seconds to record and the recording state
      If we need to stop we call the sampler and ask it to begingPlaying
    */
    void checkIfSamplingNeedToStopS() 
    {
         if (this.recording &&  (this.secondsSinceRecordingStart >= this.secondsToRecord) ) 
         {
            this.recording = false;
            this.doneRecording=true;
            this.infoText = "done recording";
            samplerG.completeSampling();
        }
    }

}
