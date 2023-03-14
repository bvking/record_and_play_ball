void displayValue(int value){
   textSize (100);
   text (value, width - 100, 100);
}

void displayText(String text)
{
  if(null == text){
     return;
  }
  
   fill(255);
   textSize (20);
   text (text, width - 150, 600);
}
