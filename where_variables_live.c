#include <stdio.h>
#include <stdlib.h>

char global_variable[10];
char *global_initialized_variable = "lel";

int add_function(int a, int b) {
  return a + b;
}

int main(int argc, char *argv[]) {
  int stack_variable = 0;
  int stack_array[64];
  void *heap_variable = malloc(100);

  printf("Address of stack_variable: %p\n", &stack_variable);
  printf("Address of heap_variable: %p\n", heap_variable);
  printf("Address of global_variable: %p\n", global_variable);
  printf("Address of global_initialized_variable: %p\n", global_initialized_variable);
  printf("Address of add_function(): %p\n", &add_function);
  printf("Address of main(): %p\n", main);

  return 0;
}
