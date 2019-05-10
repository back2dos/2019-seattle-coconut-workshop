import CalculatorState;

class CalculatorModel implements Model {
  
  @:observable var state:CalculatorState = Idle;
  @:observable var input:Float = 0;

  @:transition function inputDigit(digit:Float) 
    return { input: input * 10 + digit };

  @:transition function performOperation(op:Operation)
    return 
      switch [op, state] {
        case [Result, Idle]: {};
        case [Result, Queued(prev, value)]:
          { input: perform(prev, value, input), state: Idle };
        case [_, Idle]:
          { input: 0, state: Queued(op, input) };
        case [_, Queued(prev, value)]:
          { input: 0, state: Queued(op, perform(prev, value, input)) };
      }

  static function perform(op:Operation, a:Float, b:Float) 
    return switch op {
      case Result: throw 'assert';
      case Plus: a + b;
      case Minus: a - b;
      case Div: a / b;
      case Times: a * b;
    }
}