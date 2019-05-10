class CalculatorView extends View {

  static final ROOT = Css.make({
    margin: '10px',
    maxWidth: '250px'
  });

  static final BUTTON_GRID = Css.make({
    display: 'flex',
    flexWrap: 'wrap',
    '&>*': {
      flexBasis: '33%',
      flexGrow: '0',
      flexShrink: '1',
    }
  });

  static final BUTTON = Css.make({
    padding: '20px',
  });

  static final DISABLED = Css.make({
    opacity: '.5',
  });

  static final DIGIT = Css.make({
    background: 'green',
  }).add(BUTTON);

  @:attribute var state:CalculatorState;
  @:attribute var input:Float;

  @:attribute function onInput(digit:Int):Void;
  @:attribute function onOperation(op:Operation):Void; 

  function render() '
    <div class={ROOT}>
      <div>
        <switch ${state}>
          <case ${Idle}>
          <case ${Queued(op, value)}>
            <small>${Std.string(value)} ${opToString(op)}</small>
        </switch>
        ${Std.string(input)}
      </div>
      <div class={BUTTON_GRID}>
        <for {i in 1...10}>
          <digit value={i} />
        </for>
        <operation op={Plus} />
        <digit value={0} />
        <operation op={Minus} />
        <operation op={Times} />
        <operation op={Div} />
        <operation op={Result} disabled={
          switch state {
            case Idle: true;
            case Queued(Div, _): input == 0;
            default: false;
          }
        } />
      </div>
    </div>
  ';

  function operation(attr:{ op: Operation, ?disabled:Bool }) '
    <button class={BUTTON.add([DISABLED => attr.disabled])} onclick={onOperation(attr.op)} disabled={attr.disabled}>
      ${opToString(attr.op)}
    </button>
  ';

  function digit(attr:{ value: Int }) '
    <button class=${DIGIT} onclick=${onInput(attr.value)}>
      ${attr.value}
    </button>
  ';

  static function opToString(op:Operation) 
    return switch op {
      case Plus: '+';
      case Result: '=';
      case Div: '/';
      case Minus: '-';
      case Times: '*';
    }    
}