# Unit tests for the timecore module in the parent folder
## Test generation
The tests were generated using the date command provided with linux.

### Summer- Winter- Time calculation
The file `testTimesMarchOctober.lua` tests all days in March and October until the year 2100.
It was generated with `generateTimesMarchOctober.sh`. As the minutes and seconds are generated randomly a new testscript can help to show new erros.

The file `testTimes.lua` tests all days from this year up to the year 2020.
It was generated with `testTimes.lua`.

### UnixTimestamp to UTC convertion
The file `testUnixtimes.lua` tests the convertion of an unixtimestamp (Second since 1970) to year, month, day, hour, minute, second and dayOfWeek.
It was generated with `generateUnixtimes.sh`. As the hour, minutes and seconds are generated randomly a new testscript can help to show new errors.

## UnixTimestamp to local time convertion
These tests combins both chaptes above.

## Test execution
All tests were executed on Linux with LUA version 5.1.5

The tests can be reproduced with the following commands:

```
$ lua testTimesMarchOctober.lua
$ lua testTimes.lua
$ lua testUnixtimes.lua
```
