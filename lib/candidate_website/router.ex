defmodule CandidateWebsite.Router do
  use CandidateWebsite, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(CORSPlug)
  end

  scope "/api", CandidateWebsite do
    pipe_through(:api)

    get("/update/cosmic", UpdateController, :get_cosmic)
    post("/update/cosmic", UpdateController, :post_cosmic)
    get("/events", UpdateController, :get_events)
  end

  scope "/", CandidateWebsite do
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/about", PageController, :about)
    get("/platform", PageController, :platform)
    get("/press", PageController, :press)
    get("/news", PageController, :press)
    get("/endorsements", PageController, :endorsements)
    get("/issues", PageController, :platform)
    get("/info", PageController, :info)
    get("/volunteer", PageController, :get_volunteer)

    post("/signup", PageController, :signup)
    post("/volunteer", PageController, :volunteer)

    get("/petition/:slug", PetitionController, :get)
    post("/petition/:slug", PetitionController, :post)

    get("/*path", ShortenerController, :index)
  end
end
