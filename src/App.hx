class App extends View {
  
  static final ROOT = Css.make({
    background: '#e8e8e8',
    padding: '2em',
    margin: '5em',
    textAlign: 'center',
    h1: {
      marginBottom: '1em',
    },
    nav: {
      display: 'flex',
      marginBottom: '40px',
      a: {
        display: 'block',
        marginLeft: '1em',
      }
    },
  });

  final model = new CalculatorModel();
  final timer = new TimerModel();

  function render() '
    <div class=${ROOT}>
      <nav>
        <a href="#calculator">Calculator</a>
        <a href="#timer">Timer</a>
      </nav>
      <if ${window.location.hash == '#timer'}>
        <div class=${ROOT}>
          <TimerView 
            ${...timer} 
            onChange=${timer.setTime} 
            onStart=${timer.start()} 
            onPause=${timer.pause()} 
            onReset=${timer.reset()} 
          />
        </div>
      <else>
        <CalculatorView ${...model} onInput=${model.inputDigit} onOperation=${model.performOperation} />
      </if>
    </div>
  ';

  function viewDidMount() 
    window.onhashchange = () -> forceUpdate();
}