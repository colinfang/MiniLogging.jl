# MiniLogging.jl

[![Build Status](https://travis-ci.org/colinfang/MiniLogging.jl.svg?branch=master)](https://travis-ci.org/colinfang/MiniLogging.jl)

## Overview

This is a Julia equivalent of Python logging package. It provides a basic hierarchical logging system.

## Why another logging package?

When dealing with multple nested modules, the experience with the exising Julia `logging.jl` package isn't very nice.

- To keep a logger hierarchy, I have to explicitly pass in a parent logger which might not exist yet.
- To change the current logging level, I have to find all descendant loggers and explicitly set them.

## Features

- The logger hierarchy is defined by the logger name, which is a dot-separated string (e.g. `"a.b"`).
    - Simply use `get_logger(current_module())` to maintain a hierarchy.
- All loggers inherits their ancestors settings up to root if not explicitly set.
    - Only need to set the config of the root logger in most of the time.
- Colors & logging levels are customizable.

## Exposed Verbs

```julia
export get_logger, basic_config
export @debug, @info, @warn, @error, @critical
```

## Usage

```julia
julia> using MiniLogging

# Get root logger.
julia> root_logger = get_logger()
RootLogger(WARN:30)

# This is also root logger.
julia> get_logger("")
RootLogger(WARN:30)

# Set config. Do this once only in the script scope.
# It inserts a handler that outputs message to `STDERR`.
julia> basic_config(MiniLogging.INFO; date_format="%Y-%m-%d %H:%M:%S")

# It changes the root logger level.
julia> get_logger("")
RootLogger(INFO:20)

julia> @warn(root_logger, "Hello", " world")
2016-11-21 17:31:50:WARN:Main:Hello world

# Get a logger.
julia> logger = get_logger("a.b")
Logger("a.b", NOTSET:0)

# Since the level of `logger` is unset, it inherits its nearest ancestor's level.
# Its effective level is `INFO` (from `root_logger`) now.
julia> @info(logger, "Hello", " world")
2016-11-21 16:41:46:INFO:a.b:Hello world

# Since `DEBUG < INFO`, no message is generated.
# Note the argument expressions are not evaluated in this case to increase performance.
julia> @debug(logger, "Hello", " world", error("no error"))

# Explicitly set the level.
# The error is triggered.
julia> logger.level = MiniLogging.DEBUG
julia> @debug(logger, "Hello", " world", error("has error"))
ERROR: has error
 in error(::String) at ./error.jl:21

# Get a child logger.
julia> logger2 = get_logger("a.b.c")
Logger("a.b.c", NOTSET:0)

# Its effective level now is `DEBUG` (from `logger`) now.
julia> @debug(logger2, "Hello", " world")
2016-11-21 17:34:38:DEBUG:a.b.c:Hello world

```

## Add A New Level


```julia
julia> MiniLogging.define_new_level(:trace, 25, :yellow)
julia> @trace(logger, "Hello", " world")
2017-05-04 15:44:04:trace:a.b:Hello world
```