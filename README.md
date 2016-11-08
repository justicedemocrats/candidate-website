#Webpacker

##Ahoy-hoy!
This a basic bare-bone setup for new Phoenix projects.

##What's inside?
Elixir Phoenix, Webpack, Stylus and React with Hot Module Replacement.

##What am I supposed to do with it?
Extend it, build new cool things with it – whatever the hell you want!

##Who are you?
This guy: [Letmecode](https://twitter.com/designingcode)

##Why Webpacker?
Several reasons.

1. **Brunch**, the default Phoenix build-tool, is about as useful as a sandbox in the desert. But hey, at least it's also annoying.

2. **React** and **Phoenix** are a golden match, but the former seems to work best with a proper **Webpack** setup. I was sick of building one for each project, so I build a general setup to start from.

##Your setup sucks!!11eleven
Fair enough, don't use it then. Oh, and don't forget to light yourself on fire. <sup id="a1">[‡](#f1)</sup>

##Installation
Clone the repository:
```
git clone https://github.com/odiumediae/webpacker.git
```
Change directory to the project:
```
cd weppacker
```
Then get the dependencies and build webpacker in dev mode using this cute little one-liner:
```
mix do deps.get, deps.update --all && npm install && iex -S mix phoenix.server
```

----

######Footnotes
<sup id="f1">‡</sup> Don't actually do that, it freaking hurts! [↩](#a1)