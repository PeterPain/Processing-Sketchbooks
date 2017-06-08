class infoBlock  implements Comparable<infoBlock>{
 float posX = 0;
 float posY = 0;
 float xOff = 40;
 float yOff = 0;
 String value = "-";
 PImage flag;
 
 float blkWidth = 45;
 float blkHeight = 23;
 
   infoBlock(PImage flag){
     this.flag = flag;
   }
   
   // feed new values
   void update(float posX, float posY, String value){
     this.posX = posX;
     this.posY = posY;
     this.value = value.replace(",",".");
   }
   
   // draw the info block
   void drawBlock(){
     //tint(255, 175);
     stroke(0);
     strokeWeight(1);
     noFill();
     
     line(posX,posY,posX+xOff,posY+yOff);
     
     rect(posX+xOff,posY+yOff,blkWidth,blkHeight);
     image(flag, posX+xOff, posY+yOff,blkWidth,blkHeight);
     textSize(18);
     text(value, posX+xOff+blkWidth+5, posY+yOff+blkHeight/2);
   }
   
   
   
   public void setOffset(float yOff){
     this.yOff = yOff;
   }
   
   public void addOffset(float yOff){
     this.yOff += yOff;
   }
   
   public float getPos(){
      return posY+yOff; 
   }
   
   @Override
    public int compareTo(infoBlock block) {
        int result = 0; //<>//
        if(this.posY>block.posY || Float.isNaN(this.posY)){
          result = -1;
        } else if(this.posY<block.posY || Float.isNaN(block.posY)){
          result = 1;
        }
        return result;
    }
  
}