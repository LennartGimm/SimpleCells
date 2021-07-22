PImage img;

int zahl = 20;
float[] xC = new float[zahl];
float[] yC = new float[zahl];

float[] vx = new float[zahl];
float[] vy = new float[zahl];

float[] r = new float[zahl];
float[] g = new float[zahl];
float[] b = new float[zahl];

float cellSize = 36;


void setup(){
  fullScreen();
  background(50);
  
  for(int i = 0; i<zahl; i++){
    xC[i] = random(0.9*width/2, 1.1*width/2);
    yC[i] = random(0.9*height/2, 1.1*height/2);
    
    vx[i] = 0;
    vy[i] = 0;
    
    r[i] = random(120,220);
    g[i] = random(120,220);
    b[i] = random(120,220);
    
    if(i==0){
      r[i] = 220;
      g[i] = 120;
      b[i] = 120;
    }
    if(i==1){
      r[i] = 120;
      g[i] = 220;
      b[i] = 120;
    }
    if(i==2){
      r[i] = 120;
      g[i] = 120;
      b[i] = 220;
    }
    if(i==3){
      r[i] = 220;
      g[i] = 120;
      b[i] = 220;
    }
    if(i==4){
      r[i] = 220;
      g[i] = 220;
      b[i] = 120;
    }
    if(i==5){
      r[i] = 120;
      g[i] = 220;
      b[i] = 220;
    }
    
  }
  
  if(zahl == 1){
    r[0] = 160;
    g[0] = 160;
    b[0] = 160;
  }
  
  img = createImage(width, height, RGB);
}


void draw(){
  background(50);
  multiplyCells();
  moveCells();
  showCells();
  saveFrame("output/cellsColourComparison/frame#####.png");
  //text(frameRate,100,100);
}












void multiplyCells(){
  for(int i = 0; i < zahl; i++){
    if(random(0,100+zahl*20) < 1){
      //int i = int(random(-0.5, float(zahl-1)+0.5));
      zahl ++;
      xC = append(xC, xC[i]+random(-4,4));
      yC = append(yC, yC[i]+random(-4,4));
      vx = append(vx, vx[i]+random(-4,4));
      vy = append(vy, vy[i]+random(-4,4));
      float colourChange = 30;
      r = append(r, r[i]+random(-colourChange,colourChange));
      g = append(g, g[i]+random(-colourChange,colourChange));
      b = append(b, b[i]+random(-colourChange,colourChange));
    }
  }
}














void moveCells(){
  for(int i = 0; i<zahl-1; i++){
    for(int j = i+1; j<zahl; j++){
      float G = yC[j]-yC[i];
      float A = xC[j]-xC[i];
      float H = sqrt(G*G+A*A);
      float v = 0.2;
      if(H < cellSize*1.4){
        vx[i] -= v*(A/H);
        vy[i] -= v*(G/H);
        vx[j] += v*(A/H);
        vy[j] += v*(G/H);
      }
      if(H > cellSize*1.6){
        vx[i] += v*(A/H)/(zahl*zahl);
        vy[i] += v*(G/H)/(zahl*zahl);
        vx[j] -= v*(A/H)/(zahl*zahl);
        vy[j] -= v*(G/H)/(zahl*zahl);
      }
    }
  }
  
  for(int i = 0; i<zahl; i++){
    xC[i] += vx[i];
    yC[i] += vy[i];
    
    vx[i] *= 0.9;
    vy[i] *= 0.9;
  }
}









void showCells(){
  
  float xMin = min(xC) - cellSize-10;
  float xMax = max(xC) + cellSize+10;
  float yMin = min(yC) - cellSize-10;
  float yMax = max(yC) + cellSize+10;
  
  img.loadPixels();
  for(int x = 0; x<width; x++){
    for(int y = 0; y<height; y++){
      
      img.pixels[x+y*width] = color(50);
      
      if(x < xMax && x > xMin && y < yMax && y > yMin){
        float[] distances = new float[zahl];
        for(int i = 0; i<zahl; i++){
          distances[i] = sqrt((xC[i]-x)*(xC[i]-x) + (yC[i]-y)*(yC[i]-y));
        }
        
        if(min(distances) < cellSize*1.1){
          
          int same = 0;
          int[] IDs = new int[2];
          for(int i = 0; i<zahl-1; i++){
            for(int j = i+1; j<zahl; j++){
              if(abs(distances[i]-distances[j]) < 2 && distances[i] < cellSize && distances[j] < cellSize){
                if(distances[i] == min(distances) || distances[j] == min(distances)){
                  if(sqrt((xC[i]-xC[j])*(xC[i]-xC[j])+(yC[i]-yC[j])*(yC[i]-yC[j])) > cellSize*0.2){
                    same = 1;
                    IDs[0] = i;
                    IDs[1] = j;
                  }
                }
              }
            }
          }
          
          int IDmin = 0;
          if(same == 0){
            for(int i = 0; i<zahl; i++){
              if(distances[i] == min(distances)){
                IDmin = i;
              }
            }
          }
          
          if(same == 1){
            img.pixels[x+y*width] = color((r[IDs[0]]+r[IDs[1]])/2, (g[IDs[0]]+g[IDs[1]])/2, (b[IDs[0]]+b[IDs[1]])/2);
          }
          if(min(distances) > cellSize-1 && min(distances) < cellSize+1){
            img.pixels[x+y*width] = color(r[IDmin], g[IDmin], b[IDmin]);
          }
        }
      }
    } 
  }
  img.updatePixels();
  image(img, 0,0);
  
  
  noStroke();
  for(int i = 0; i<zahl; i++){
    fill(r[i],g[i],b[i]);
    ellipse(xC[i], yC[i], cellSize/6, cellSize/6);
  }
  
}
