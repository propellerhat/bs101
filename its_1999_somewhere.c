#include <stdio.h>
#include <string.h>

void greet_user(char *arg1) {
  char name[64];
  strcpy(name, arg1);
  printf("Hello, %s\n", name);
}

int main(int argc, char *argv[]) {
  if (2 != argc) {
    printf("Usage: %s <your_name>\n", argv[0]);
    return 1;
  }
  greet_user(argv[1]);
  return 1;
}
