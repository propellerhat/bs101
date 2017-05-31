#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void unused_developer_backdoor() {
  printf("Super-secret developer backdoor. Use with caution!\n");
  system("/bin/sh -i");
  exit (EXIT_SUCCESS);
}

void greet_user() {
  char name[64];
  printf("Enter your name: ");
  scanf("%s", name);
  printf("Hello, %s\n", name);
}

int main(int argc, char *argv[]) {
  greet_user();

  return 1;
}
