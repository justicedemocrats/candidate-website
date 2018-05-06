import spa from "./spa";
import { ShyNav } from "./shy-nav";
import Hamburger from "./components/hamburger";
import React from "react";
import { render } from "react-dom";

spa.bind.all();

// setTimeout(() => {
//   const el = document.querySelector('#filled-animate')
//   const targetHeight = el.getAttribute('data-height')
//   el.style.height = `${targetHeight}%`
// }, 500)

const bind = () => {
  const ref = getQueryStringValue("ref");
  if (ref != "") {
    Array.from(document.querySelectorAll("form"))
      .filter(f => f.method == "post")
      .forEach(f => (f.action = f.action + `?ref=${ref}`));
  }
};

function getQueryStringValue(key) {
  return decodeURIComponent(
    window.location.search.replace(
      new RegExp(
        "^(?:.*[&\\?]" +
          encodeURIComponent(key).replace(/[\.\+\*]/g, "\\$&") +
          "(?:\\=([^&]*))?)?.*$",
        "i"
      ),
      "$1"
    )
  );
}

setTimeout(() =>
        {
            bind();
            ShyNav.init('main-nav');
        },
        100);

const hamburgerTarget = document.getElementById("mobile-menu");
if (hamburgerTarget) {
  render(<Hamburger />, hamburgerTarget);
}
