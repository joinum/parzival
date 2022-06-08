defmodule ParzivalWeb.Backoffice.DificultyLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Gamification
  alias Parzival.Gamification.Mission.Dificulty

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :missions)
     |> assign(:params, params)
     |> assign(list_dificulties(params))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Dificulty")
    |> assign(:dificulty, Gamification.get_dificulty!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Dificulty")
    |> assign(:dificulty, %Dificulty{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Dificulties")
    |> assign(:dificulty, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    dificulty = Gamification.get_dificulty!(id)

    case Gamification.delete_dificulty(dificulty) do
      {:ok, _dificulty} ->
        {:noreply,
         socket
         |> put_flash(:success, "Dificulty deleted successfully!")
         |> assign(list_dificulties(%{}))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, elem(changeset.errors[:dificulties], 0))
         |> assign(:changeset, changeset)}
    end
  end

  @impl true
  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    params = build_search_map(socket.assigns.params, query)

    {:noreply, push_patch(socket, to: Routes.admin_dificulty_index_path(socket, :index, params))}
  end

  defp build_search_map(params, text) do
    filters =
      (params["filters"] || %{})
      |> Map.put("1", %{"field" => "search", "value" => text, "op" => "ilike_or"})

    Map.put(params, "filters", filters)
  end

  defp list_dificulties(params) do
    case Gamification.list_dificulties(params) do
      {:ok, {dificulties, meta}} ->
        %{dificulties: dificulties, meta: meta}

      {:error, flop} ->
        %{dificulties: [], meta: flop}
    end
  end
end
