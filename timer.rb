class Timer
  def initialize
    @time = Time.now.to_i
    create_time_hash
  end

  def hour
    @et[:hours][0]
  end

  def minute
    @et[:minutes][0]
  end

  def find_amount(secs, spans_in_sec)
    spans = 0

    until secs < spans_in_sec
      secs -= spans_in_sec
      spans += 1
    end

    [spans, secs]
  end

  def create_time_hash
    @et = { years: [0, 1612800],
      months: [0, 134400],
      weeks: [0, 33600],
      days: [0, 4200],
      hours: [0, 175],
      minutes: [0, 35.0/12] }

    @et.each do |key, value|
      @et[key][0], @time = find_amount(@time, @et[key][1])
    end

    # @et.each do |key, value|
    #   puts "There are #{value[0]} number of #{key}."
    # end
  end
end

# time = Timer.new
# puts time.minute