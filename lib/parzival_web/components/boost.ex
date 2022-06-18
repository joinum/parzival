defmodule ParzivalWeb.Components.Boost do
  @moduledoc false
  use ParzivalWeb, :live_component

  alias Parzival.Uploaders
  alias Parzival.Store

  def render(assigns) do
    ~H"""
    <div class="w-12 h-12">
      <%= if ! assigns.item.expires_at do %>
        <%= if assigns.item.boost.type in [:exp, :tokens] do %>
          <button phx-click="activate_boost" phx-value-item_id={assigns.item.id} phx-target={@myself} data-confirm={"Are you sure you wanna activate #{assigns.item.boost.name}? #{assigns.item.boost.description}."}>
            <img src={Uploaders.BoostImage.url({assigns.item.boost.image, assigns.item.boost}, :original)} class="object-cover object-center w-full h-full lg:w-full lg:h-full hover:opacity-70" />
          </button>
        <% else %>
          <img src={Uploaders.BoostImage.url({assigns.item.boost.image, assigns.item.boost}, :original)} class="object-cover object-center w-full h-full lg:w-full lg:h-full" />
        <% end %>
      <% else %>
        <div class="relative">
          <img src={Uploaders.BoostImage.url({assigns.item.boost.image, assigns.item.boost}, :original)} class="object-cover object-center w-full h-full lg:w-full lg:h-full" />
          <div style={"height: #{100 - round(Timex.diff(assigns.item.expires_at, NaiveDateTime.utc_now()) / 36_000_000)}%"} class="absolute top-0 w-12 bg-black opacity-50" />
        </div>
      <% end %>
    </div>
    """
  end

  def handle_event("activate_boost", %{"item_id" => item_id}, socket) do
    item = Store.get_item!(item_id)

    Store.update_item(item, %{expires_at: Timex.shift(NaiveDateTime.utc_now(), minutes: 1)})
    # Store.update_item(item, %{expires_at: Timex.shift(NaiveDateTime.utc_now(), hours: 1)})

    {:noreply,
     socket
     |> assign(
       inventory: Store.list_inventory(where: [user_id: item.user_id], preloads: [:boost])
     )
     |> IO.inspect()}
  end
end
