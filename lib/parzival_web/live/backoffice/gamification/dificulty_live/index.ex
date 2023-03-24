defmodule ParzivalWeb.Backoffice.DifficultyLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Gamification
  alias Parzival.Gamification.Mission.Difficulty

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
     |> assign(list_difficulties(params))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Difficulty")
    |> assign(:difficulty, Gamification.get_difficulty!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Difficulty")
    |> assign(:difficulty, %Difficulty{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Difficulties")
    |> assign(:difficulty, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    difficulty = Gamification.get_difficulty!(id)

    case Gamification.delete_difficulty(difficulty) do
      {:ok, _difficulty} ->
        {:noreply,
         socket
         |> put_flash(:success, "Difficulty deleted successfully!")
         |> assign(list_difficulties(%{}))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, elem(changeset.errors[:difficulties], 0))
         |> assign(:changeset, changeset)}
    end
  end

  @impl true
  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    params = build_search_map(socket.assigns.params, query)

    {:noreply, push_patch(socket, to: Routes.admin_difficulty_index_path(socket, :index, params))}
  end

  defp build_search_map(params, text) do
    filters =
      (params["filters"] || %{})
      |> Map.put("1", %{"field" => "search", "value" => text, "op" => "ilike_or"})

    Map.put(params, "filters", filters)
  end

  defp list_difficulties(params) do
    case Gamification.list_difficulties(params) do
      {:ok, {difficulties, meta}} ->
        %{difficulties: difficulties, meta: meta}

      {:error, flop} ->
        %{difficulties: [], meta: flop}
    end
  end
end
