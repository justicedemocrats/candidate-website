import React, { Component } from 'react';

class Hello extends Component {
  render() {
    return(
      <div className="greeting">
        <h1>Ahoy-hoy!</h1>
        <p>This a basic bare-bone setup for new Phoenix projects.</p>
        <hr />
        <h2>What's inside?</h2>
        <p>Elixir Phoenix, Webpack, Stylus and React with Hot Module Replacement.</p>
        <hr />
        <h2>What am I supposed to do with it?</h2>
        <p>Extend it, build new cool things with it &ndash; whatever the hell you want!</p>
        <hr />
        <h2> Who are you?</h2>
        <p>This guy: <a href="https://twitter.com/designingcode">Letmecode</a></p>
      </div>
    );
  }
}

export default Hello;
