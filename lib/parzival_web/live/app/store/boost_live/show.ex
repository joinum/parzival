defmodule ParzivalWeb.App.BoostLive.Show do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Accounts
  alias Parzival.Store
  alias Parzival.Uploaders

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok, assign(socket, :id, id)}
  end

  @impl true
  def handle_params(%{"id" => _id}, _, socket) do
    {:noreply, reload(socket)}
  end

  @impl true
  def handle_event("delete", _payload, socket) do
    case Store.delete_boost(socket.assigns.boost) do
      {:ok, _boost} ->
        {:noreply,
         socket
         |> put_flash(:success, "Boost deleted successfully!")
         |> push_redirect(to: Routes.boost_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, elem(changeset.errors[:error], 0))
         |> assign(:changeset, changeset)}
    end
  end

  @impl true
  def handle_event("purchase", _payload, socket) do
    boost = socket.assigns.boost
    current_user = socket.assigns.current_user

    case Store.purchase_boost(current_user, boost) do
      {:ok, _boost} ->
        {:noreply,
         socket
         |> put_flash(:success, "Boost purchased successfully!")
         |> reload()}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_info({event, _changes}, socket) when event in [:boost_purchased, :boost_updated] do
    {:noreply, reload(socket)}
  end

  def handle_info({event, _changes}, socket) when event in [:boost_deleted] do
    {:noreply, push_redirect(socket, to: Routes.product_index_path(socket, :index))}
  end

  defp reload(socket) do
    id = socket.assigns.id

    socket
    |> assign(:current_page, :store)
    |> assign(
      inventory:
        Store.list_inventory(where: [user_id: socket.assigns.current_user.id], preloads: [:boost])
    )
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:boost, Store.get_boost!(id))
    |> assign(
      current_user:
        Accounts.get_user!(socket.assigns.current_user.id, [
          :company,
          :missions,
          inventory: [:boost]
        ])
    )
  end

  defp page_title(:show), do: "Show Boost"
  defp page_title(:edit), do: "Edit Boost"
end
