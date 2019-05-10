enum CalculatorState {
  Idle;
  Queued(op:Operation, value:Float);
}