float[] x = new float[0];
float[] y = new float[0];
float[] vx = new float[0];
float[] vy = new float[0];

float gridSize = 2;
float grid[][];
float gridTemp[][];


void setup(){
  //size(600,600);
  fullScreen();
  grid = new float[int(float(width)/gridSize)+1][int(float(height)/gridSize)+1];
  gridTemp = new float[int(float(width)/gridSize)+1][int(float(height)/gridSize)+1];
  
  for(int i = 0; i<1000; i++){
    float xNew = random(-width/2, width/2)+width/2;
    float yNew = random(-height/2, height/2)+height/2;
    addPoint(xNew, yNew);
  }
  
}



void draw(){
  
  /*if(frameCount % 1 == 0){
    float xNew = random(-width/4, width/4)+width/2;
    float yNew = random(-height/4, height/4)+height/2;
    //float xNew = sin(frameCount/(2*PI))*40+width/2;
    //float yNew = cos(frameCount/(2*PI))*40+height/2;
    //float xNew = sin(12*frameCount/(2*PI))*40+width/2;
    //float yNew = cos(12*frameCount/(2*PI))*40+height/2;
    addPoint(xNew, yNew);
  }*/
  
  repelPoints();
  movePoints();
  if(frameCount % 1 == 0){
    background(50);
    showGrid();
    showEverything();
  }
  
  removePoints();
  
  saveFrame("output/frame####.png");
}


void addPoint(float xNew, float yNew){
  x = append(x, xNew);
  y = append(y, yNew);
  vx = append(vx, 0);
  vy = append(vy, 0);
}



void repelPoints(){
  for(int i=0; i<x.length-1; i++){
    for(int j=i+1; j<x.length; j++){
      float rSQ = ((x[i]-x[j])*(x[i]-x[j]) + (y[i]-y[j])*(y[i]-y[j]));
      
      float F;
      if(rSQ > 120000){
        F = -min(4/rSQ, 2);
      }
      else{
        F = min(12/rSQ, 4);
      }
      
      float G = y[i]-y[j];
      float A = x[i]-x[j];
      float H = sqrt(G*G+A*A);
      
      vx[i] += F*(A/H);
      vy[i] += F*(G/H);
      vx[j] -= F*(A/H);
      vy[j] -= F*(G/H);
    }
    
    //Hard Edges
    /*if(x[i] < float(width)/40){
      vx[i] *= 0.95;
      vx[i] += 0.02;
    }
    if(x[i] > 39*float(width)/40){
      vx[i] *= 0.95;
      vx[i] -= 0.02;
    }
    if(y[i] < float(height)/40){
      vy[i] *= 0.95;
      vy[i] += 0.02;
    }
    if(y[i] > 39*float(height)/40){
      vy[i] *= 0.95;
      vy[i] -= 0.02;
    }*/
    
    //Soft Edges
    /*vx[i] += map(width-x[i],0,width,0,0.02);
    vy[i] += map(height-y[i],0,height,0,0.02);
    vx[i] -= map(x[i],0,width,0,0.02);
    vy[i] -= map(y[i],0,height,0,0.02);*/
  }
}



void movePoints(){
  for(int i=0; i<x.length; i++){
    x[i] += vx[i];
    y[i] += vy[i];
    
    vx[i] *= 0.99;
    vy[i] *= 0.99;
  }
}



void showGrid(){
  rectMode(CENTER);
  noStroke();
  for(int xGrid=0; xGrid<=int(float(width)/gridSize); xGrid++){
    for(int yGrid=0; yGrid<=int(float(height)/gridSize); yGrid++){
      float minLength = width*height;
      for(int i=0; i<x.length; i++){
        minLength = min(minLength, sqrt((xGrid*gridSize-x[i])*(xGrid*gridSize-x[i]) + (yGrid*gridSize-y[i])*(yGrid*gridSize-y[i])));
      }
      grid[xGrid][yGrid] = minLength;
    }
  }
  
  /*float gradient = 1;
  for(int xGrid=1; xGrid<int(float(width)/gridSize); xGrid++){
    for(int yGrid=1; yGrid<int(float(height)/gridSize); yGrid++){
      gridTemp[xGrid][yGrid] = 50;
      if(abs(grid[xGrid][yGrid]-grid[xGrid-1][yGrid])<gradient && abs(grid[xGrid][yGrid]-grid[xGrid+1][yGrid])<gradient || abs(grid[xGrid][yGrid]-grid[xGrid][yGrid-1])<gradient && abs(grid[xGrid][yGrid]-grid[xGrid][yGrid+1])<gradient){
        gridTemp[xGrid][yGrid] = 255;
      }
    }
  }
  for(int xGrid=0; xGrid<=int(float(width)/gridSize); xGrid++){
    gridTemp[xGrid][0] = 0;
    gridTemp[xGrid][int(float(height)/gridSize)] = 0;
  }
  for(int yGrid=0; yGrid<=int(float(height)/gridSize); yGrid++){
    gridTemp[0][yGrid] = 0;
    gridTemp[int(float(width)/gridSize)][yGrid] = 0;
  }*/
  
  for(int xGrid=0; xGrid<=int(float(width)/gridSize); xGrid++){
    for(int yGrid=0; yGrid<=int(float(height)/gridSize); yGrid++){
      gridTemp[xGrid][yGrid] = (grid[xGrid][yGrid]*grid[xGrid][yGrid]);
    }
  }
  
  float maxGrid = 0;
  for(int xGrid=0; xGrid<=int(float(width)/gridSize); xGrid++){
    for(int yGrid=0; yGrid<=int(float(height)/gridSize); yGrid++){
      maxGrid = max(gridTemp[xGrid][yGrid], maxGrid);
    }
  }
  
  for(int xGrid=0; xGrid<=int(float(width)/gridSize); xGrid++){
    for(int yGrid=0; yGrid<=int(float(height)/gridSize); yGrid++){
      //fill((minLength*minLength));
      fill(400*gridTemp[xGrid][yGrid]/maxGrid);
      rect(xGrid*gridSize,yGrid*gridSize,gridSize+1,gridSize+1);
    }
  }
}




void showEverything(){
  fill(255);
  stroke(255);
  for(int i=0; i<x.length; i++){
    ellipse(x[i], y[i], 3,3);
  }
}




void removePoints(){
  for(int i=0; i<x.length; i++){
    if(x[i] < -width/4 || x[i] > 5*width/4 || y[i] < -height/4 || y[i] > 5*height/4){
      x[i] = x[x.length-1];
      y[i] = y[y.length-1];
      x = shorten(x);
      y = shorten(y);
      
      vx[i] = vx[vx.length-1];
      vy[i] = vy[vy.length-1];
      vx = shorten(vx);
      vy = shorten(vy);
    }
  }
}
