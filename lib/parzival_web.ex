defmodule ParzivalWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ParzivalWeb, :controller
      use ParzivalWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: ParzivalWeb

      import Plug.Conn
      import ParzivalWeb.Gettext
      alias ParzivalWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/parzival_web/templates",
        namespace: ParzivalWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {ParzivalWeb.LayoutView, "live.html"}

      unquote(view_helpers())
      unquote(error_handling_helpers())
    end
  end

  def live_view(layout) do
    quote do
      use Phoenix.LiveView,
        layout: unquote(layout)

      unquote(view_helpers())
      unquote(error_handling_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def component do
    quote do
      use Phoenix.Component

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ParzivalWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
      import Phoenix.LiveView.Helpers
      import ParzivalWeb.LiveHelpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import ParzivalWeb.ErrorHelpers
      import ParzivalWeb.Gettext
      import ParzivalWeb.ViewUtils
      alias ParzivalWeb.Router.Helpers, as: Routes

      alias Icons.{FontAwesome, Heroicons, Ionicons}
    end
  end

  # Injects helpers for error handling in live views
  defp error_handling_helpers do
    quote do
      def handle_info({:error, reason}, socket) do
        {:noreply,
         socket
         |> put_flash(:error, reason)}
      end
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  defmacro __using__(opts) when is_list(opts) do
    apply(__MODULE__, hd(opts), tl(opts))
  end
end
