#ifndef ABINSTEIN_AUDIO_SERVICE_H
#define ABINSTEIN_AUDIO_SERVICE_H

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    AUDIO_STATE_STOPPED = 0,
    AUDIO_STATE_PLAYING = 1,
    AUDIO_STATE_PAUSED = 2,
    AUDIO_STATE_MUTED = 3
} audio_state_t;

typedef struct {
    audio_state_t state;
    int volume;
} audio_service_state_t;

void audio_service_init(audio_service_state_t *state);
void audio_service_play(audio_service_state_t *state);
void audio_service_pause(audio_service_state_t *state);
void audio_service_set_volume(audio_service_state_t *state, int volume);
int audio_service_get_volume(const audio_service_state_t *state);

#ifdef __cplusplus
}
#endif

#endif
