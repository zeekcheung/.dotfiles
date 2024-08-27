#!/usr/bin/env python

# NOTE: This file is used to draw the tab bar in kitty.
# See [this discussion](https://github.com/kovidgoyal/kitty/discussions/4447) for examples from kitty users.

import datetime
import socket
from dataclasses import dataclass
from typing import List
from kitty.utils import color_as_int  # pyright: ignore[reportMissingImports]
from kitty.fast_data_types import Screen, get_options  # pyright: ignore[reportMissingImports]
from kitty.tab_bar import (DrawData, ExtraData, TabBarData, as_rgb, draw_tab_with_separator)  # fmt: skip


# Translate the kitty colors to rgb.
def color_as_rgb(color):
    return as_rgb(color_as_int(color))  # pyright: ignore[reportCallIssue]


opts = get_options()

# Colors are defined in current-theme.conf.
TAB_BAR_BG = color_as_rgb(opts.tab_bar_background)
ACTIVE_TAB_FOREGROUND = color_as_rgb(opts.active_tab_foreground)


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

    # Contents
    hostname = socket.gethostname()
    date = datetime.datetime.now().strftime("%Y-%m-%d")
    clock = datetime.datetime.now().strftime("%H:%M")

    host_component = Component(
        " " + hostname + " ",
        ComponentOptions(ACTIVE_TAB_FOREGROUND, TAB_BAR_BG),
    )
    date_component = Component(
        " " + date + " ", ComponentOptions(ACTIVE_TAB_FOREGROUND, TAB_BAR_BG)
    )
    clock_component = Component(
        " " + clock + " ",
        ComponentOptions(ACTIVE_TAB_FOREGROUND, TAB_BAR_BG),
    )

    components: List[Component] = [
        host_component,
        date_component,
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
    draw_data: DrawData,  # pyright: ignore[reportGeneralTypeIssues]
    screen: Screen,
    tab: TabBarData,  # pyright: ignore[reportGeneralTypeIssues]
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,  # pyright: ignore[reportGeneralTypeIssues]
) -> int:
    # Draw the left status.
    # See the functions named draw_tab_with_* in kitty’s source code:
    # [kitty/tab_bar.py](https://github.com/kovidgoyal/kitty/blob/master/kitty/tab_bar.py)
    # Remember importing the function from kitty.tab_bar
    end = draw_tab_with_separator(draw_data, screen, tab, before, max_title_length, index, is_last, extra_data)  # fmt: skip # pyright: ignore[reportCallIssue]
    draw_right_status(screen, is_last)

    return end
