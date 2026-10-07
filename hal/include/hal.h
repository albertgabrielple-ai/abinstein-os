#ifndef ABINSTEIN_HAL_H
#define ABINSTEIN_HAL_H

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    HAL_DISPLAY_OFF = 0,
    HAL_DISPLAY_ON = 1,
    HAL_DISPLAY_SUSPEND = 2
} hal_display_state_t;

typedef enum {
    HAL_POWER_OFF = 0,
    HAL_POWER_ON = 1,
    HAL_POWER_SUSPEND = 2,
    HAL_POWER_REBOOT = 3
} hal_power_state_t;

typedef struct {
    int width;
    int height;
    int refresh_rate;
    int brightness;
    hal_display_state_t state;
} hal_display_info_t;

typedef struct {
    hal_power_state_t state;
    int battery_percent;
    int is_charging;
} hal_power_info_t;

void hal_init(void);
void hal_set_display_state(hal_display_state_t state);
void hal_set_brightness(int percent);
void hal_set_power_state(hal_power_state_t state);

hal_display_info_t hal_get_display(void);
hal_power_info_t hal_get_power(void);

#ifdef __cplusplus
}
#endif

#endif
