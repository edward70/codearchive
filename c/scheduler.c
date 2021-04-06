#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void writefile(char str[]);

int main(int argc, char *argv[]) 
{
  if (argc == 3)
  {
    if (strcmp("add", argv[1]) == 0)
    {
      writefile(argv[2]);
      printf("Operation successful.\n");
    }
  }
  else if (argc == 2)
  {
    printf("2 arguments\n");
  }
  else
  {
    printf("usage: %s arg1 arg2\n", argv[0]);
  }
  return 0;
}

void writefile(char str[])
{
  FILE *f = fopen("data.txt", "a");
  if (f == NULL)
  {
    printf("Error opening file!\n");
    exit(1);
  }
  fprintf(f, "- %s\n", str);
  fclose(f);
}
