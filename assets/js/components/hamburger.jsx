import React, { Component } from "react";
import smoothScroll from "smoothscroll";

export default class Hamburger extends Component {
  state = {
    open: false
  };

  openMenu = () => this.setState({ open: true });
  closeMenu = () => this.setState({ open: false });

  render() {
    const { open } = this.state;

    if (open) {
      return this.renderOpenMenu();
    } else {
      return this.renderHamburger();
    }
  }

  renderHamburger() {
    return (
      <div style={styles.bar.parent} onClick={this.openMenu}>
        <div style={styles.bar.bar} />
        <div style={styles.bar.bar} />
        <div style={styles.bar.bar} />
      </div>
    );
  }

  renderOpenMenu() {
    return (
      <div style={styles.screen} onClick={this.closeMenu}>
        <div style={styles.menu}>
          <div style={styles.candidate.name}>{window.name}</div>
          <div style={styles.candidate.district}>{window.district}</div>
          {siteMap.map(({ text, action, extraStyles }) => (
            <div
              style={Object.assign(
                {},
                styles.menuElement,
                extraStyles ? extraStyles : {}
              )}
              onClick={action}
            >
              {text}
            </div>
          ))}
        </div>
      </div>
    );
  }
}

const styles = {
  bar: {
    parent: {
      display: "flex",
      flexDirection: "column",
      justifyContent: "space-between",
      width: 40,
      height: 30,
      marginRight: 15,
      marginTop: 15,
      cursor: "pointer"
    },

    bar: {
      width: 40,
      height: 5,
      backgroundColor: window.heroTextColor,
      borderRadius: "10px"
    }
  },

  screen: {
    width: "100vw",
    height: "100vh",
    backgroundColor: "rgba(0, 0, 0, .3)",
    position: "fixed",
    left: 0,
    zIndex: 10
  },

  menu: {
    position: "fixed",
    height: "100vh",
    width: "66vw",
    right: 0,
    backgroundColor: "black",
    padding: 20,
    color: "white",
  },

  menuElement: {
    marginTop: 15,
    marginBottom: 15,
    fontFamily: "Roboto Condensed",
    fontSize: "larger",
    color: "#aaa"
  },

  candidate: {
    name: {
      fontSize: "30px",
      fontFamily: "Roboto Condensed"
    },

    district: {
      fontSize: "24px",
      fontFamily: "Roboto Condensed",
      color: "#aaa",
      marginBottom: 30
    }
  }
};

const siteMap = [
  {
    text: "Contribute",
    action: () => (window.location.href = window.donateUrl),
    extraStyles: {
      borderBottom: "3px solid white",
      color: "white"
    }
  },
  {
    text: "About",
    action: () =>
      window.aboutEnabled
        ? (window.location.pathname = "/about")
        : smoothScroll(document.querySelector("#why"))
  },
  { text: "Issues", action: () => (window.location.pathname = "/issues") },
  {
    text: "Events",
    action: () => smoothScroll(document.querySelector("#events"))
  },
  { text: "News", action: () => smoothScroll(document.querySelector("#news")) },
  {
    text: "Volunteer",
    action: () => smoothScroll(document.querySelector("#volunteer")),
    extraStyles: {
      borderBottom: "3px solid white",
      color: "white"
    }
  }
];
