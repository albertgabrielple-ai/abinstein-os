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
    printf("[DBUS-SERVER] [%s] %s\n", tag, message);
}

int main(void) {
    int fd = -1;
    int client_fd = -1;
    struct sockaddr_in address;
    struct sockaddr_in client_address;
    socklen_t client_len = sizeof(client_address);
    char buffer[BUFFER_SIZE];

    fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) {
        perror("socket");
        return 1;
    }

    memset(&address, 0, sizeof(address));
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(SERVER_PORT);

    if (bind(fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("bind");
        close(fd);
        return 1;
    }

    if (listen(fd, 5) < 0) {
        perror("listen");
        close(fd);
        return 1;
    }

    log_message("SERVER", "Socket IPC server ready on port 9000");

    while (1) {
        client_fd = accept(fd, (struct sockaddr *)&client_address, &client_len);
        if (client_fd < 0) {
            perror("accept");
            continue;
        }

        memset(buffer, 0, sizeof(buffer));
        ssize_t len = recv(client_fd, buffer, sizeof(buffer) - 1, 0);
        if (len > 0) {
            buffer[len] = '\0';
            log_message("CLIENT", buffer);
            snprintf(buffer, sizeof(buffer), "ABINSTEIN-IPC-OK:%s", buffer);
            send(client_fd, buffer, strlen(buffer), 0);
        }

        close(client_fd);
    }

    close(fd);
    return 0;
}
