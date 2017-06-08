class coordSys{
  ArrayList<PVector> markersX;
  ArrayList<Float> markersY;
  int inc = 100;
  
  coordSys(){
    markersX = new ArrayList<PVector>();
    
    markersY = new ArrayList<Float>();
    for(int i = 0; i<=(y0-yMax)/yScl; i+=100){
     markersY.add((float)i); 
    }
  }
  
  void update(){
   updateXaxis();
   updateYaxis();
  }
  
  private void updateXaxis(){
    // x axis
   line(0,y0,x0,y0);
   
   // year markers
   if(fin){
     for(PVector v : markersX){
       float x = xScl*(v.x-spd*maxFrm)+x0;
       line(x,y0,x, y0+10);
       for(int i = 0; i<y0-yMax; i+=10){
        point(x, y0-i); 
       }
       line(x,y0,x, y0+10); 
       text(round(v.z),x, y0+18);
     }
     
   }else{
     int year = data.getInt(row,0);
     
     if((year == 1850 || year%10 == 0) && interp == false){
       markersX.add(new PVector(spd*frmCnt, y0, year));
     }
     for(PVector v : markersX){
       float x = xScl*(v.x-spd*frmCnt)+x0;
       line(x,y0,x, y0+10);
       for(int i = 0; i<y0-yMax; i+=10){
        point(x, y0-i); 
       }
       line(x,y0,x, y0+10); 
       text(round(v.z),x, y0+18);
     }
   }
   
  }
  
  
  private void updateYaxis(){
   // y axis
   line(x0,y0,x0,yMax);
   line(x0,yMax,x0-5,yMax+5);
   line(x0,yMax,x0+5,yMax+5);
   
   // check, if new marker needs to be added
   if((y0-yMax)/yScl>markersY.get(markersY.size()-1)+inc){
     markersY.add(markersY.get(markersY.size()-1)+inc);
     
     // remove, if too many
     if(markersY.size()>10){
      markersY.remove(9);
      markersY.remove(8);
      markersY.remove(7);
      markersY.remove(6);
      markersY.remove(4);
      markersY.remove(3);
      markersY.remove(2);
      markersY.remove(1);
      inc *= 5;
     }
   }
   
   // print all markers
   for(float f : markersY){
     line(x0,y0-f*yScl,x0-15,y0-f*yScl);
     textAlign(RIGHT,BOTTOM);
     textSize(12);
     text(str(round(f)), x0-20, y0-f*yScl);
     textAlign(BASELINE);
   }
  }
 
}