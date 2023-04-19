defmodule ParzivalWeb.Components.PasswordInput do
  use ParzivalWeb, :live_component

  def render(assigns) do
    ~H"""

    """
  end

  def update(%{id: id} = params, socket) do
    {:ok, assign(socket, :id, id)}
  end
end
