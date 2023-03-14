class SamplerG {

  ArrayList<GSample> samples;
  
  int recordingStartTimeMs;
  int playbackFrame;   
  int initialFullTime;


  SamplerG() 
  {
    this.samples = new ArrayList<GSample>();
    recordingStartTimeMs = 0;
  }
  
  void reset() 
  {
    this.samples = new ArrayList<GSample>();
    playbackFrame = 0;
  }
  
  void addSample( int x, int y ) 
  { 
    int now = millis();
    
    if( this.samples.size() == 0 ){
      recordingStartTimeMs = now;
    }
    
    // milliseconds since recording start
    int msSinceStart = now - recordingStartTimeMs;
    
    // create new sample and add to array list
    this.samples.add( new GSample( msSinceStart, new PVector(x,y), false) );
  }
  
  /*
    Returns msTime of last sample point
  */
  int fullTime() 
  {
    return ( this.samples.size() > 1 ) ?
    this.samples.get( this.samples.size()-1 ).msTime : 0;
  }
  
  void infos()
  {
    println( "Number of samples : ", this.samples.size());
    println( "Full time : ", fullTime());
    
  }
   
  /*
    Start points replay
  */
  void completeSampling() 
  {
    
    println("--- BEGING PLAYING ---");   
    
    recordingStartTimeMs = millis();
    
    playbackFrame = 0;  
    
    initialFullTime = fullTime();
    
    addInterpolationSamplePoints();
    //println( "with new samples : ", samples.size() );
    //reComputeTimestamps();
  }


   /*
   
   */
   void reComputeTimestamps()
   {
     
     //fullTime();  initialFullTime
     long interval = (contextG.secondsToRecord * 1000) / samples.size();
     
      print("interval in ms", interval);
      
      int start = 0;
          
      for( int i=0; i< this.samples.size(); i++) {
               
      
        this.samples.get(i).newMsTime = int(start);
        //samples.get(i).msTime = int(start);
        
        start +=  interval;
         
        //println(i, samples.get(i).msTime,  samples.get(i).newMsTime);
      }
     
   }



  void addInterpolationSamplePoints()
  {
    GSample s0 = this.samples.get(0);
    GSample s1 = this.samples.get(samples.size()-1);
    
    
    float distance = round(dist(s0.position.x, s0.position.y, s1.position.x, s1.position.y));
        
    //200 = 5
    // n = n*5/200
    contextG.infoText = "distance " + distance;
    
    
     // Set the number of interpolation sample points to add
    int numInterpolationPoints = round(distance * 5 / 200 );
    
    if(numInterpolationPoints <= 0) numInterpolationPoints = 2;
    
    println("distance = ", distance,  numInterpolationPoints);
    
    // Interpolate the x and y positions of the sample points
    float x0 = s0.position.x;
    float y0 = s0.position.y;
    float x1 = s1.position.x;
    float y1 = s1.position.y;
    int t0 = s0.msTime;
    int t1 = s1.msTime;
    
    int msTimeIncrement = (t1-t0) / numInterpolationPoints;
    int startMsTime = t0 + msTimeIncrement;
   

    // Calculate the weight factor increment for each interpolation point
    float weightFactorIncrement = 1.0 / (numInterpolationPoints + 1);


    // Add the interpolation sample points
    for(int j = 1; j <= numInterpolationPoints; j++) {
      // Calculate the weight factor for the current interpolation point
      float t = weightFactorIncrement * j;
  
      // Calculate the interpolated x and y positions
      float x = lerp(x0, x1, t);
      float y = lerp(y0, y1, t);
  
      // Draw a circle at the interpolated position
      //circle(x, y, 10);
      this.samples.add( new GSample(startMsTime, new PVector(x,y), true) );
      startMsTime = startMsTime+msTimeIncrement;
    }
  }

  /* 
      This code is responsible for drawing the recording as a series of connected lines, using the LINES style. 
      The beginShape() and endShape() functions define the beginning and end of a shape, 
      and the vertex() function adds a vertex to the shape at the specified position.
  */
  void drawRecordingWithVertexes(){
    // set the stroke color
    //int c = color(random(255),random(255),random(255));
    stroke(255); //c

    // Begin a new shape in the LINES style
    beginShape(LINES);
    
     // Iterate through the samples list
    for( int i=1; i<samples.size(); i++) {
      // Add a vertex at the previous sample's x and y position
      vertex( this.samples.get(i-1).position.x, this.samples.get(i-1).position.y ); // replace vertex with Pvector ???
      // Add a vertex at the current sample's x and y position
      vertex( this.samples.get(i).position.x, this.samples.get(i).position.y );
    }
    
    // End the shape
    endShape();   
  }
  
    
  PVector getCurrentPosition(){
    
    // Calculate the current time in milliseconds, modulo the full time of the recording
    int now = (millis() - recordingStartTimeMs) % fullTime();
    
     //println("now", now);
     
     
    // If the current time is less than the time of the current playback frame, reset the playback frame to 0
    if( now < samples.get( playbackFrame ).msTime ){
       playbackFrame = 0;
    }
        
    // While the time of the next frame is less than the current time, increment the playback frame
    while( this.samples.get( playbackFrame+1).msTime < now ) {
       playbackFrame = (playbackFrame+1) % (samples.size()-1);
    }
         
         
    // Get the current and next frames
    GSample s0 = this.samples.get( playbackFrame );
    GSample s1 = this.samples.get( playbackFrame+1 );
    
    // Calculate the time and position of the current and next frames
    float t0 = s0.msTime;
    float t1 = s1.msTime;
    float dt = (now - t0) / (t1 - t0);
    float x = lerp( s0.position.x, s1.position.x, dt );
    float y = lerp( s0.position.y, s1.position.y, dt );
        
    PVector position = new PVector(x, y);
    return position;
  }   
  /* 
      This code is responsible for drawing the recording  in a loop. 
    
     The while loop is used to iterate through the samples list and find the current playback frame. 
     The lerp() function is used to interpolate the position of the current frame based on the time elapsed. 
     The interpolated position is then used to draw a circle at that position.
  */
 
  void draw(PVector position) 
  {     
     int c = color(random(255),random(255),random(255));
     fill(c);
     
    // Draw a circle at the interpolated position
     circle( position.x, position.y, 20 );  
    
  }
}
