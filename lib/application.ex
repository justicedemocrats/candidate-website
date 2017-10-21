defmodule CandidateWebsite.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    Cosmic.fetch_all()

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint
      supervisor(CandidateWebsite.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: CandidateWebsite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CandidateWebsite.Endpoint.config_change(changed, removed)
    :ok
  end
end
