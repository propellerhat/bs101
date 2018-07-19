#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <limits.h>
#define EXIT_EXISTENTIAL_CRISIS 42

int
main (int argc, char *argv[])
{
  int negative_number = INT_MIN;
  int positive_number = -negative_number;

  if (positive_number > negative_number)
    {
      printf ("All is right with the computing world!\n");
      exit (EXIT_SUCCESS);
    }
  else if (negative_number > positive_number)
    {
      printf ("Wait a hot second...\n");
      exit (EXIT_FAILURE);
    }
  else
    {
      printf ("At least we know this case will never happen.\n");
      exit (EXIT_EXISTENTIAL_CRISIS);
    }
}

