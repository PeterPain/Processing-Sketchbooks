Table data;
int frameCnt = 0;
int row = 1;
int col = 0;
float val;

PFont sml;
PFont lrg;

Boolean fin = false;
int frmTotal = 0;

int x0 = 1400;
int y0 = 650;
int scl = 75;
int spd = 2;

ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<dataRect> rects = new ArrayList<dataRect>();
ArrayList<timeMarker> markers = new ArrayList<timeMarker>();

String monthLabels[] ={"JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"};

void setup(){
  size(1600, 720, P3D);
  
  // adjust for more/less months per second
  frameRate(150);
  
  colorMode(HSB, 255);
  hint(DISABLE_OPTIMIZED_STROKE);
  
  // load the csv data into a table
  data = loadTable("LOTI.csv","header");
  
  lrg = loadFont("ArialMT-32.vlw");
  textFont(lrg);
  
  // initialize the bar graph
  for(int i = 0; i<12; i++){
    rects.add(new dataRect(10 + 115*i, 450, 0, "-", monthLabels[i]));
  }
  
}

void draw(){
  background(0);
  //if(frameCnt==0) delay(200);
  
  text("Deviations from the average temperature (1951-1980 mean) (Land-Ocean-Temperature-Index)", 5,25);
  text("Maximum positive temperature anomaly YTD per month [°C]", 520,75);
  
  // get data for current frame
  if(frameCnt%12 == 0){
    row++;
    col = 1;
  }else{
    col ++;
  }
  
  // if there is data left in the table...
  if(row<data.getRowCount()){
    // print current Year
    textSize(32);
    text(data.getString(row,0), x0,y0-15);
    
    // if new decade, add marker
    if(data.getInt(row,0)%10 == 0 && col==1){
      markers.add(new timeMarker(data.getString(row,0),x0+spd*frameCnt,y0));
    }
    
    // get current value from table
    val = data.getFloat(row,col);
    
    // check for new max value    
    if(rects.get(col-1).getVal()<val){
      rects.get(col-1).updateValues(val, data.getString(row,0));
    }
    
    // print value as text
    if(!Float.isNaN(val)){
      printValue(val);
    }
    
    // add point to curve
    points.add(new PVector(x0+spd*frameCnt,y0-scl*val, -1));
    
    // plot curve
    noFill();
    strokeWeight(2);
    beginShape();
    for(PVector v : points){
      stroke(128*(2.8-(v.y - y0)/-scl)%255, 255, 255);
      vertex(v.x-spd*frameCnt,v.y,v.z); 
    }
    endShape();
    
    // plot decade markers
    for(timeMarker m : markers){
     m.update(); 
    }
    
    // if there is no more data...
  } else if(fin == true) {
    
    // plot rescaled final curve
    noFill();
    strokeWeight(2);
    beginShape();
    for(PVector v : points){
      stroke(128*(2.8-(v.y - y0)/-scl)%255, 255, 255);
      vertex(map(v.x,x0,x0+spd*frmTotal,0,x0),v.y,v.z); 
    }
    endShape();
    
    // plot decade markers
    for(timeMarker m : markers){
     m.update(); 
    }
    
  } else {
   fin = true; 
   frmTotal = frameCnt-8; //-8 because there is some NaN data in the table at the end
  }
  
  // update the bar graph
  for(dataRect a : rects){
   a.redraw(); 
  }
  
  // draw the coordinate system
  drawCoordSys();
  frameCnt++;
}



/* =====================================
Draws the coordinate system for the plot
======================================== */
void drawCoordSys(){
  stroke(255);
  strokeWeight(2);
  line(0,y0,0,1600,y0,0);
  line(x0,y0+scl*1.5,0,x0,y0-scl*1.5,0);
  
  textSize(18);
  text("+1.5 °C", x0-15, y0-5-scl*1.5);
  //textSize(20);
}


/* =====================================
Prints the current value
======================================== */
void printValue(float value){
  textSize(20);
    if(value<0){
      text("-",x0+5,y0+20,0);
    }else{
      text("+",x0+5,y0+20,0);
    }
    text(abs(value) + " °C",x0+25,y0+20,0);
}