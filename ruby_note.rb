=begin
Need a timer that tracks Eorzea Time
  - I set the original time when you open the application
  -If the user closes the application the program tracks the current ET, the current real time based on there computer clock.
  - When the user opens the program again the application grabs the current real time based on the computer clock and translates that to the time passed in ET and adds that to the current ET time.
  - (Maybe if too much time since the last time the user has used the app the app will ask the user for the current ET instead of doing the math).

  How to find Eorzea Time from time passed in real time?
    - 11:25 wait 5 real mintues  would be 11:

Need to be able to input alarms that have fields (time, location, warning?)

When time matches an alarm time a sound plays.




# at 3pm it is 3:26 a.m ez
# eorzeaTime / HOUR % 24)
# eorzeaTime / MINUTE % 60)

# Handy method to get the current unix time stamp in Ruby. Unix time, or POSIX time, is a system for describing instants in time, defined as the number of seconds that have elapsed since 00:00:00 Coordinated Universal Time (UTC), Thursday, 1 January 1970.
# Time.now.to_i

Unix time is in seconds.
For every second that goes by in real life in et ...?
For every minute in real life in et 2 11/13 seconds go by
For every hour in real life in et 2 minutes, 55 seconds go by
For every day in real life in et 70 minutes go by

A day is 70 minutes


Convert Unix from seconds from to minutes from?

        YEAR   = 33177600
        MONTH  = 2764800
        DAY    = 86400
        HOUR   = 3600
        MINUTE = 60
        SECOND = 1

ETCON = 3600 / 175
=end

# YEAR   = 1612800
# MONTH  = 134400
# WEEK   = 33600
# DAY    = 4200
# HOUR   = 175
# MINUTE = 35.0/12

time = Time.now.to_i #* (3600.0 / 175.0)  # seconds since 1970-01-01 00:00:00
# real_min_in_60_sec = 35.0/12 # 2 11 12 sec in 60 secs = 1 min
# year = 18 days, 16 hours (in seconds would be 24 hours in a day.
#       - 24 x 18 = 432 hours + 16 = 448 hours * 60 = 26880 minutes * 60 = 1612800
# month = 37 hours, 20 min = 2240 min * 60 = 134400
# week = 9 hours, 20 min = 560 min * 60 = 33600
# day = 70 min * 60 = 4200
# hour = 2 min 55 sec = 175

def find_amount(secs, spans_in_sec)
  spans = 0

  until secs < spans_in_sec
    secs -= spans_in_sec
    spans += 1
  end

 [spans, secs]
end


et = { years: [0, 1612800],
       months: [0, 134400],
       weeks: [0, 33600],
       days: [0, 4200],
       hours: [0, 175],
       minutes: [0, 35.0/12] }

et.each do |key, value|
  et[key][0], time = find_amount(time, et[key][1])
end

et.each do |key, value|
  puts "There are #{value[0]} number of #{key}."
end

# years = 0

# until unix_time < YEAR
#   unix_time -= YEAR
#   years += 1
# end

# p years

# months = 0

# until unix_time < MONTH
#   unix_time -= MONTH
#   months += 1
# end

# p months

# weeks = 0

# until unix_time < WEEK
#   unix_time -= WEEK
#   weeks += 1
# end

# p weeks

# days = 0

# until unix_time < DAY
#   unix_time -= DAY
#   days += 1
# end

# p days

# hours = 0

# until unix_time < HOUR
#   unix_time -= HOUR
#   hours += 1
# end

# p hours

# minutes = 0

# until unix_time < MINUTE
#   unix_time -= MINUTE
#   minutes += 1
# end

# p minutes