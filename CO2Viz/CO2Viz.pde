import java.util.Collections;


Table data;
PFont fnt;

int frmCnt = 0; // current frame#
int maxFrm = 0;
boolean fin = false;

int interpFac = 30;
boolean interp = false;

float xScl = 1; // scale factor for x axis
float yScl = 3; // scale factor for y axis
float yMax = 100; // rescale if less than yMax pixels from top

float spd = 8; // spd of the curves

String fileNames[] = {"ukraine.png", "uk.png", "usa.png", "canada.png", "china.png", "russia.png", "india.png", "japan.png", "france.png", "germany.png"};
int col[] = {133, 58, 236, 289, 359, 248, 41, 333, 137, 0};
int brg[] = {255,255,255,255,255,255,255,255,255,0};
int row = -1;

float x0 = 1100;
float y0 = 630;

ArrayList<ArrayList<PVector>> curves = new ArrayList<ArrayList<PVector>>();

blockCoordinator blocks = new blockCoordinator();

coordSys coordSys;

void setup(){
  size(1280,720,P3D);
  colorMode(HSB);
  
  fnt = loadFont("ArialMT-32.vlw");
  textFont(fnt);
  
  frameRate(60);
  data = loadTable("data.csv","header");
  
  for(int i = 0; i<data.getColumnCount()-1;i++){
    curves.add(new ArrayList<PVector>());
    blocks.add(new infoBlock(loadImage(fileNames[i])));
  }
  
  coordSys = new coordSys();
  
}

void draw(){
  if(frmCnt==0) delay(200);
  background(255);
  
  textSize(20);
  text("CO2 Emissions Totals - Total CO2 Emissions Excluding Land-Use Change and Forestry (Top 10 Countries) [MtC02] ",5,30);
  textSize(14);
  text("Sources: WRI/CAIT, CDIAC", 5, height -10);
  
  // only read a new data point every interpFac frames, else interpolate
  if(frmCnt%interpFac==0){
    row++;
    interp = false;
  } else {
    interp = true;  
  }
  
  // if there is data left...
  if(row<data.getRowCount()){
    
    // generate new data point for each curve
    for(int i = 0; i<data.getColumnCount()-1;i++){
      float valX = spd*frmCnt;
      float valY = 0;
      
      // choose between interpolated data point or table data point
      if(interp && row<data.getRowCount()-1){
        valY = data.getFloat(row,i+1)+(frmCnt%interpFac)*(data.getFloat(row+1,i+1)-data.getFloat(row,i+1))/interpFac;
      } else {
        valY = data.getFloat(row,i+1);
      }
      
      // add new data point
      curves.get(i).add(new PVector(valX,-valY,0));
      
      // update the info block
      blocks.get(i).update(x0, -valY*yScl+y0, String.format("%.2f",valY));
      
      // rescale if out of screen
      if(valY*yScl>(y0-yMax)){
         yScl = yScl*0.995; //0.997 for interp 30
      }
      if(valX*xScl>(x0+3)){
         xScl = xScl*0.999; 
      }
    }
    
    // plot curves
    noFill();
    strokeWeight(2);
    int nr = 0;
    for(ArrayList<PVector> curve : curves){
      beginShape();
      for(PVector v : curve){
        stroke(col[nr]*255/360,255,brg[nr]);
        vertex(xScl*(v.x-spd*frmCnt)+x0,yScl*v.y+y0,v.z);
      }
      endShape();
      nr++;
    }
    
    // plot the year
    fill(0);
    textSize(32);
    text(data.getString(row,0), width-100, height-20);
    
  } else if(fin){
    // plot final result
    noFill();
    strokeWeight(2);
    int nr = 0;
    for(ArrayList<PVector> curve : curves){
      beginShape();
      for(PVector v : curve){
        stroke(col[nr]*255/360,255,brg[nr]);
        vertex(xScl*(v.x-spd*maxFrm)+x0,yScl*v.y+y0,v.z);
      }
      endShape();
      nr++;
    }
  } else {
    fin = true;
    maxFrm = frmCnt -1 ; 
  }
  
  blocks.update();
  
  coordSys.update();
  
  frmCnt++;
}