defmodule ParzivalWeb.Components.Boost do
  @moduledoc false
  use ParzivalWeb, :live_component

  alias Parzival.Store
  alias Parzival.Uploaders

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-12 h-12">
      <%= if ! @item.expires_at do %>
        <%= if @item.boost.type in [:exp, :tokens] do %>
          <button phx-click="activate-boost" phx-value-item_id={@item.id} phx-target={@myself} data-confirm={"Are you sure you wanna activate #{assigns.item.boost.name}? #{assigns.item.boost.description}."}>
            <img src={Uploaders.BoostImage.url({@item.boost.image, @item.boost}, :original)} class="object-cover object-center w-full h-full lg:w-full lg:h-full hover:opacity-70" />
          </button>
        <% else %>
          <img src={Uploaders.BoostImage.url({@item.boost.image, @item.boost}, :original)} class="object-cover object-center w-full h-full lg:w-full lg:h-full" />
        <% end %>
      <% else %>
        <div class="relative">
          <span class="absolute w-full h-full bg-red-500 opacity-75 animate-ping" />
          <img src={Uploaders.BoostImage.url({@item.boost.image, @item.boost}, :original)} class="object-cover object-center w-full h-full lg:w-full lg:h-full" />
        </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_event("activate-boost", %{"item_id" => item_id}, socket) do
    user_id = socket.assigns.item.user_id

    if Store.already_has_active_boost?(user_id) do
      send(self(), {:error, "You already have an active boost."})
      {:noreply, socket}
    else
      item = Store.get_item!(item_id)
      Store.update_item(item, %{expires_at: Timex.shift(NaiveDateTime.utc_now(), minutes: 60)})

      send(self(), {:info, "Boost activated!"})

      {:noreply,
       socket
       |> assign(
         inventory: Store.list_inventory(where: [user_id: item.user_id], preloads: [:boost])
       )}
    end
  end
end
