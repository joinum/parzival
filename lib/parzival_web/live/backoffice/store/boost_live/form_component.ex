defmodule ParzivalWeb.Backoffice.BoostLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  alias Parzival.Store
  @extensions_whitelist ~w(.jpg .jpeg .gif .png)

  @impl true
  def mount(socket) do
    {:ok, socket |> allow_upload(:image, accept: @extensions_whitelist, max_entries: 1)}
  end

  @impl true
  def update(%{boost: boost} = assigns, socket) do
    changeset = Store.change_boost(boost)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"boost" => boost_params}, socket) do
    changeset =
      socket.assigns.boost
      |> Store.change_boost(boost_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"boost" => boost_params}, socket) do
    save_boost(socket, socket.assigns.action, boost_params)
  end

  defp save_boost(socket, :edit, boost_params) do
    case Store.update_boost(socket.assigns.boost, boost_params) do
      {:ok, _boost} ->
        {:noreply,
         socket
         |> put_flash(:info, "Boost updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_boost(socket, :new, boost_params) do
    case Store.create_boost(boost_params) do
      {:ok, _boost} ->
        {:noreply,
         socket
         |> put_flash(:info, "Boost created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
