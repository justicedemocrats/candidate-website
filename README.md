# Webpacker

## Ahoy-hoy!
This a basic bare-bone setup for new Phoenix projects.

## What's inside?
Elixir Phoenix, Webpack, Stylus and React with Hot Module Replacement.

## What am I supposed to do with it?
Extend it, build new cool things with it – whatever the hell you want!

## Who are you?
This guy: [Letmecode](https://twitter.com/designingcode)

## Why Webpacker?
Several reasons.

1. **Brunch**, the default Phoenix build-tool, is about as useful as a sandbox in the desert. But hey, at least it's also annoying.

2. **React** and **Phoenix** are a golden match, but the former seems to work best with a proper **Webpack** setup. I was sick of building one for each project, so I build a general setup to start from.

## Your setup sucks!!11eleven
Fair enough, don't use it then. Oh, and don't forget to light yourself on fire. <sup id="a1">[‡](#f1)</sup>

## Installation

##### Clone the repository:
```
git clone https://github.com/odiumediae/webpacker.git
```

##### Change directory to the project:
```
cd webpacker
```

##### Do the Webpacker setup:
```
mix do webpacker.setup
```
**Note** YOu don't need to install the npm modules manually anymore, `webpacker.setup` should do that automatically. For convenience the setup uses Yarn, if installed, and a fallback to npm when it's not installed. You can, of course, still skip `webpacker.setup`, if you want more control by manually `cd`ing into `./assets` and running `npm install`, but I'm too lazy to do that ;) 

##### Start your Phoenix app in IEx:
```shell
iex -S mix phoenix.server
```

## Changelog

##### v0.1.2
* generated a completely new Phoenix app (1.3.0-rc.1), in order to minimise inconsistencies bewteen new conventions and how things worked in Phoenix 1.2.x, particularly in regard to folder structure and contexts. You can read up on that in a few minutes [here](https://hexdocs.pm/phoenix/1.3.0-rc.1/Mix.Tasks.Phx.Gen.Context.html#content) and [here](https://elixirforum.com/t/how-to-determine-contexts-with-phoenix-1-3/4367) or simply watch @chrismccord's [nice keynote](https://youtu.be/tMO28ar0lW8) from the Lonestar ElixirConf 2017
* added the mix task `webpacker.frontend` and plugged it into `webpacker.setup` in order to automatically install npm modules along with the rest of the setup. Just run `webpacker.setup` after cloning the repo and you can run `iex -S mix phx.server`
* renamed the wrongly named `iex.exs` to .iex.exs` and added some aliases so you don't have to alias the most used modules when trying out how to do stuff iwthin the REPL. You can simply add or remove imports, etc. to cater your needs

#### v0.1.3
* removed superfluous copy of old assets folder
* removed `ecto.migrate` from `webpacker.setup` task in mix.exs

#### v0.1.4
* removed copy-webpack-plugin@4.0.1 due to a bug that prevents assets being copied to priv/static correctly and used @2.1.6 instead

----

###### Footnotes
<sup id="f1">‡</sup> Don't actually do that, it freaking hurts! [↩](#a1)
