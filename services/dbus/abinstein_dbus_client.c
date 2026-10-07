#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#define SERVER_PORT 9000
#define BUFFER_SIZE 1024

static void log_message(const char *tag, const char *message) {
    printf("[DBUS-CLIENT] [%s] %s\n", tag, message);
}

int main(int argc, char **argv) {
    int fd = -1;
    struct sockaddr_in server_addr;
    char buffer[BUFFER_SIZE];
    const char *request = argc > 1 ? argv[1] : "status";

    fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) {
        perror("socket");
        return 1;
    }

    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(SERVER_PORT);
    server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");

    if (connect(fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("connect");
        close(fd);
        return 1;
    }

    snprintf(buffer, sizeof(buffer), "%s", request);
    send(fd, buffer, strlen(buffer), 0);

    memset(buffer, 0, sizeof(buffer));
    ssize_t len = recv(fd, buffer, sizeof(buffer) - 1, 0);
    if (len > 0) {
        buffer[len] = '\0';
        log_message("RESPONSE", buffer);
    }

    close(fd);
    return 0;
}
