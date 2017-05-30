#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>

void print_msg(char *msg) {
  char buf[256];
  strcpy(buf, msg);
  printf("Network Message Recvd: %s\n", buf);
}

int main(int argc, char *argv[]) {
  char network_buffer[4096];
  int length;
  int sock;
  struct sockaddr_in server_sa;
  struct sockaddr_in client_sa;
  socklen_t socksize = sizeof(struct sockaddr_in);

  memset(&server_sa, 0, sizeof(server_sa));
  server_sa.sin_family = AF_INET;
  server_sa.sin_addr.s_addr = htonl(INADDR_ANY);
  server_sa.sin_port = htons(31337);

  sock = socket(AF_INET, SOCK_STREAM, 0);

  bind(sock, (struct sockaddr *)&server_sa, sizeof(struct sockaddr));

  listen(sock, 1);
  int connection = accept(sock, (struct sockaddr *)&client_sa, &socksize);

  send(connection, "Enter your message: ", 20, 0);
  length = recv(connection, network_buffer, 4095, 0);
  network_buffer[length] = '\0';
  close(connection);
  close(sock);

  print_msg(network_buffer);

  return 0;
}
