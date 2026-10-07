#include "../../hal/include/hal.h"

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
    printf("[DBUS] [%s] %s\n", tag, message);
}

int main(void) {
    int server_fd = -1;
    int client_fd = -1;
    struct sockaddr_in server_addr;
    struct sockaddr_in client_addr;
    socklen_t client_len = sizeof(client_addr);
    char buffer[BUFFER_SIZE];

    hal_init();

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd < 0) {
        perror("socket");
        return 1;
    }

    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(SERVER_PORT);

    if (bind(server_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("bind");
        close(server_fd);
        return 1;
    }

    if (listen(server_fd, 5) < 0) {
        perror("listen");
        close(server_fd);
        return 1;
    }

    log_message("SERVICE", "ABINSTEIN D-Bus service listening on port 9000");

    while (1) {
        client_fd = accept(server_fd, (struct sockaddr *)&client_addr, &client_len);
        if (client_fd < 0) {
            perror("accept");
            continue;
        }

        memset(buffer, 0, sizeof(buffer));
        ssize_t received = recv(client_fd, buffer, sizeof(buffer) - 1, 0);
        if (received > 0) {
            buffer[received] = '\0';
            log_message("REQUEST", buffer);

            if (strncmp(buffer, "status", 6) == 0) {
                const hal_display_info_t display = hal_get_display();
                const hal_power_info_t power = hal_get_power();
                snprintf(buffer, sizeof(buffer),
                         "display=%dx%d brightness=%d state=%d power=%d battery=%d charging=%d",
                         display.width, display.height, display.brightness,
                         (int)display.state, (int)power.state,
                         power.battery_percent, power.is_charging);
            } else if (strncmp(buffer, "power_on", 8) == 0) {
                hal_set_power_state(HAL_POWER_ON);
                snprintf(buffer, sizeof(buffer), "power=on");
            } else if (strncmp(buffer, "power_off", 9) == 0) {
                hal_set_power_state(HAL_POWER_OFF);
                snprintf(buffer, sizeof(buffer), "power=off");
            } else if (strncmp(buffer, "display_on", 10) == 0) {
                hal_set_display_state(HAL_DISPLAY_ON);
                snprintf(buffer, sizeof(buffer), "display=on");
            } else if (strncmp(buffer, "display_off", 11) == 0) {
                hal_set_display_state(HAL_DISPLAY_OFF);
                snprintf(buffer, sizeof(buffer), "display=off");
            } else {
                snprintf(buffer, sizeof(buffer), "unknown_command");
            }

            send(client_fd, buffer, strlen(buffer), 0);
        }

        close(client_fd);
        client_fd = -1;
    }

    close(server_fd);
    return 0;
}
