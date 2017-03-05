import React from 'react';
import { render } from 'react-dom';

import "phoenix_html";
// import socket from "./socket"

import Hello from './components/Hello';

render(<Hello />, document.getElementById('app'));
