
## Introduction

Concept time/date/calendar library for the Janet programming language

The goal is to provide a lightweight library for working with times and dates.
"complicated" functionaltiy like localization and time zone handling should be
delagated to the operating system or C library when possible.

## API

The functions that perform conversion between `time` and `datetime` types
all have an optional time zone argument `tz`; this argument is a string
with a RFC 2822/ISO 8601 time zone name.

when this argument is not given the functions act on the local time zone.


### Read clock

The following functions all return time as a floating point number:

`(time/now)`

Read the real time clock. The result is a floating point number indicating
the number of seconds since the UNIX epoch.


`(time/monotonic)`

Get current monotonic time. The result is a floating point number with an
undefined epoch that is guarunteed to be monotonic.


`(time/cputime)`

Get CPU time used by current process. The result is a floating point number
indicating the number of seconds the current process has spent executing on
the CPU.


### Conversion

`(time/to-datetime time &opt tz)`:

Convert a time to a datetime struct.


`(time/from-datetime dt &opt tz)`

Convert a datetime struct to a time.


### Formatting and parsing


`(time/format time &opt fmt tz)`

Format the given time to ASCII string. The format string is C89 
strftime(3) format, or one of the predefined formats:

- :iso-8601
- :rfc-3339
- :rfc-2822
- :w3c

When the `fmt` argument is not given, it defaults to the `:rfc-2822` format.


`(time/parse fmt string &opt tz)`

parse a time in the given format. The format string is a subset of the C89
strftime(3) format:
- %Y: year, 4 digits
- %y: year, 2 digits, 2000 is added if the year is less than 70
- %m: month, 2 digits, 01-12
- %d: day, 2 digits, 01-31
- %H: hour, 2 digits, 00-23
- %I: hour, 2 digits, 01-12
- %M: minute, 2 digits, 00-59
- %S: second, 2 digits, 00-59
- %p: AM/PM

or one of the predefined formats:
- :iso-8601
- :rfc-3339
- :rfc-2822
- :w3c


## Design considerations and other ramblings

### Basic concepts

- *clock*: some functiality measuring and providing time (typically provided by the OS)

- *clock source*: indentifier specifying a source of time: `:monononic-time`,
  `:system-time`, `:cpu-time`

- *monotonic time*: floating point representation of a monotonically increasing 
  time in seconds with no defined epoch.

- *system time*: floating point representation of the system clock in seconds,
  relative to the *system time epoch*

- *cpu time*: floating point representation of the CPU time used by a process
  or thread.

- *system time epoch*: Represents the timestamp of the *system time* value `0`:
  equal to the UNIX time epoch: January 1st 1970 00:00:00 UTC.

- *interval*: the difference between two `monotime` or `system-time` times, in
  seconds.

- *time zone*: a string identifying a world region time zone, for example
  "GMT", "UTC", "CET", "CET+3", etc. See ISO 8610.

- *datetime*: time components: *year*, *month*, *day-of-month*, *day-of-year*, *weekday*,
  *hour*, *minute*, *second*.

- *UTC time*: representation of a system time in *datetime* in
  Coordinated Universal Time.

- *local time*: representation of a system time in *datetime* in
  a given time zone.

- *resolution*: the smallest interval a given clock source can represent.


### Functionality

The time library should offer the following functionality, properly handling
time zones where appropiate:

- Querying system time, monotonic time and cpu time

- Breaking down system time to individual *datetime* components.

- Composing individual *datetime* components into a system time.

- Formatting *datetime* to human readable format using custom formatting or
  well-known time formats.

- Parsing *datetime* from human readable format using custom formatting or
  well-known time formats.

- Basic time arithmatic: adddition and subtraction of *system time* and
  *datetime*


### Implementation


#### Clocks and sources

Querying time from a given clock source is provided by the stdlib `os/clock`
and `os/time` functions. These are implemented with the following primitives:

  * Windows: system time: `GetSystemTimeAsFileTime()`, monotonic time:
    `QueryPerformanceCounter()`, cpu time: `GetProcessTimes()`

  * Apple: system time: `host_get_clock_service()`, monotonic time:
    `host_get_clock_service()`, cpu time: `clock()`

  * Linux/POSIX: system time: `clock_gettime(CLOCK_REALTIME)`, monotonic time:
    `clock_gettime(CLOCK_MONOTONIC)`, cpu time:
    `clock_gettime(CLOCK_PROCESS_CPUTIME_ID)`


#### *datetime*

Janet already has a representation for broken down time as a `date struct`,
https://janet-lang.org/api/index.html#os/date

Reuse this time? It uses a somewhat confusing 0-based indexing for
*day-of-month* and *month-of-year* though.


#### Composing system time from datetime

Janet provides basic functionality through the C library `mktime()` and
`timegm()` funcion wrapper `os/mktime`. `mktime` has no portable way for
handling time zones though.


#### Splitting system time into datetime

Janet provides `os/date` as a wrapper around the C library `localtime()` and
`gmtime()`
functions. These have no portable way for handling time zones.


### Localization

I don't even want to think about that. Delegate to C library


### Time zones

See "Localization"


#### Time formatting

Some thoughts:

- Implementaion in native Janet janet should be easy for numerical times and
  dates, but will not support localazation for week and month names.

- Janet provides a wrapper around the C library `strftime()` function as
  `os/strftime`, which does take care of localzation.

- Time zone handling is not standardized for `strftime()`


#### Time parsing

POSIX defines the `strptime()` C function, which parses a `struct tm` from a
given time format; this is not available on Windows.

Implementing time parsing in native Janet should not be too hard.


