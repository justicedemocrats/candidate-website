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
  end

  scope "/api", CandidateWebsite do
    pipe_through(:api)

    get("/update/cosmic", UpdateController, :cosmic)
    post("/update/cosmic", UpdateController, :cosmic)
  end

  scope "/", CandidateWebsite do
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/about", PageController, :about)
    get("/platform", PageController, :platform)

    post("/signup", PageController, :signup)
    post("/volunteer", PageController, :volunteer)
    get("/*path", ShortenerController, :index)
  end
end
