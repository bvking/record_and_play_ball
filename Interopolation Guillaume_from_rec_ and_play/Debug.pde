void debugSampler(SamplerG sampler)
{
    sampler.addInterpolationSamplePoints();
    displaySamplePoints(sampler);
}

void displaySamplePoints(SamplerG sampler){
  
  
  int lastMsTime = 0;
  
   for( int i=1; i< sampler.samples.size(); i++) 
   {
        GSample s = sampler.samples.get(i);
        
        int diff = s.msTime - lastMsTime;
        lastMsTime = s.msTime;
        
        //println ("diff ", diff);
        
        fill(255);
        
        if(s.isInterpolation){
           fill(#FF8C00);
        }
        
       circle( s.position.x, s.position.y, 20 );        
    }
}
