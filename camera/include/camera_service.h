#ifndef ABINSTEIN_CAMERA_SERVICE_H
#define ABINSTEIN_CAMERA_SERVICE_H

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    CAMERA_STATE_OFF = 0,
    CAMERA_STATE_PREVIEW = 1,
    CAMERA_STATE_RECORDING = 2,
    CAMERA_STATE_ERROR = 3
} camera_state_t;

typedef struct {
    camera_state_t state;
    int width;
    int height;
    int fps;
} camera_service_state_t;

void camera_service_init(camera_service_state_t *state);
int camera_service_start_preview(camera_service_state_t *state, int width, int height, int fps);
void camera_service_stop_preview(camera_service_state_t *state);

#ifdef __cplusplus
}
#endif

#endif
