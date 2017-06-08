class blockCoordinator{
  ArrayList<infoBlock> blocks;
  ArrayList<infoBlock> sorted;
  
  blockCoordinator(){
    blocks = new ArrayList<infoBlock>(); 
    sorted = blocks;
  }
  
  void add(infoBlock b){
    this.blocks.add(b);  
  }
  
  infoBlock get(int i){
    return blocks.get(i);  
  }
  
  void update(){
    
    // create copy of the array list to sort
    sorted = new ArrayList<infoBlock>(blocks);
    Collections.sort(sorted); //<>//
    
    // draw the first block
    sorted.get(0).drawBlock();
    sorted.get(0).setOffset(0);
    
    for(int i = 1; i<sorted.size(); i++){
      sorted.get(i).setOffset(0);
      
      // check if block would overlap and adjust y value accordingly
     if(sorted.get(i-1).getPos()-sorted.get(i).getPos()<30){
       while(sorted.get(i-1).getPos()-sorted.get(i).getPos()<30){
         sorted.get(i).addOffset(-1);
       }
     }
     // draw adjusted block
     sorted.get(i).drawBlock(); 
    }
  }
  
  
}