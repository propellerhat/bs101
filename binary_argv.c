#include <stdio.h>

int main(int argc, char *argv[]) {
  if (2 != argc) {
    printf("Usage: %s <key>\n", argv[0]);
    return 1;
  }

  if (0xbadc0de == *(int *)argv[1]) {
    if (2147475906 == *(int *)(argv[1] + 5)) {
      if (-2 == *(int *)(argv[1] + 13)) {
        printf("You win :P\n");
        return 0;
      }
    }
  }
  
  printf("Sorry, '%s' is not the correct key :(\n", argv[1]);
  
  return 1;
}
