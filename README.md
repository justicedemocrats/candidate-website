# User Pages

This is a template for our candidate sites – you can find them deployed at
https://alisonhartson.com, https://votesarahsmith.com, https://ocasio2018.com, https://bell2018.com, https://anthonyclark2018.com, https://paulajean2018.com, https://votecoribush.com, and https://chardo2018.com.

## Running Locally

You must have Elixir 1.5+ installed (1.6 would be great for auto-formatting).

To do that, visit https://elixir-lang.org/install.html and follow the instructions
for your operating system.

After that, assuming you've installed Git, run:
```
git clone https://github.com/justicedemocrats/candidate-website.git
cd candidate-website/
mix deps.get
mix phx.server
```

And then visit `http://localhost:4000/?candidate=alexandria-ocasio-cortez` in your
browser.

`?candidate=some-slug` is a required parameter.

## Making Changes

To make changes, modify the templates in `/lib/candidate_website/templates`, or the [Stylus](http://stylus-lang.com/) in `/assets/stylus`, and your changes will hot-reload.

## What's Happening

This is a barebones Elixir/Phoenix app which fetches content from [CosmicJS](http://cosmicjs.com/), which is an API first CMS.



