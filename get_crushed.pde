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



The wall's hole.
Psuedo-code from Mr. Kiang:
void wallHole(){
  pick a random(8);
  set the point at that index to be color 0
}

*/

#include <MeggyJrSimple.h>

struct point
{
  int x;
  int y;
  int color;
};


point wall[8] = {{0,7}, {1,7}, {2,7}, {3,7}, {4,7}, {5,7}, {6,7}, {7,7}};

//#############
//##VARIABLES##
//#############

int i = 0;
int j = 7;
byte playerx = 3;
byte playery = 0;
int playerDirection = 0;  //1 moves left, 2 moves right
int restOfCeiling = 8;

//#######
//##END##
//#######

void setup()
{
  MeggyJrSimpleSetup();
}


void ceiling()
{
  for(int i = 7; i >= 0; i--)
  {
    DrawPx(wall[i].x, wall[i].y, White);
    if(wall[i].y >= 0)
    {
      wall[i].y--;
    }
    else  //makes the ceiling loop back around to the top
    {
      wall[i].y = 7;
      DrawPx(wall[i].x, wall[i].y, White);
    }
  }
}

void ceilingHole()
{
  for(int y = 7; y >=0; y--)
  {
    DrawPx(random(8), y, Green);
    if( y >=0)
    {
      y--;
    }
    else
    {
      y = 7;
      DrawPx(random(8), y, Green);
    }
  }
}
    

//###################
//##PLAYER MOVEMENT##
//###################

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
        DrawPx(playerx, playery, Yellow);  //character loops around for game balance
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
        playerx = 0;
        DrawPx(playerx, playery, Yellow);  //character loops around for game balance
      }
    }
  }
}

//#######
//##END##
//#######


//##############
//##DIRECTIONS##
//##############

void directions()  //was having a weird problem with the left not registering, Devon helped me out. Big ups
{
  CheckButtonsDown();
  if (Button_Left)
  {
    playerDirection = 1;
  }
  else
  {
    if (Button_Right)
      {
        playerDirection = 2;
      }
    else
    {
      playerDirection = 0;
    }
  }
}

//#######
//##END##
//#######

//############
//##THE LOOP##
//############

void loop()
{ 
  ClearSlate();
  ceiling();
  directions();
  movePlayer();
  DisplaySlate();
  delay(80);
}

//###########
//##THE END##
//###########


