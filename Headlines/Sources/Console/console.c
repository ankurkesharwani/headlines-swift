#include <console.h>
#include <stdio.h>
#include <unistd.h>

//end color

#define F_BLACK_TEXT            "\033[0;30m"
#define F_RED_TEXT              "\033[0;31m"
#define F_GREEN_TEXT            "\033[0;32m"
#define F_YELLOW_TEXT           "\033[0;33m"
#define F_BLUE_TEXT             "\033[0;34m"
#define F_MAGENTA_TEXT          "\033[0;35m"
#define F_CYAN_TEXT             "\033[0;36m"
#define F_WHITE_TEXT            "\033[0;37m"

#define F_BOLD_BLACK_TEXT       "\033[1;30m"
#define F_BOLD_RED_TEXT         "\033[1;31m"
#define F_BOLD_GREEN_TEXT       "\033[1:32m"
#define F_BOLD_YELLOW_TEXT      "\033[1;33m"
#define F_BOLD_BLUE_TEXT        "\033[1;34m"
#define F_BOLD_MAGENTA_TEXT     "\033[1;35m"
#define F_BOLD_CYAN_TEXT        "\033[1;36m"
#define F_BOLD_WHITE_TEXT       "\033[1;37m"

#define NONE                    "\033[0m"

char *font_colors[] = {
    F_BLACK_TEXT,
    F_RED_TEXT,
    F_GREEN_TEXT,
    F_YELLOW_TEXT,
    F_BLUE_TEXT,
    F_MAGENTA_TEXT,
    F_CYAN_TEXT,
    F_WHITE_TEXT,
    F_BOLD_BLACK_TEXT,
    F_BOLD_RED_TEXT,
    F_BOLD_GREEN_TEXT,
    F_BOLD_YELLOW_TEXT,
    F_BOLD_BLUE_TEXT,
    F_BOLD_MAGENTA_TEXT,
    F_BOLD_CYAN_TEXT,
    F_BOLD_WHITE_TEXT
};

void console_print(int font_color, char *string) {
    printf("%s%s%s", font_colors[font_color], string, NONE);
}

void console_println(int font_color, char *string) {
    printf("%s%s%s\n", font_colors[font_color], string, NONE);
}
