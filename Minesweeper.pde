import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
int NUM_BOMBS = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++)
    {
      for(int c = 0; c < NUM_COLS; c++)
      {
        buttons[r][c] = new MSButton(r,c);
      }
    }
    setMines();
}
public void setMines()
{
  while(mines.size() < NUM_BOMBS)
  {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[r][c]))
    {
      mines.add(buttons[r][c]);
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
    for(int r = 0; r < NUM_ROWS; r++)
    {
      for(int c = 0; c < NUM_COLS; c++)
      {
        if(!mines.contains(buttons[r][c]) && buttons[r][c].clicked == false)
        {
          return false;
        }
      }
    }
    return true;
}
public void displayLosingMessage()
{
    for(int r = 0; r < NUM_ROWS; r++)
    {
      for(int c = 0; c < NUM_COLS; c++)
      {
        if(mines.contains(buttons[r][c]) && buttons[r][c].clicked == false)
        {
          buttons[r][c].flagged = false;
          buttons[r][c].clicked = true;
        }
      }
    }
    buttons[NUM_ROWS/2][(NUM_COLS/2)-5].setLabel("T");
    buttons[NUM_ROWS/2][(NUM_COLS/2)-4].setLabel("R");
    buttons[NUM_ROWS/2][(NUM_COLS/2)-3].setLabel("Y");
    buttons[NUM_ROWS/2][(NUM_COLS/2)-2].setLabel(" ");
    buttons[NUM_ROWS/2][(NUM_COLS/2)-1].setLabel("A");
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("G");
    buttons[NUM_ROWS/2][(NUM_COLS/2)+1].setLabel("A");
    buttons[NUM_ROWS/2][(NUM_COLS/2)+2].setLabel("I");
    buttons[NUM_ROWS/2][(NUM_COLS/2)+3].setLabel("N");
    buttons[NUM_ROWS/2][(NUM_COLS/2)+4].setLabel(":(");
}
public void displayWinningMessage()
{
    buttons[NUM_ROWS/2][(NUM_COLS/2)-3].setLabel("Y");
    buttons[NUM_ROWS/2][(NUM_COLS/2)-2].setLabel("O");
    buttons[NUM_ROWS/2][(NUM_COLS/2)-1].setLabel("U");
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel(" ");
    buttons[NUM_ROWS/2][(NUM_COLS/2)+1].setLabel("W");
    buttons[NUM_ROWS/2][(NUM_COLS/2)+2].setLabel("I");
    buttons[NUM_ROWS/2][(NUM_COLS/2)+3].setLabel("N");
    buttons[NUM_ROWS/2][(NUM_COLS/2)+4].setLabel("!");
}
public boolean isValid(int r, int c)
{
    if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
    {
      return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    if(isValid(row-1,col-1) == true && mines.contains(buttons[row-1][col-1]) == true)
    {
      numMines++;
    }
    if(isValid(row-1,col) == true && mines.contains(buttons[row-1][col]) == true)
    {
      numMines++;
    }
    if(isValid(row-1,col+1) == true && mines.contains(buttons[row-1][col+1]) == true)
    {
      numMines++;
    }
    if(isValid(row,col+1) == true && mines.contains(buttons[row][col+1]) == true)
    {
      numMines++;
    }
    if(isValid(row+1,col+1) == true && mines.contains(buttons[row+1][col+1]) == true)
    {
      numMines++;
    }
    if(isValid(row+1,col) == true && mines.contains(buttons[row+1][col]) == true)
    {
      numMines++;
    }
    if(isValid(row+1,col-1) == true && mines.contains(buttons[row+1][col-1]) == true)
    {
      numMines++;
    }
    if(isValid(row,col-1) == true && mines.contains(buttons[row][col-1]) == true)
    {
      numMines++;
    }
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
        if(mouseButton == RIGHT)
        {
          flagged = !flagged;
          if(flagged == false)
          {
            clicked = false;
          }
        } else if(mines.contains(this))
        {
          displayLosingMessage();
        } else if(countMines(myRow,myCol) > 0)
        {
          setLabel(countMines(myRow,myCol));
        } else {
          for(int r = myRow-1; r <= myRow+1; r++)
          {
            for(int c = myCol-1; c <= myCol+1; c++)
            {
              if(isValid(r,c) && buttons[r][c].clicked == false && !(r == myRow && c == myCol))
              {
                buttons[r][c].mousePressed();
              }
            }
          }
        }
    }
    public void draw () 
    { 
        stroke(246, 255, 212);
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill((int)(Math.random()*237)+150, (int)(Math.random()*247)+150, (int)(Math.random()*239)+150);
        else 
            fill( 180, 191, 182 );
    
        rect(x, y, width, height);
        fill(0);
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
