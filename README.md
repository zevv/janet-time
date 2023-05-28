
## Introduction

Concept time/date/calendar library for the Janet programming language


## Basic concepts

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

- *date/time components*: *year*, *month*, *day-of-month*, *day-of-year*, *weekday*,
  *hour*, *minute*, *second*.

- *UTC time*: representation of a system time in *date/time components* in
  Coordinated Universal Time.

- *local time*: representation of a system time in *date/time components* in
  a given time zone.

- *resolution*: the smallest interval a given clock source can represent.


## Functionality

The time library should offer the following functionality, properly handling
time zones where appropiate:

- Querying system time, monotonic time and cpu time

- Breaking down system time to individual *date/time components*.

- Composing individual *date/time components* into a system time.

- Formatting *date/time components* to human readable format using custom
  formatting or well-known time formats.

- Parsing *date/time components* from human readable format using custom
  formatting or well-known time formats.


## Implementation


### Clocks and sources

Querying time from a given clock source is provided by the stdlib `os/clock`
and `os/time` functions. These are implemented with the following primitives:

  * Windows: system time: `GetSystemTimeAsFileTime()`, monotonic time:
    `QueryPerformanceCounter()`, cpu time: `GetProcessTimes()`

  * Apple: system time: `host_get_clock_service()`, monotonic time:
    `host_get_clock_service()`, cpu time: `clock()`

  * Linux/POSIX: system time: `clock_gettime(CLOCK_REALTIME)`, monotonic time:
    `clock_gettime(CLOCK_MONOTONIC)`, cpu time:
    `clock_gettime(CLOCK_PROCESS_CPUTIME_ID)`


### *date/time components*

Janet already has a representation for broken down time as a `date struct`,
https://janet-lang.org/api/index.html#os/date

Reuse this time? It uses a somewhat confusing 0-based indexing for
*day-of-month* and *month-of-year* though.


### Composing system time from date/time components

Janet provides basic functionality through the C library `mktime()` and
`timegm()` funcion wrapper `os/mktime`. `mktime` has no portable way for
handling time zones though.


### Splitting system time into date/time components

Janet provides `os/date` as a wrapper around the C library `localtime()` and
`gmtime()`
functions. These have no portable way for handling time zones.


## Localization

I don't even want to think about that. Delegate to C library


## Time zones

See "Localization"


### Time formatting

Some thoughts:

- Implementaion in native Janet janet should be easy for numerical times and
  dates, but will not support localazation for week and month names.

- Janet provides a wrapper around the C library `strftime()` function as
  `os/strftime`, which does take care of localzation.

- Time zone handling is not standardized for `strftime()`


### Time parsing

POSIX defines the `strptime()` C function, which parses a `struct tm` from a
given time format; this is not available on Windows.

Implementing time parsing in native Janet should not be too hard.


