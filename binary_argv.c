#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
  if (2 != argc) {
    printf("Usage: %s <key>\n", argv[0]);
    return 1;
  }
  if (0 == strcmp(argv[1], "\xba\xdc\x0d\xe1")) {
    printf("You win :P\n");
    return 0;
  }
  printf("Sorry, '%s' is not the correct key :(\n", argv[1]);
  return 1;
}
