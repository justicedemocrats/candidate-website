defmodule CandidateWebsite do
  def controller do
    quote do
      use Phoenix.Controller, namespace: CandidateWebsite
      import Plug.Conn
      import CandidateWebsite.Router.Helpers
      import CandidateWebsite.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/candidate_website/templates",
        namespace: CandidateWebsite

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import CandidateWebsite.Router.Helpers
      import CandidateWebsite.ErrorHelpers
      import CandidateWebsite.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import CandidateWebsite.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
