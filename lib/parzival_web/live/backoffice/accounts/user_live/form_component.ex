defmodule ParzivalWeb.Backoffice.UserLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  alias Parzival.Accounts

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end
end
