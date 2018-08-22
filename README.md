# shell-logger

Logger for shell script, working on Bash and Zsh.

This includes functions of `debug`, `info`(`information`), `notice`(`notification`), `warn`(`warning`) and `err`(`error`).
Each output is formatted with date-time and colored by each color definition.

These color codes are removed when the output is passed to a pipe or written into files.

![shelllogger](https://github.com/rcmdnk/shell-logger/blob/images/shelllogger.jpg)


# Installation

You can use an install script on the web like:

    $ curl -fsSL https://raw.github.com/rcmdnk/shell-logger/install/install.sh| sh

This will install scripts to `/usr/etc`
and you may be asked root password.

If you want to install other directory, do like:

    $ curl -fsSL https://raw.github.com/rcmdnk/shell-logger/install/install.sh|  prefix=~/usr/local/ sh

On Mac, you can install **etc/shell-logger.sh** by Homebrew:

    $ brew tap rcmdnk/rcmdnkpac/shell-logger

The file will be installed in **$(brew --prefix)/etc** (normally **/usr/local/etc**).

Otherwise download shell-logger.sh and place it where you like.


Once **shell-logger.sh** is installed,
source it in your `.bashrc` or `.zshrc` like:

```bash
source /path/to/shell-logger.sh
```

# Usage

In your script, source shell-logger:

    source /path/to/shell-logger.sh

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
LOGGER_DATE_FORMAT|Output date format.|'%Y/%m/%d %H:%M:%S'
LOGGER_LEVEL|0: DEBUG, 1: INFO, 2: NOTICE, 3: WARN, 4: ERROR|1
LOGGER_STDERR_LEVEL|For levels greater than equal this level, outputs will go stderr.|4
LOGGER_DEBUG_COLOR|Color for DEBUG|3 (Italicized. Some terminal shows it as color inversion)
LOGGER_INFO_COLOR|Color for INFO|"" (Use default output color)
LOGGER_NOTICE_COLOR|Color for NOTICE|36 (Front color cyan)
LOGGER_WARNING_COLOR|Color for WARNING|33 (Front color yellow)
LOGGER_ERROR_COLOR|Color for ERROR|31 (Front color red)
LOGGER_COLOR|Color mode: never->Always no color. auto->Put color only for terminal output. always->Always put color.|auto
LOGGER_LEVELS|Names printed for each level. Need 5 names.|("DEBUG" "INFO" "NOTICE" "WARNING" "ERROR")
LOGGER_SHOW_TIME|Show time information|1
LOGGER_SHOW_FILE|Show file/line information|1
LOGGER_SHOW_LEVEL|Show level|1
LOGGER_ERROR_RETURN_CODE|Error reutrn code of `err`/`error`|100
LOGGER_ERROR_TRACE|If 1, error trace back is shown by `err`/`error`|1

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
