
// NOTE ON ROW #s
// Since row 12 is the top, followed by 11 and 0, that makes
// the math really confusing. Instead, below converts 12 -> 0,
// 11 -> 1, and 0 -> 2 followed by 3 (formerly 1), etc.

void encodePunch(char symbol, int column) {
  symbol =    Character.toUpperCase(symbol);
  int zone =  -1;
  int row1 =  -1;
  int row2 =  -1;
  int c =     int(symbol);
  
  // 0-9
  if (c >= 48 && c <= 57) {
    row1 = c - 48;
  }
  
  // A-I
  else if (c >= 65 && c <= 73) {
    zone = 12;
    row1 = 1 + c - 65;
  }
  
  // J-R
  else if (c >= 74 && c <= 82) {
    zone = 11;
    row1 = 1 + c - 74;
  }
  
  // S-Z
  else if (c >= 83 && c <= 90) {
    zone = 0;
    row1 = 2 + c - 83;
  }
  
  // symbols
  else {
    switch (c) {
      case 43: zone = 12; row1 = -1; row2 = -1; break;  // +
      case 45: zone = 11; row1 = -1; row2 = -1; break;  // -
      
      case 47: zone = 0;  row1 = 1;  row2 = -1; break;  // /
      
      case 61: zone = -1; row1 = 2;  row2 = 8;  break;  // =
      case 39: zone = -1; row1 = 3;  row2 = 8;  break;  // '
      
      case 46: zone = 12; row1 = 3;  row2 = 8;  break;  // .
      case 41: zone = 12; row1 = 4;  row2 = 8;  break;  // )
      
      case 36: zone = 11; row1 = 3;  row2 = 8;  break;  // $
      case 42: zone = 11; row1 = 4;  row2 = 8;  break;  // *
      
      case 44: zone = 0;  row1 = 3;  row2 = 8;  break;  // ,
      case 40: zone = 0;  row1 = 4;  row2 = 8;  break;  // (
      
      case 59: zone = 11; row1 = 6;  row2 = 8;  break;  // ;
      
      // note: semicolon borrowed from a later system
      
      case 32: break;                                   // space = blank
      
      // non-usable character
      default: println("  Character \"" + symbol + "\" is cannot be encoded.\n  What did you expect, this technology is from 1949!"); return; 
    }
  }
  
  // convert into onscreen rows
  if (zone == 12) zone = 0;
  else if (zone == 11) zone = 1;
  else if (zone >= 0) zone += 2;
  
  if (row1 >= 0) row1 += 2;
  if (row2 >= 0) row2 += 2;
  
  // draw punches
  float x = rightMargin + (column * colWidth);
  float y = 0;
  
  if (zone >= 0) {
    y = topMargin + (zone * rowHeight);
    rect(x,y, punchWidth, punchHeight);
  }
  if (row1 >= 0) {
    y = topMargin + (row1 * rowHeight);
    rect(x,y, punchWidth, punchHeight);
  }
  if (row2 >= 0) {
    y = topMargin + (row1 * rowHeight);
    rect(x,y, punchWidth, punchHeight);
  }

}




