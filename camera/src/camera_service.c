#include "camera_service.h"

#include <stdio.h>

void camera_service_init(camera_service_state_t *state) {
    if (state == NULL) {
        return;
    }
    state->state = CAMERA_STATE_OFF;
    state->width = 1280;
    state->height = 720;
    state->fps = 30;
    printf("[CAMERA] Camera service initialized\n");
}

int camera_service_start_preview(camera_service_state_t *state, int width, int height, int fps) {
    if (state == NULL) {
        return -1;
    }
    state->width = width > 0 ? width : 1280;
    state->height = height > 0 ? height : 720;
    state->fps = fps > 0 ? fps : 30;
    state->state = CAMERA_STATE_PREVIEW;
    printf("[CAMERA] Preview started at %dx%d @ %d fps\n", state->width, state->height, state->fps);
    return 0;
}

void camera_service_stop_preview(camera_service_state_t *state) {
    if (state == NULL) {
        return;
    }
    state->state = CAMERA_STATE_OFF;
    printf("[CAMERA] Preview stopped\n");
}
