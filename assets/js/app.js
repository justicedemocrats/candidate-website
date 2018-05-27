import spa from "./spa";
import Hamburger from "./components/hamburger";
import React from "react";
import { render } from "react-dom";
import { ShyNav } from "./shy-nav";

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

setTimeout(() =>         {
             bind();
             ShyNav.init('main-nav');
         },
         100);

const hamburgerTarget = document.getElementsByClassName("mobile-menu")[0];
const hamburgerTargetFooter = document.getElementsByClassName("mobile-menu")[1];

if (hamburgerTarget) {
  render(<Hamburger />, hamburgerTarget);
}

if (hamburgerTargetFooter) {
  render(<Hamburger />, hamburgerTargetFooter);
}
