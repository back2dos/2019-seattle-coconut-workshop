import TimerState;

using DateTools;

class TimerModel implements Model {
  @:observable var hours:Int = 0;
  @:observable var minutes:Int = 0;
  @:observable var seconds:Int = 0;
  @:observable var state:TimerState = Paused;

  @:transition function setTime(hours, minutes, seconds) 
    return {
      hours: clamp(24, hours), 
      minutes: clamp(60, minutes), 
      seconds: clamp(60, seconds),
    }

  @:transition function start() 
    return {
      state: Running(Date.now().delta(hours.hours() + minutes.minutes() + seconds.seconds())),
    }

  @:transition function pause() 
    return {
      state: Paused,
    }
  @:transition function reset() 
    return {
      state: Paused,
      hours: 0,
      minutes: 0,
      seconds: 0,
    }

  function clamp(max:Int, value:Int)
    return 
      if (value < 0) 0;
      else if (value >= max) max - 1;
      else value;
}