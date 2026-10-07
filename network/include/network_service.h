#ifndef ABINSTEIN_NETWORK_SERVICE_H
#define ABINSTEIN_NETWORK_SERVICE_H

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    NETWORK_STATE_DISCONNECTED = 0,
    NETWORK_STATE_CONNECTING = 1,
    NETWORK_STATE_CONNECTED = 2,
    NETWORK_STATE_ERROR = 3
} network_state_t;

typedef struct {
    network_state_t state;
    int signal_strength;
    int is_wifi;
    char ssid[64];
} network_service_state_t;

void network_service_init(network_service_state_t *state);
int network_service_connect(network_service_state_t *state, const char *ssid);
void network_service_disconnect(network_service_state_t *state);
const char *network_service_state_name(network_state_t state);

#ifdef __cplusplus
}
#endif

#endif
