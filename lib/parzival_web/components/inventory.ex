defmodule ParzivalWeb.Components.Inventory do
  @moduledoc false
  use ParzivalWeb, :live_component

  alias Parzival.Store

  @impl true
  def render(assigns) do
    ~H"""
    <span>
      <p class="text-gray-500">
        <%= "Inventory (#{length(@inventory)}/5)" %>
      </p>
      <div class="grid grid-cols-5 gap-2">
        <%= for i <- 1..5 do %>
          <%= if i > length(@inventory) do %>
            <div class="w-12 h-12 border border-gray-200" />
          <% else %>
            <.live_component module={ParzivalWeb.Components.Boost} id={Enum.at(@inventory, i - 1).id} item={Enum.at(@inventory, i - 1)} flash={@flash} />
          <% end %>
        <% end %>
      </div>

      <%= for item <- @inventory do %>
        <%= if item.expires_at do %>
          <div class="flex justify-between items-center mt-2 text-gray-900">
            <span><%= item.boost.name %></span>
            <div class="flex gap-x-1 items-center">
              <span><%= relative_datetime_in_digital_clock_format(item.expires_at) %></span>
              <span phx-target={@myself} phx-click="terminate-boost" phx-value-item_id={item.id} class="cursor-pointer" data-confirm="Are you sure you want to terminate this boost?">
                <svg class="w-5 h-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0"
                  />
                </svg>
              </span>
            </div>
          </div>
        <% end %>
      <% end %>
    </span>
    """
  end

  @impl true
  def handle_event("terminate-boost", %{"item_id" => item_id}, socket) do
    case Store.terminate_boost(item_id) do
      {:ok, item} ->
        send(self(), {:info, "Boost terminated!"})

        {:noreply,
         socket
         |> assign(
           inventory: Store.list_inventory(where: [user_id: item.user_id], preloads: [:boost])
         )}

      {:error, _reason} ->
        send(
          self(),
          {:error,
           "There was an error while trying to terminate the boost. Please try again later."}
        )

        {:noreply, socket}
    end
  end
end
