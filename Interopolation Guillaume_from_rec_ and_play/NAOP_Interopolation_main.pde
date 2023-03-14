class GSample
{
  int msTime;       //ms time since recording start
  PVector position; //  x, y coordinates
 
  
  //debug variables
  int newMsTime;
  boolean isInterpolation = false;
  
  GSample(int msTime, PVector position, boolean isInterpolation) 
  {
    this.msTime = msTime;  
    this.position = position;  
    this.isInterpolation = isInterpolation;
    this.newMsTime = 0;
  }
}
