//Meggy "don't get crushed" game
/*
void to draw the player
void to move the player left and right

for the actual cieling that comes down to crush the player, it will have a
one-pixel gap that the player will have to stand under before the cieling falls.

the cieling will move down three pixels slowly, and then it will fall down quickly.
After the cieling falls, don't let the player move.
The cieling will dissolve and a new one will appear at the top of the screen.

The delay of the cieling falling will decrease each time.

If the player presses a button, it will speed up his character's movement, which
will help in the late game.

*/

#include <MeggyJrSimple.h>



//////////Global Variables//////////
int i=0;
int j=7;
byte playerx=3;
byte playery=0;
byte delayplayer=100;
int playerDirection=0;  //1 moves left, 2 moves right
byte gapX=random(8);
byte gapY;
byte ceilingX=0;
byte ceilingY=7;

void setup()
{
  MeggyJrSimpleSetup();
}



/*void ceiling()
{
  for(int i = 0; i < 8; i++)
  {
    for(int j = 7; j < 8; j++)
    {
      if (j > 0)
      {
        j--;
        DrawPx(i,j, Green);
      }
      else
      {
        ClearSlate();
        j = 7;
        DrawPx(i, j, Green);
      }
    }
  }
}*/

void ceiling()
{
  if(ceilingY > 0)
  {
    ceilingY--;
    DrawPx(ceilingX, ceilingY, Green);
    delay(100);
  }
  else
  {
    ClearSlate();
    ceilingY=7;
    DrawPx(ceilingX, ceilingY, Green);
  }
}

void gapUpdate()
{
  if (gapY > 0)
  {
    gapY--;
    DrawPx(gapX, gapY, Red);
    delay(100);
  }
  else
  {
    ClearSlate();
    gapY=7;
    gapX=random(8);
    DrawPx(gapX, gapY, Red);
  }
}




void movePlayer()
{
  switch(playerDirection)
  {
    case 0:  //playerDirection = 0, so no movement, it just draws the player in the same spot
    {
      DrawPx(playerx, playery, Yellow);
    }
    break;
    
    case 1:  //for moving the player left
    {
      if (playerx > 0)
      {
        playerx--;
        DrawPx(playerx, playery, Yellow);
      }
      else
      {
        playerx= 7;
        DrawPx(playerx, playery, Yellow);  //character loops around
      }
    }
    break;
    
    case 2:  //for moving the player right
    {
      if (playerx < 7)
      {
        playerx++;
        DrawPx(playerx, playery, Yellow);
      }
      else
      {
        playerx= 0;
        DrawPx(playerx, playery, Yellow);  //character loops around
      }
    }
  }
}

void directions()  //was having a weird problem with the left not registering, Devon helped me out. Big ups
{
  CheckButtonsDown();
  if (Button_Left)
  {
    playerDirection = 1;
  }
  else {
    if (Button_Right)
      {
        playerDirection = 2;
      }
    else {
      playerDirection = 0;
    }
  }
}

  
  

void loop()
{ 
  ClearSlate();
  ceiling();
  gapUpdate();
  directions();
  movePlayer();
  DisplaySlate();
  delay(40);
}
  


