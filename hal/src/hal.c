#include "hal.h"

#include <stdio.h>

static hal_display_info_t g_display = {
    .width = 720,
    .height = 1520,
    .refresh_rate = 60,
    .brightness = 80,
    .state = HAL_DISPLAY_ON
};

static hal_power_info_t g_power = {
    .state = HAL_POWER_ON,
    .battery_percent = 100,
    .is_charging = 1
};

void hal_init(void) {
    printf("[HAL] Initializing display and power subsystem\n");
    g_display.state = HAL_DISPLAY_ON;
    g_power.state = HAL_POWER_ON;
}

void hal_set_display_state(hal_display_state_t state) {
    g_display.state = state;
    printf("[HAL] Display state set to %d\n", (int)state);
}

void hal_set_brightness(int percent) {
    if (percent < 0) {
        g_display.brightness = 0;
    } else if (percent > 100) {
        g_display.brightness = 100;
    } else {
        g_display.brightness = percent;
    }
    printf("[HAL] Brightness set to %d%%\n", g_display.brightness);
}

void hal_set_power_state(hal_power_state_t state) {
    g_power.state = state;
    printf("[HAL] Power state set to %d\n", (int)state);
}

hal_display_info_t hal_get_display(void) {
    return g_display;
}

hal_power_info_t hal_get_power(void) {
    return g_power;
}
