defmodule ParzivalWeb.App.DashboardLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Accounts
  alias Parzival.Companies
  alias Parzival.Gamification
  alias Parzival.Tools
  alias Parzival.Tools.Post

  import ParzivalWeb.Components.Curriculum
  import ParzivalWeb.Components.Pagination

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Tools.subscribe("new_post")
    end

    {:ok, socket}
  end

  @impl true

  def handle_params(params, _url, socket) do
    user = Accounts.get_user!(socket.assigns.current_user.id, [:company, :curriculum])

    case user.role do
      :attendee ->
        {:noreply,
         socket
         |> assign(:current_page, :dashboard)
         |> assign(:page_title, "Dashboard")
         |> assign(:announcements, list_announcements())
         |> assign(:user, user)
         |> assign(:params, params)
         |> assign(:curriculum, Gamification.get_user_curriculum(user, []))
         |> assign(list_top_users(params))
         |> assign(list_posts(params))
         |> assign(:post, %Post{})
         |> assign(:action, :new)
         |> assign(:changeset, Tools.change_post(%Post{}))
         |> assign(list_applications(params, socket))
         |> assign(:params, params)}

      _ ->
        {:noreply,
         socket
         |> assign(:current_page, :dashboard)
         |> assign(:page_title, "Dashboard")
         |> assign(:user, user)
         |> assign(list_top_users(params))
         |> assign(list_posts(params))
         |> assign(:changeset, Tools.change_post(%Post{}))
         |> assign(:announcements, list_announcements())
         |> assign(:params, params)}
    end
  end

  defp list_top_users(params) do
    params =
      params
      |> Map.put("page_size", 3)

    case Accounts.list_users(
           params,
           where: [role: :attendee],
           order_by: [desc: :exp]
         ) do
      {:ok, {users, _}} ->
        %{users: users}

      {:error, _} ->
        %{users: []}
    end
  end

  defp list_applications(params, socket) do
    case Companies.list_applications(
           params,
           preloads: [:offer],
           where: [user_id: socket.assigns.current_user.id]
         ) do
      {:ok, {applications, meta}} ->
        %{applications: applications, meta: meta}

      {:error, flop} ->
        %{applications: [], meta: flop}
    end
  end

  defp list_posts(params) do
    case Tools.list_posts(
           params,
           preloads: [:author, offer: [:company]]
         ) do
      {:ok, {posts, meta}} ->
        %{posts: posts, meta: meta}

      {:error, flop} ->
        %{posts: [], meta: flop}
    end
  end

  defp list_announcements do
    Tools.list_announcements(preloads: [:author], limit: 2, order_by: [desc: :inserted_at])
  end

  @impl true
  def handle_info({event, _post}, socket) when event in [:new_post] do
    {:noreply, assign(socket, list_posts(socket.assigns.params))}
  end

  @impl true
  def handle_info({:error, reason}, socket) do
    {:noreply,
     socket
     |> put_flash(:error, reason)}
  end
end
