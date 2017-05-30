#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
  char name[32];

  if (2 != argc) {
    printf("Usage: %s <your_name>\n", argv[0]);
    return 1;
  }

  strcpy(name, argv[1]);
  printf("Hello, %s\n", name);

  return 0;
}
