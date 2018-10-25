#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <string.h>

int *color(int array[], int size, int segment)
{
  int *new_array = malloc(sizeof(int) * size);

  switch(segment){

    case 0: 
      array[0] = 80;
      array[1] = array[2] = 0;
      break;
    case 1:
      array[0] = array[1] = 0;
      array[2] = 80;
      break;
    case 2:    
      array[0] = array[1] = array[2] = 80;
      break;
    case 3:
      array[0] = array[2] = 0;
      array[1] = 80;
      break;    
    }
  for(int i=0; i < size; i++){
    new_array[i] = array[i];
  }
 return new_array;
}

int brightness(int time){
  int b_out;
    if(time>5 && time<22){
      b_out = 128;
    } else {
      b_out = 40;}
 return b_out;      
}

int *unih_ary(int array2[], int size2, int segment_a )
{ 
  int *new_array2 = malloc(sizeof(int) * size2);

  int strip_map_a[16] = {7,6,5,4,8,9,10,11,23,22,21,20,24,25,26,27};
  int strip_map_b[16] = {3,2,1,0,12,13,14,15,19,18,17,16,28,29,30,31};
  int strip_map_c[16] = {39,38,37,36,40,41,42,43,55,54,53,52,56,57,58,59};
  int strip_map_d[16] = {35,34,33,32,44,45,46,47,51,50,49,48,60,61,62,63};
  int *seg_a, *seg_b, *seg_c, *seg_d;
  seg_a = strip_map_a;
  seg_b = strip_map_b;
  seg_c = strip_map_c;
  seg_d = strip_map_d;

  switch(segment_a){

    case 0: 
      for(int i = 0; i < 16; i++){
        array2[i] = *(seg_a + i);
      } break;
    case 1: 
      for(int i = 0; i < 16; i++){
        array2[i] = *(seg_b + i);
    } break;
    case 2: 
      for(int i = 0; i < 16; i++){
        array2[i] = *(seg_c + i);
    } break;
    case 3: 
      for(int i = 0; i < 16; i++){
        array2[i] = *(seg_d + i);
      } break;}
  new_array2 = array2;
 return new_array2;
}

int digit(int n, int k){
    while(n--)
        k/=10;
    return k%10;
}

int *time_now(int array3[], int size3, char sel[], int ss_h, int ss_m, int sr_h, int sr_m){
  char buff_h[10], buff_m[10]; 
  time_t now = time (0);
  int *new_array3 = malloc(sizeof(int) * size3);
  if (strcmp(sel,"date") == 0){ 
      strftime (buff_h, 100, "%d", localtime (&now));
      strftime (buff_m, 100, "%m", localtime (&now));
      array3[0] = digit(1, atoi(buff_h));
      array3[1] = digit(0, atoi(buff_h));
      array3[2] = digit(1, atoi(buff_m));
      array3[3] = digit(0, atoi(buff_m));

   } else if ( strcmp(sel,"time" ) == 0)  {
      strftime (buff_h, 100, "%H", localtime (&now));
      strftime (buff_m, 100, "%M", localtime (&now));
      array3[0] = digit(1, atoi(buff_h));
      array3[1] = digit(0, atoi(buff_h));
      array3[2] = digit(1, atoi(buff_m));
      array3[3] = digit(0, atoi(buff_m));

  } else if (strcmp(sel, "sun_rise") == 0 ) {
      array3[0] = digit(1, ss_h);
      array3[1] = digit(0, ss_h);
      array3[2] = digit(1, ss_m);
      array3[3] = digit(0, ss_m);
  } else if (strcmp(sel,"sun_set") == 0) {
      array3[0] = digit(1, sr_h);
      array3[1] = digit(0, sr_h);
      array3[2] = digit(1, sr_m);
      array3[3] = digit(0, sr_m);
  }
  new_array3 = array3;
 return new_array3;
}

int *div_grid_time(int array4[], int size4, int value){

  int *new_array4 = malloc(sizeof(int) * size4);
  int  out[4], div_i[3] = {4,2,1};

  out[0] = (value/8) % 8;
  out[1] = (value % 8) / div_i[0];
  out[2] = ((value % 8) % div_i[0]) / div_i[1];
  out[3] = (((value % 8) % div_i[0]) % div_i[1]) / div_i[2];

  for(int i = 0; i < 4; i++){
    new_array4[i] = out[i];
  }
 return new_array4;
}

