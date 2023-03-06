import de.bezier.guido.*;
int NUM_ROWS = 10;
int NUM_COLS = 10;
int numMines = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton> ();

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++){
      for(int n = 0; n < NUM_COLS; n++){  
        buttons[i][n] = new MSButton(i, n);
      
      }
    }
    
    
    setMines();
}
public void setMines()
{
  
  for(int j = 0; j <numMines; j++){  
     int row = (int)(Math.random()* (NUM_ROWS));
     int col = (int)(Math.random()* (NUM_COLS));
     
     if (mines.contains(buttons[row][col])) {
        
        j--;
     }
     else {
       mines.add(buttons[row][col]);
       
     }
     
  }
 
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
  
  int myFlags = numMines;
  int clickedBoxes = (NUM_ROWS * NUM_COLS) - numMines;
   for(int i = 0; i < NUM_ROWS; i++){
     for(int n = 0; n < NUM_COLS; n++){
       if(mines.contains(buttons[i][n])){
          if (buttons[i][n].flagged) 
            myFlags --;
       }
       else if (buttons[i][n].clicked) 
          clickedBoxes --;
     }
   }     
   
   if ( myFlags == 0 && clickedBoxes == 0) {
    
     return true;
   }
     
    
     return false;
}
public void displayLosingMessage()
{
   for(int i = 0; i < NUM_ROWS; i++)
         for(int n = 0; n < NUM_COLS; n++)
           buttons[i][n].myLabel = "";
           

          buttons[1][3].myLabel = "Y";
          buttons[1][4].myLabel = "O";
          buttons[1][5].myLabel = "U";
          buttons[2][2].myLabel = "L";
          buttons[2][3].myLabel = "O";
          buttons[2][4].myLabel = "S";
          buttons[2][5].myLabel = "E";
          buttons[2][6].myLabel = "!";
}
public void displayWinningMessage()
{
          
          
        for(int i = 0; i < NUM_ROWS; i++)
         for(int n = 0; n < NUM_COLS; n++)
           buttons[i][n].myLabel = "";
          
          
          
          buttons[1][3].myLabel = "Y";
          buttons[1][4].myLabel = "O";
          buttons[1][5].myLabel = "U";
          buttons[2][2].myLabel = "W";
          buttons[2][3].myLabel = "O";
          buttons[2][4].myLabel = "N";
          buttons[2][5].myLabel = "!";
          buttons[2][6].myLabel = "!";
}
public boolean isValid(int r, int c)
{
    if( ((r >= 0) && (r <NUM_ROWS)) && ((c >=0) && (c <NUM_COLS)) ){
      return true;
    }
    return false;
}



public int countMines(int row, int col)
{
    int numMines = 0;
    
    for(int r = row-1;r<=row+1;r++)
      for(int c = col-1; c<=col+1;c++)
        if(isValid(r,c) && (mines.contains(buttons[r][c]))) 
          numMines++;
          
    if(mines.contains(buttons[row][col]))
      numMines--;
      
   
    return numMines;
}





public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
       
        clicked = true;
        if (mouseButton == RIGHT){
          if(flagged){
            flagged = false;
            clicked = false;
          } else{
            flagged = true;
          }
        } else if(mines.contains(this)){
          
        displayLosingMessage();
          
        } 
       
        
        else if(countMines(this.myRow,this.myCol) > 0){
       
             Integer mymines = countMines(this.myRow,this.myCol);
             
             buttons[this.myRow][this.myCol].myLabel = mymines.toString(); 
          
          } else {
            // no mines surrounding clicked button
            for(int r = this.myRow-1;r<=this.myRow+1;r++)
               for(int c = this.myCol-1; c<=this.myCol+1;c++) {
                  //middle box
                  if ( isValid(r,c) && !buttons[r][c].clicked)  {
                      if ( r != this.myRow || c != this.myCol) {
                      
                        buttons[r][c].mousePressed();
                      }

                  }
               }
          }
       
       if(isWon()){
         displayWinningMessage();
       }
       
        
    }
    
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill(127, 198, 86);
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(255);
        text(myLabel,x+width/2,y+height/2);
    }
    
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
