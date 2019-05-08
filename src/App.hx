class App extends View {
  
  static final ROOT = Css.make({
    background: '#e8e8e8',
    padding: '2em',
    margin: '2em',
    textAlign: 'center',
    h1: {
      marginBottom: '1em',
    }
  });

  function render() '
    <div class=${ROOT}>
      <h1>Hello, world!</h1>
      <a href="https://github.com/back2dos/2019-seattle-coconut-workshop">https://github.com/back2dos/2019-seattle-coconut-workshop</a>
    </div>
  ';
}