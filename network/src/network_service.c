#include "network_service.h"

#include <stdio.h>
#include <string.h>

void network_service_init(network_service_state_t *state) {
    if (state == NULL) {
        return;
    }

    memset(state, 0, sizeof(*state));
    state->state = NETWORK_STATE_DISCONNECTED;
    state->signal_strength = 0;
    state->is_wifi = 1;
    snprintf(state->ssid, sizeof(state->ssid), "abinstein-wifi");
    printf("[NETWORK] Network service initialized\n");
}

int network_service_connect(network_service_state_t *state, const char *ssid) {
    if (state == NULL) {
        return -1;
    }

    state->state = NETWORK_STATE_CONNECTING;
    printf("[NETWORK] Connecting to %s\n", ssid ? ssid : state->ssid);

    if (ssid != NULL) {
        snprintf(state->ssid, sizeof(state->ssid), "%s", ssid);
    }

    state->signal_strength = 75;
    state->state = NETWORK_STATE_CONNECTED;
    printf("[NETWORK] Connected to %s with signal %d\n", state->ssid, state->signal_strength);
    return 0;
}

void network_service_disconnect(network_service_state_t *state) {
    if (state == NULL) {
        return;
    }

    state->state = NETWORK_STATE_DISCONNECTED;
    state->signal_strength = 0;
    printf("[NETWORK] Disconnected from network\n");
}

const char *network_service_state_name(network_state_t state) {
    switch (state) {
        case NETWORK_STATE_DISCONNECTED: return "DISCONNECTED";
        case NETWORK_STATE_CONNECTING: return "CONNECTING";
        case NETWORK_STATE_CONNECTED: return "CONNECTED";
        case NETWORK_STATE_ERROR: return "ERROR";
        default: return "UNKNOWN";
    }
}
