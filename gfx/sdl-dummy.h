/* sdl-dummy.h for dummied-up SDL types */
#include <inttypes.h>
typedef uint8_t         Uint8;
typedef uint16_t        Uint16;
typedef uint32_t        Uint32;
typedef int32_t         Sint32;

typedef union event     SDL_Event;
typedef struct keysym   SDL_Keysym;
typedef Sint32          SDL_Keycode;
enum scancode {
    SDL_SCANCODE_UNKNOWN = 0,
};
typedef enum scancode   SDL_Scancode;

enum eventtype {
    SDL_QUIT           = 0x100, /**< User-requested quit */
    SDL_WINDOWEVENT    = 0x200, /**< Window state change */
    SDL_KEYDOWN        = 0x300, /**< Key pressed */
    SDL_KEYUP,                  /**< Key released */
    SDL_MOUSEMOTION    = 0x400, /**< Mouse moved */
    SDL_MOUSEBUTTONDOWN,        /**< Mouse button pressed */
    SDL_MOUSEBUTTONUP,          /**< Mouse button released */
    SDL_MOUSEWHEEL,             /**< Mouse wheel motion */
};

struct quitevent {
    Uint32 type;        /**< ::SDL_QUIT */
    Uint32 timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
};

struct windowevent {
    Uint32 type;        /**< ::SDL_WINDOWEVENT */
    Uint32 timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    Uint32 windowID;    /**< The associated window */
    Uint8 event;        /**< ::SDL_WindowEventID */
    Uint8 padding1;
    Uint8 padding2;
    Uint8 padding3;
    Sint32 data1;       /**< event dependent data */
    Sint32 data2;       /**< event dependent data */
};

struct keysym {
    enum scancode scancode; /**< SDL physical key code - see ::SDL_Scancode for details */
    SDL_Keycode sym;        /**< SDL virtual key code - see ::SDL_Keycode for details */
    Uint16 mod;             /**< current key modifiers */
    Uint32 unused;
};

struct keyboardevent {
    Uint32 type;        /**< ::SDL_KEYDOWN or ::SDL_KEYUP */
    Uint32 timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    Uint32 windowID;    /**< The window with keyboard focus, if any */
    Uint8 state;        /**< ::SDL_PRESSED or ::SDL_RELEASED */
    Uint8 repeat;       /**< Non-zero if this is a key repeat */
    Uint8 padding2;
    Uint8 padding3;
    struct keysym keysym; /**< The key that was pressed or released */
};

struct mousemotionevent {
    Uint32 type;        /**< ::SDL_MOUSEMOTION */
    Uint32 timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    Uint32 windowID;    /**< The window with mouse focus, if any */
    Uint32 which;       /**< The mouse instance id, or SDL_TOUCH_MOUSEID */
    Uint32 state;       /**< The current button state */
    Sint32 x;           /**< X coordinate, relative to window */
    Sint32 y;           /**< Y coordinate, relative to window */
    Sint32 xrel;        /**< The relative motion in the X direction */
    Sint32 yrel;        /**< The relative motion in the Y direction */
};

#define SDL_BUTTON_LEFT     1
#define SDL_BUTTON_MIDDLE   2
#define SDL_BUTTON_RIGHT    3

/* General keyboard/mouse state definitions */
#define SDL_RELEASED    0
#define SDL_PRESSED     1

struct mousebuttonevent {
    Uint32 type;        /**< ::SDL_MOUSEBUTTONDOWN or ::SDL_MOUSEBUTTONUP */
    Uint32 timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    Uint32 windowID;    /**< The window with mouse focus, if any */
    Uint32 which;       /**< The mouse instance id, or SDL_TOUCH_MOUSEID */
    Uint8 button;       /**< The mouse button index */
    Uint8 state;        /**< ::SDL_PRESSED or ::SDL_RELEASED */
    Uint8 clicks;       /**< 1 for single-click, 2 for double-click, etc. */
    Uint8 padding1;
    Sint32 x;           /**< X coordinate, relative to window */
    Sint32 y;           /**< Y coordinate, relative to window */
};

struct mousewheelevent {
    Uint32 type;        /**< ::SDL_MOUSEWHEEL */
    Uint32 timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    Uint32 windowID;    /**< The window with mouse focus, if any */
    Uint32 which;       /**< The mouse instance id, or SDL_TOUCH_MOUSEID */
    Sint32 x;           /**< The amount scrolled horizontally, positive to the right and negative to the left */
    Sint32 y;           /**< The amount scrolled vertically, positive away from the user and negative toward the user */
    Uint32 direction;   /**< Set to one of the SDL_MOUSEWHEEL_* defines. When FLIPPED the values in X and Y will be opposite. Multiply by -1 to change them back */
};

union event {
    Uint32 type;                        /**< Event type, shared with all events */
    struct windowevent window;          /**< Window event data */
    struct keyboardevent key;           /**< Keyboard event data */
    struct mousemotionevent motion;     /**< Mouse motion event data */
    struct mousebuttonevent button;     /**< Mouse button event data */
    struct mousewheelevent wheel;       /**< Mouse wheel event data */
    struct quitevent quit;              /**< Quit request event data */
    Uint8 padding[56];
};