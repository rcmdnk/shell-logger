# shell-logger

Logger for shell script.

This includes functions of `debug`, `info`, `notice`, `warning` and `error`.
Each output is formatted with date-time and colored by each color definition.

These color codes are removed when the output is passed to a pipe or written into files.

![shelllogger](https://github.com/rcmdnk/shell-logger/blob/images/shelllogger.jpg)


# Installation

On Mac, you can install **etc/shell-logger.sh** by Homebrew:

    $ brew tap rcmdnk/rcmdnkpac/shell-logger

The file will be installed in **$(brew --prefix)/etc** (normally **/usr/local/etc**).

Otherwise download shell-logger.sh and place it where you like.

# Usage

In your script, source shell-logger:

    source /usr/local/etc/shell-logger.sh

Then, you can use such `info` or `err` command in your script like:

```bash
#!/bin/bash

source /usr/local/etc/shell-logger.sh

test_command
ret=$?
if [ ret = 0 ];then
  info Command succeeded.
else
  err Command failed!
fi
```

Each level has each functions:

LEVEL|Functions
:----|:--------
DEBUG|`debug`
INFO|`info`, `information`
NOTICE|`notice`, `notification`
WARNING|`warn`, `warning`
ERROR|`err`, `error`

# Options

Variable Name|Description|Default
:------------|:----------|:-----
_LOGGER_DATE_FORMAT|Output date format.|'%Y/%m/%d %H:%M:%S'
_LOGGER_LEVEL|0: DEBUG, 1: INFO, 2: NOTICE, 3: WARN, 4: ERROR|1
_LOGGER_STDERR_LEVEL|For levels greater than equal this level, outputs will go stderr.|4
_LOGGER_DEBUG_COLOR|Color for DEBUG|3 (Italicized. Some terminal shows it as color inversion)
_LOGGER_INFO_COLOR|Color for INFO|"" (Use default output color)
_LOGGER_NOTICE_COLOR|Color for NOTICE|36 (Front color cyan)
_LOGGER_WARNING_COLOR|Color for WARNING|33 (Front color yellow)
_LOGGER_ERROR_COLOR|Color for ERROR|31 (Front color red)
_LOGGER_COLOR|Color mode: never->Always no color. auto->Put color only for terminal output. always->Always put color.|auto
_LOGGER_LEVELS|Names printed for each level. Need 5 names.|("DEBUG" "INFO" "NOTICE" "WARNING" "ERROR")

About colors, you can find the standard definitions in
[Standard ECMA-48](http://www.ecma-international.org/publications/standards/Ecma-048.htm)
(p61, p62).

Normal are:

Number|Color definition
:-----|:---------------
30|black display
31|red display
32|green display
33|yellow display
34|blue display
35|magenta display
36|cyan display
37|white display
40|black background
41|red background
42|green background
43|yellow background
44|blue background
45|magenta background
46|cyan background
47|white background

You can set display (letter's color) and background in the same time.
For example, if you want to use red background and white front color for error output,
set:

    _LOGGER_ERROR_COLOR="37;41"

You can easily check colors by [escseqcheck](https://github.com/rcmdnk/escape_sequence/blob/master/bin/escseqcheck).
