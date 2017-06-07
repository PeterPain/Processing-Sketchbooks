class dataRect{
 
  float posX, posY, value;
  String year, caption;
  int flashTarget = 0;
  int scale = 275;
  
  // constructor
  dataRect(float posX, float posY, float value, String year, String caption){
   this.posX = posX;
   this.posY = posY;
   this.value = value;
   this.year = year;
   this.caption = caption;
  }
  
  // update the data values
  public void updateValues(float value, String year){
   this.value = value; 
   this.year = year;
   this.flashTarget = millis() + 500;
  }
  
  public void redraw(){
    stroke(255);
    
    // flash bar for 500 ms, if data has changed
    fill(map(flashTarget-millis(),500,0,255,0), 255);
    rect(posX, posY, 80, -value*scale);
    fill(255);
    
    // month name
    textSize(32);
    text(caption, posX, posY+75,0);
    
    // year 
    text(year, posX, posY+40);
    
    // value
    textSize(25);
    text("+" + value, posX, posY - 5 - value*scale);
  }
  
  
  public float getVal(){
   return this.value; 
  }
  
}