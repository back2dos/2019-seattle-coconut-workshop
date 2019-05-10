class TimerView extends View {
  
  @:attribute var state:TimerState;
  @:attribute var hours:Int;
  @:attribute var minutes:Int;
  @:attribute var seconds:Int;
  @:attribute function onChange(value:Int, minutes:Int, seconds:Int):Void;
  @:attribute function onStart():Void;
  @:attribute function onPause():Void;
  @:attribute function onReset():Void;
  
  static final ROOT = Css.make({
    display: 'flex',
    alignItems: 'center'
  });
  
  @:state var ticks:Int = 0;

  @:computed var displaySeconds:Int = getDateComponent(seconds, v -> v % 60);
  @:computed var displayMinutes:Int = getDateComponent(minutes, v -> Std.int(v / 60) % 60);
  @:computed var displayHours:Int = getDateComponent(hours, v -> Std.int(v / 3600)  % 24);

  function getDateComponent(defaultValue:Int, compute:(seconds:Int)->Int) {
    ticks;
    return switch state {
      case Running(until):
        compute(Std.int((until.getTime() - Date.now().getTime()) / 1000));
      default: defaultValue;
    }
  }

  function render() '
    <div class={ROOT}>
      <DoubleDigits disabled={state != Paused} value=${displayHours} onChange=${hours -> onChange(hours, minutes, seconds)} />
        <div>:</div>
      <DoubleDigits disabled={state != Paused} value=${displayMinutes} onChange=${minutes -> onChange(hours, minutes, seconds)} />
        <div>:</div>
      <DoubleDigits disabled={state != Paused} value=${displaySeconds} onChange=${seconds -> onChange(hours, minutes, seconds)} />
      
      <if {state == Paused}>
        <button onclick=${onStart}>Start</button>
      <else>
        <button onclick=${onPause}>Pause</button>
      </if>
      <button onclick=${onReset}>Reset</button>
    </div>
  ';

  override function viewDidUpdate() 
    tick();

  override function viewDidMount()
    tick();

  function tick() 
    switch state {
      case Paused:
      case Running(until):
        var delta = until.getTime() - Date.now().getTime();
        if (delta < 0) onReset();
        else haxe.Timer.delay(() -> {
          ticks++;
          forceUpdate();//TODO: this should not be required
        }, 1000);
    }

}

class DoubleDigits extends View {
  static final ROOT = Css.make({
    display: 'flex',
  });  
  @:attribute var disabled:Bool;
  @:tracked //TODO: this should not be required
  @:attribute var value:Int;
  @:attribute function onChange(value:Int):Void;
  function render() '
    <div class={ROOT}>
      <Digit value=${Std.int(value / 10)} onChange=${digit -> onChange(value % 10 + 10 * digit)} />
      <Digit value=${value % 10} onChange=${digit -> onChange(Std.int(value / 10) * 10 + digit)} />  
    </div>
  ';
}

class Digit extends View {
  static final ROOT = Css.make({
    display: 'flex',
    flexDirection: 'column'
  });  

  @:attribute var value:Int;
  @:attribute function onChange(digit:Int):Void;

  function render() '
    <div class={ROOT}>
      <button onclick={onChange(value - 1)}>-</button>
      <button>${value}</button>
      <button onclick={onChange(value + 1)}>+</button>
    </div>
  ';
}