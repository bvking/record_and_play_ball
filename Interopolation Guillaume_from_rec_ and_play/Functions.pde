/*
    If we are recording and not done with it, we display the mouse position with a circle
    If we are done recording we call the sampler and tell him to display the next point (unless it has no points)
*/
void displayMouseAndRecordSampleOrDrawSample()
{
  
}
int clickCounter = 0;

void mousePressed() 
{  
    clickCounter++;
      
    if(1 == clickCounter)
    {
       samplerG.reset();
       contextG.startRecording();
       contextG.infoText = "... recording";
    }
    
    else if (clickCounter>=2)
    {
      background( 0 );
      samplerG.reset();  
      contextG.reset();
      clickCounter = 0;
    }   
}
