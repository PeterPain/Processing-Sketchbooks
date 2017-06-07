class timeMarker{
  String caption;
  float posX, posY;
  
  // constructor
  timeMarker(String caption, float posX, float posY){
    this.caption = caption;
    this.posX = posX;
    this.posY = posY;
  }
  
  
  void update(){
    strokeWeight(2);
    stroke(255);
    
    // if all data has been shown, rescale
    if(fin==true){
      float x = map(posX,x0,x0+spd*frmTotal,0,x0);
      
      // marker
      line(x,posY-20,0,x, posY,0);
      
      // transparent box behind the year caption
      noStroke();
      fill(0,255,0,100);
      rect(x,posY-38,47,25);
      fill(255);
      
      // year
      textSize(18);
      text(caption, x, posY-20);
      
    // else scroll the markers with the data  
    }else{
      
      // marker
      line(posX-spd*frameCnt,posY-35,0,posX-spd*frameCnt, posY,0);
      textSize(25);
      
      // transparent box behind the year caption
      noStroke();
      fill(0,128,1,100);
      rect(posX+2-spd*frameCnt,posY-60,60,30);
      fill(255);
      
      // year
      text(caption, posX-spd*frameCnt, posY-40);      
    }
  }
  
}