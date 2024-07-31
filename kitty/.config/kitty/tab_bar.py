#!/usr/bin/env python

# NOTE: This file is used to draw the tab bar in kitty.
# See [this discussion](https://github.com/kovidgoyal/kitty/discussions/4447) for examples from kitty users.

import datetime
import socket
from dataclasses import dataclass
from typing import List, Literal
from kitty.utils import color_as_int
from kitty.fast_data_types import Screen, get_options
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    as_rgb,
    draw_tab_with_fade,
    draw_tab_with_slant,
    draw_tab_with_powerline,
    draw_tab_with_separator,
)

# Kitty built-in tab styles
TabStyle = Literal["fade", "slant", "powerline", "separator"]

TAB_STYLE: TabStyle = "powerline"


# Translate the kitty colors to rgb.
# Colors are defined in current-theme.conf.
# Get them with `get_options().colorX`.
def color_as_rgb(color):
    return as_rgb(color_as_int(color))


# Translate the hex color to rgb.
# hex is formatted as #RRGGBB.
def hex_as_rgb(hex: str):
    return as_rgb(int(hex[1:], 16))


opts = get_options()

# Colors
BLACK_NORMAL = color_as_rgb(opts.color0)
RED_NORMAL = color_as_rgb(opts.color1)
GREEN_NORMAL = color_as_rgb(opts.color2)
YELLOW_NORMAL = color_as_rgb(opts.color3)
BLUE_NORMAL = color_as_rgb(opts.color4)
MAGENTA_NORMAL = color_as_rgb(opts.color5)
CYAN_NORMAL = color_as_rgb(opts.color6)
WHITE_NORMAL = color_as_rgb(opts.color7)
BLACK_BRIGHT = color_as_rgb(opts.color8)
RED_BRIGHT = color_as_rgb(opts.color9)
GREEN_BRIGHT = color_as_rgb(opts.color10)
YELLOW_BRIGHT = color_as_rgb(opts.color11)
BLUE_BRIGHT = color_as_rgb(opts.color12)
MAGENTA_BRIGHT = color_as_rgb(opts.color13)
CYAN_BRIGHT = color_as_rgb(opts.color14)
WHITE_BRIGHT = color_as_rgb(opts.color15)


@dataclass
class ComponentOptions:
    fg: int
    bg: int
    bold: bool = False
    italic: bool = False


@dataclass
class Component:
    content: str
    options: ComponentOptions

    def __len__(self):
        return len(self.content)


# Draw the right status
def draw_right_status(screen: Screen, is_last: bool) -> int:
    if not is_last:
        return screen.cursor.x

    # Icons
    HOST_ICON = " 󰋜 "
    DATE_ICON = "  "
    CLOCK_ICON = "  "
    COMPONENT_SEPARATOR_ICON = ""
    SECTION_SEPARATOR_ICON = ""

    # Colors
    TAB_BAR_BG = hex_as_rgb("#1e1e2e")
    RIGHT_STATUS_FG = BLUE_NORMAL
    RIGHT_STATUS_BG = BLACK_BRIGHT
    CLOCK_FG = BLACK_NORMAL
    CLOCK_BG = BLUE_NORMAL

    # Contents
    hostname = socket.gethostname()
    date = datetime.datetime.now().strftime("%Y/%m/%d")
    clock = datetime.datetime.now().strftime("%H:%M")

    # Right status colors
    status_separator = Component(
        SECTION_SEPARATOR_ICON, ComponentOptions(RIGHT_STATUS_BG, TAB_BAR_BG)
    )
    section_separator = Component(
        SECTION_SEPARATOR_ICON, ComponentOptions(RIGHT_STATUS_FG, RIGHT_STATUS_BG)
    )
    component_separator = Component(
        COMPONENT_SEPARATOR_ICON, ComponentOptions(RIGHT_STATUS_FG, RIGHT_STATUS_BG)
    )
    host_component = Component(
        HOST_ICON + hostname + " ", ComponentOptions(RIGHT_STATUS_FG, RIGHT_STATUS_BG)
    )
    date_component = Component(
        DATE_ICON + date + " ", ComponentOptions(RIGHT_STATUS_FG, RIGHT_STATUS_BG)
    )
    clock_component = Component(
        CLOCK_ICON + clock + " ", ComponentOptions(CLOCK_FG, CLOCK_BG, True)
    )

    components: List[Component] = [
        status_separator,
        host_component,
        component_separator,
        date_component,
        section_separator,
        clock_component,
    ]

    # Draw the spaces between the left status and right status
    right_status_length = 0
    for component in components:
        right_status_length += len(component.content)
    draw_spaces = screen.columns - screen.cursor.x - right_status_length
    if draw_spaces > 0:
        screen.draw(" " * draw_spaces)

    # Draw right status components
    for component in components:
        screen.cursor.fg = component.options.fg
        screen.cursor.bg = component.options.bg
        screen.cursor.bold = component.options.bold
        screen.cursor.italic = component.options.italic
        screen.draw(component.content)

    # Reset the cursor style
    screen.cursor.fg = 0
    screen.cursor.bg = 0
    screen.cursor.bold = False
    screen.cursor.italic = False

    screen.cursor.x = max(screen.cursor.x, screen.columns - right_status_length)
    return screen.cursor.x


# Draw the tab bar
def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    # Draw the left status.
    # See the functions named draw_tab_with_* in kitty’s source code:
    # [kitty/tab_bar.py](https://github.com/kovidgoyal/kitty/blob/master/kitty/tab_bar.py)
    def draw_left_status_with(style: TabStyle) -> int:
        draw_tab_with_style = "draw_tab_with_" + style

        if draw_tab_with_style in locals() and callable(locals()[draw_tab_with_style]):
            return locals()[draw_tab_with_style](
                draw_data,
                screen,
                tab,
                before,
                max_title_length,
                index,
                is_last,
                extra_data,
            )
        elif draw_tab_with_style in globals() and callable(
            globals()[draw_tab_with_style]
        ):
            return globals()[draw_tab_with_style](
                draw_data,
                screen,
                tab,
                before,
                max_title_length,
                index,
                is_last,
                extra_data,
            )
        else:
            return 0

    end = draw_left_status_with(TAB_STYLE)
    draw_right_status(screen, is_last)

    return end
