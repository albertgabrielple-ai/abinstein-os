#include "audio_service.h"

#include <stdio.h>

void audio_service_init(audio_service_state_t *state) {
    if (state == NULL) {
        return;
    }
    state->state = AUDIO_STATE_STOPPED;
    state->volume = 60;
    printf("[AUDIO] Audio service initialized\n");
}

void audio_service_play(audio_service_state_t *state) {
    if (state == NULL) {
        return;
    }
    state->state = AUDIO_STATE_PLAYING;
    printf("[AUDIO] Audio playback started\n");
}

void audio_service_pause(audio_service_state_t *state) {
    if (state == NULL) {
        return;
    }
    state->state = AUDIO_STATE_PAUSED;
    printf("[AUDIO] Audio playback paused\n");
}

void audio_service_set_volume(audio_service_state_t *state, int volume) {
    if (state == NULL) {
        return;
    }
    if (volume < 0) {
        state->volume = 0;
    } else if (volume > 100) {
        state->volume = 100;
    } else {
        state->volume = volume;
    }
    printf("[AUDIO] Volume set to %d\n", state->volume);
}

int audio_service_get_volume(const audio_service_state_t *state) {
    if (state == NULL) {
        return 0;
    }
    return state->volume;
}
