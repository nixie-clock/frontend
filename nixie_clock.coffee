do (window)->
    class NixieClock
        SECONDS_IN_DAY: 86400

        constructor: (custom_time)->
            nowDate = new Date()

            if typeof custom_time is 'number'
                @custom_time = @dateToSeconds new Date custom_time

            else if typeof custom_time is 'object' and !!custom_time
                time = new Date()
                time.setHours(  custom_time.hours  ) if custom_time.hours
                time.setMinutes(custom_time.minutes) if custom_time.minutes
                time.setSeconds(custom_time.seconds) if custom_time.seconds

                @custom_time = @dateToSeconds time

            @currentTime = @custom_time or @dateToSeconds(nowDate)
            @run()

        onTick: ->

        dateToSeconds: (dateObj)->
            return 3600 * dateObj.getHours() + 60 * dateObj.getMinutes() + dateObj.getSeconds()

        secondsToObject: (seconds)->
            hou = seconds // 3600
            min = (seconds - hou * 3600)  // 60
            sec = seconds - hou * 3600 - min * 60

            return hours: hou, minutes: min, seconds: sec

        convertToNumSys: (number, system=10)->
            counter = 1
            system_clone = system;

            while 59 >= system_clone
                system_clone *= system
                counter++

            converted = new Array counter

            while counter != 0
                counter--
                converted[counter] = number % system
                number = number // system

            return converted

        runner: ->
            if @custom_time
                @currentTime++
                @currentTime %= @SECONDS_IN_DAY

            else
                @currentTime = @dateToSeconds new Date()

            @onTick() if typeof @onTick is 'function'

        run: ->
            @_runnerTO = setInterval =>
                @runner()
            , 1000

        stop: ->
            clearInterval @_runnerTO

        toJSON: (full)->
            current_seconds = @currentTime
            seconds_left = @SECONDS_IN_DAY - current_seconds
            current_time = @secondsToObject current_seconds
            time_left = @secondsToObject seconds_left

            returnObject =
                current_seconds: current_seconds
                seconds_left: seconds_left
                current_time: current_time
                time_left: time_left

            if full
                returnObject.decimal_array =
                    current_time:
                        hours: @convertToNumSys current_time.hours
                        minutes: @convertToNumSys current_time.minutes
                        seconds: @convertToNumSys current_time.seconds

                    time_left:
                        hours: @convertToNumSys time_left.hours
                        minutes: @convertToNumSys time_left.minutes
                        seconds: @convertToNumSys time_left.seconds

                returnObject.binary_array =
                    current_time:
                        hours: @convertToNumSys current_time.hours, 2
                        minutes: @convertToNumSys current_time.minutes, 2
                        seconds: @convertToNumSys current_time.seconds, 2

                    time_left:
                        hours: @convertToNumSys time_left.hours, 2
                        minutes: @convertToNumSys time_left.minutes, 2
                        seconds: @convertToNumSys time_left.seconds, 2

            return returnObject

    window.NixieClock = NixieClock


