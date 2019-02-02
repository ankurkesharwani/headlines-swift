#ifndef SHIM_CURL_H
#define SHIM_CURL_H

typedef enum font_color {
    FG_BLACK,
    FG_RED,
    FG_GREEN,
    FG_YELLOW,
    FG_BLUE,
    FG_MAGENTA,
    FG_CYAN,
    FG_WHITE,
    FG_BOLD_BLACK,
    FG_BOLD_RED,
    FG_BOLD_GREEN,
    FG_BOLD_YELLOW,
    FG_BOLD_BLUE,
    FG_BOLD_MAGENTA,
    FG_BOLD_CYAN,
    FG_BOLD_WHITE
} FontColor;

void console_print(int font_color, char *string);
void console_println(int font_color, char *string);

#endif /* SHIM_CURL_H */
