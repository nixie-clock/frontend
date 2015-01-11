do (window)->
    class window.NixieClockView
        constructor: (@model)->
            @cacheElements()
            @model.onTick = =>
                @render()

        cacheElements: ->
            classess = []
            classess.push 's'+i for i in [0..10]
            @classess = classess.join ' '

            @el =
                $current_seconds: $('.jsSeconds')
                $current_time: $('.jsTime')
                $time_left: $('.jsTimeLeft')
                $time_binary: $('.jsTimeBin')
                time:
                    hours: [$('#nc_h_0'), $('#nc_h_1')]
                    minutes: [$('#nc_m_0'), $('#nc_m_1')]
                    seconds: [$('#nc_s_0'), $('#nc_s_1')]

                time_bin:
                    hours: [$('#ncb_h_0'), $('#ncb_h_1'), $('#ncb_h_2'), $('#ncb_h_3'), $('#ncb_h_4'), $('#ncb_h_5')]
                    minutes: [$('#ncb_m_0'), $('#ncb_m_1'), $('#ncb_m_2'), $('#ncb_m_3'), $('#ncb_m_4'), $('#ncb_m_5')]
                    seconds: [$('#ncb_s_0'), $('#ncb_s_1'), $('#ncb_s_2'), $('#ncb_s_3'), $('#ncb_s_4'), $('#ncb_s_5')]

        render: ->
            timeObj = @model.toJSON true

            @el.$current_seconds.text "#{timeObj.current_seconds} (#{timeObj.seconds_left})"
            @el.$current_time.text "#{timeObj.decimal_array.current_time.hours.join('')}:#{timeObj.decimal_array.current_time.minutes.join('')}:#{timeObj.decimal_array.current_time.seconds.join('')}"
            @el.$time_left.text "#{timeObj.decimal_array.time_left.hours.join('')}:#{timeObj.decimal_array.time_left.minutes.join('')}:#{timeObj.decimal_array.time_left.seconds.join('')}"
            @el.$time_binary.text "#{timeObj.binary_array.current_time.hours.join('')}:#{timeObj.binary_array.current_time.minutes.join('')}:#{timeObj.binary_array.current_time.seconds.join('')}"

            for $decHou, i in @el.time.hours
                $decHou.removeClass(@classess).addClass 's'+timeObj.decimal_array.current_time.hours[i]

            for $decMin, i in @el.time.minutes
                $decMin.removeClass(@classess).addClass 's'+timeObj.decimal_array.current_time.minutes[i]

            for $decSec, i in @el.time.seconds
                $decSec.removeClass(@classess).addClass 's'+timeObj.decimal_array.current_time.seconds[i]

            for $binHou, i in @el.time_bin.hours
                $binHou.removeClass(@classess).addClass 's'+timeObj.binary_array.current_time.hours[i]

            for $binMin, i in @el.time_bin.minutes
                $binMin.removeClass(@classess).addClass 's'+timeObj.binary_array.current_time.minutes[i]

            for $binSec, i in @el.time_bin.seconds
                $binSec.removeClass(@classess).addClass 's'+timeObj.binary_array.current_time.seconds[i]

    $ ->
        window.nixie_clock = new NixieClock()
        nixie_clock.view = new NixieClockView nixie_clock
