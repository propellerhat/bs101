int func(int arg1, int arg2, int arg3, int arg4) {
  int function_local = 5;
  return arg1 + arg2 + arg3 + arg4 + function_local;
}

int main(int argc, char *argv[]) {
  int result = func(1, 2, 3, 4);
  return 0;
}
