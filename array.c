#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
  char a [32];
  char b [32];
  
  a[0] = 'h';
  a[1] = 'e';
  a[2] = a[3] = 'l';
  a[4] = 'o';
  a[5] = '\0';

  b[0] = 'A';
  b[1] = 'A';
  b[2] = 'A';
  b[3] = 'A';
  b[4] = 0;

  printf("%s\n", a);
  printf("%s\n", (a+1));
  printf("%s\n", (a+2));
  printf("%s\n", &a[1]);

  printf("%c\n", *(a+2));
  printf("%c\n", a[0]);

  printf("%s\n", &b[32]);

  strcpy(a, "byebye");
  printf("%s\n", a);
  return 0;
}
