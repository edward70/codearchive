import { h, Component } from 'preact';
import style from './style';

export default class Home extends Component {
  constructor(props) {
    super(props);
    this.state = {value: 'Brisbane'};

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({value: event.target.value});
  }

  handleSubmit(event) {
    var value = this.state.value;
    var request = new XMLHttpRequest();
    request.open('GET', '../../data/data.json', true);

    request.onload = function() {
      if (request.status >= 200 && request.status < 400) {
        // Success!
        var data = JSON.parse(request.responseText);
        window.perperson = data[value][new Date().getFullYear()] / 24657146;
        event.preventDefault();
      } else {
        alert('Unknown error');
      }
    };

    request.onerror = function() {
        alert('Connection Error');
    };

    request.send();
	  
    var req = new XMLHttpRequest();
    req.open('GET', '../../data/population.json', true);

    req.onload = function() {
      if (req.status >= 200 && req.status < 400) {
        // Success!
        var data = JSON.parse(req.responseText);
	var statepopulation = data[value][new Date().getFullYear()];
        alert(window.perperson * statepopulation);
      } else {
        alert('Unknown error');
      }
    };

    req.onerror = function() {
        alert('Connection Error');
    };

    req.send();
  }

  render() {
    return (
      <div class={style.home}>
          <h1>Find The Cost Of Congestion</h1>
          <p>Congestion gets everyone stuck, costing billions of dollars.</p>
          <form onSubmit={this.handleSubmit}>
            <label>
                Please select your City
                <select value={this.state.value} onChange={this.handleChange}>
	            <option value="Brisbane">Brisbane</option>
                    <option value="Sydney">Sydney</option>
                    <option value="Canberra">Canberra</option>
	            <option value="Melbourne">Melbourne</option>
	            <option value="Adelaide">Adelaide</option>
	            <option value="Perth">Perth</option>
	            <option value="Darwin">Darwin</option>
	            <option value="Hobart">Hobart</option>
                </select>
            </label>
            <input type="submit" value="Submit" />
          </form>
      </div>
    );
  }
}
