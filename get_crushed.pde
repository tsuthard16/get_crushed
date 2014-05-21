//Meggy "don't get crushed" game
/*

Don't get decimated by a wall that's trying to kill you.

Left and right buttons to move your character.

Holding down the A button will make your character move more quickly.

Every four times the player passes through the hole, the player will move up one pixel, so you have less time to react.

*/

#include <MeggyJrSimple.h>

struct point
{
  int x;
  int y;
};


point wall[8] = {{0,7}, {1,7}, {2,7}, {3,7}, {4,7}, {5,7}, {6,7}, {7,7}};

//#############
//##VARIABLES##
//#############


byte playerx = 3;
byte playery = 0;
int playerDirection = 0;  //1 moves left, 2 moves right. 0 just means that nothing will happen.
int counter = 0;//this counter will be part of the modulus, and will affect the player's movement at the press of button A.
int speedCount = 2;  //a number for the speed of the player just to slow him down some.
int wallSpeed = 0;//this will be part of the wall modulus. It makes the ceiling fall at a reasonable speed.
int temp = random(8);
int time = 1;
int toneHertz = 32182;
int d = 100;
int score = 0;

//#######
//##END##
//#######

void setup()
{
  //Serial.begin(9600);
  ClearSlate();
  MeggyJrSimpleSetup();
  DrawPx(2,1,Red);    //Draws a big red A to hopefully tell the player to press that button
  DrawPx(2,2,Red);
  DrawPx(2,3,Red);
  DrawPx(2,4,Red);
  DrawPx(2,5,Red);
  DrawPx(3,5,Red);
  DrawPx(4,5,Red);
  DrawPx(5,5,Red);
  DrawPx(5,4,Red);
  DrawPx(5,3,Red);
  DrawPx(5,2,Red);
  DrawPx(5,1,Red);
  DrawPx(3,3,Red);
  DrawPx(4,3,Red);
  DisplaySlate();
  while(!Button_A)
  {
    delay(1);
    time++;
    CheckButtonsPress();
  }
  randomSeed(time);  //randomSeeds with the time it takes the player to press the A button. 
}

//###############
//##THE CEILING##
//###############

void moveCeiling()
{
  // decreases y on every value in the array.
  for(int i = 7; i >= 0; i--)
  {
    if (wall[i].y < 0)
    {
      wall[i].y = 7;    //when the ceiling reaches the bottom it "loops" back to the top
      temp = random(8); //create a new hole x variable.
    }
    else wall[i].y--;
  }
}


void drawCeiling()
{
  for(int i = 7; i >= 0; i--)
  {
    DrawPx(wall[i].x, wall[i].y, White);
    DrawPx(temp, wall[i].y, Dark);  //code for the ceiling hole. It grabs a random xcoord and draws it on the same level as the rest of the wall.
  }
}


void checkRekt()
{
  for(int i = 7; i >= 0; i--)
  if(wall[i].x == playerx && wall[i].y == playery && ReadPx(playerx, playery) == White)  //checks to see if a player is on a white pixel
  {
    for(int x = 0; x < 8; x++)
    {
      for(int y = 0; y < 8; y++)
      {
        DrawPx(x, y, Red);  //if the player is indeed on a white pixel, they get a lovely red square!
      }
    }

    wallSpeed = 0;              //wallSpeed set to zero to get the ceiling to stop moving.
    DisplaySlate();
    Tone_Start(ToneB2, 900);    //and a loud noise!
    delay(900);                 //for .9 seconds B)
    playerx = 3;    //all variables are reset for when the player gets decimated.
    playery = 0;
    wallSpeed = 8;
    d = 100;
    toneHertz = 32182;
    score = 0;
    ClearSlate();  //clears the slate and the game starts again.
  }
}    

void goodNoise()
{
  for(int i = 7; i >= 0; i--)
  {
    if(playerx == temp && playery == wall[i].y)  //if the player is in the right spot (ie not rekt), it plays an encouraging noise!
    {
      if(toneHertz > 5000)
      {
        toneHertz = toneHertz - 25;  //the noise gets higher as the player plays for longer
      }
      Tone_Start(toneHertz, 30);
    }
  }
}
  
void moveUp()
{
  if(score/4 == 32)  //because of the weird way the loop works, the fourth time the player makes it through the hole, score = 128. 128/4 = 32
  {
    if(playery < 3)  //doesn't get higher than the 4th pixel.
    {
       playery++;  //moves the player up one space, making the game harder (you have less time to react)
       score = 0;  //sets "score back" to zero so the game doesn't freak out.
       //Serial.println("scorereset");
    }
  }
} 


void speedUp()
{
  for(int i = 7; i >= 0; i--)
  {
    if(playerx == temp && playery == wall[i].y)
    {
      score++;
      Serial.println("score");
      if(4 / counter == 2)  //slows down the rate at which the delay decreases
      {
        if(d > 42)
        {
          d--;    //decrease in overall delay of the game to make it faster
          //Serial.println("score");
        }
      }
    }
  }
}

//###################
//##PLAYER MOVEMENT##
//###################

void drawPlayer()  //draws your little dude
{
  DrawPx(playerx, playery, Yellow);
}

void movePlayer()  //lets you move your little dude around
{
  switch(playerDirection)
  {
    case 0:  //playerDirection = 0, so no movement, it just draws the player in the same spot
    {
    }
    break;
    
    case 1:  //for moving the player left
    {
      if (playerx > 0)
      {
        playerx--;
      }
      else
      {
        playerx= 7;
      }
    }
    break;
    
    case 2:  //for moving the player right
    {
      if (playerx < 7)
      {
        playerx++;
      }
      else
      {
        playerx = 0;
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
{                  //code sets the direction of the player depending on the key pressed.
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
  if (counter > 2)  //this "counter" goes up to two every two times through the loop and is used for the "boost" button for the player, as well as slowing down the wall slightly.
  {  
    counter = 0;
  }
  else
  {
    counter++;
  }
  
  ClearSlate();
  directions();
  
  if(counter%wallSpeed == 0)  //makes the wall move at a reasonable speed through the loop.
  {
    moveCeiling();
  }
  drawCeiling();
  
  checkRekt();
  goodNoise();
  speedUp();
  moveUp();
  
  CheckButtonsDown();
  {
    if (Button_A)  //if the player holds down the A button, the "boost" is activated, and there is no modulus creating a "slowdown".
    {
      movePlayer();
    }
    else
    {
      if(counter%speedCount == 1)  //the opposite happens here, so if the player isn't holding down the A button, the loops runs twice before the player moves. 
      {
        movePlayer();
      }
    }
  }
  drawPlayer();
  DisplaySlate();
  delay(d);
}

//###########
//##THE END##
//###########
