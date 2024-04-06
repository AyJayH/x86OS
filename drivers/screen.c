#include "ports.h"
#include "screen.h"

void print_at (char *message, int col, int row) {
  if (col >= 0 && row >= 0) {
    set_cursor(get_screen_offset(col, row ));
  }
  int i = 0;
  while (message [i] != 0) {
    print_char(message [i++], col, row, WHITE_ON_BLACK);
  }
}

void print(char *message) {
    print_at(message, -1, -1);
}

void print_char(char character, int column, int row, char attribute){
  char *vidmem = (char *) VIDEO_ADDRESS;
  if (!attribute){
    attribute = WHITE_ON_BLACK; //Set default attribute
  }
  
  int offset;                     //Place offset at specified screen location or wherever current cursor is
  if (column >= 0 && row >= 0){           
    offset = get_screen_offset(column, row);
  } else{
    offset = get_cursor();
  }
  
  if (character == '\n'){       //New line
    int rows = offset / (2*MAX_COLS);
    offset = get_screen_offset(0, rows+1);
  } else{                       //Otherwise insert character and attribute
    vidmem[offset] = character;
    vidmem[offset+1] = attribute;
  }
  
  offset += 2;        //Move offset and cursor
  set_cursor(offset);
}



int get_screen_offset(int column, int row){
  return 2*(row*MAX_COLS+column);
}


int get_cursor(){
  port_byte_out(REG_SCREEN_CTRL, 14);               //Get cursor high byte
  int offset = port_byte_in(REG_SCREEN_DATA) << 8;  //Store
  port_byte_out(REG_SCREEN_CTRL, 15);               //Get cursor low byte
  offset += port_byte_in (REG_SCREEN_DATA);         //Store
  return 2*offset;  //Double for char/attribute
}

void set_cursor(int offset){
  offset /= 2;
  port_byte_out(REG_SCREEN_CTRL, 14);
  port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8)); //Store high byte
  port_byte_out(REG_SCREEN_CTRL, 15);
  port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xff)); //Store low byte
}


void clear_screen() { //Iterate through each char on screen and set to blank
  int row = 0;
  int col = 0;
  for (row=0; row<MAX_ROWS; row++) {
    for (col=0; col<MAX_COLS; col++) {
      print_char(' ', col, row, WHITE_ON_BLACK);
    }
  }
  set_cursor(get_screen_offset(0 , 0));
}


