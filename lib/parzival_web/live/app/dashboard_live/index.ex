defmodule ParzivalWeb.App.DashboardLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Accounts
  alias Parzival.Companies
  alias Parzival.Gamification
  alias Parzival.Tools
  alias Parzival.Tools.Post

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
         |> assign(list_applications(params, socket))}

      _ ->
        {:noreply,
         socket
         |> assign(:current_page, :dashboard)
         |> assign(:page_title, "Dashboard")
         |> assign(:user, user)
         |> assign(list_top_users(params))
         |> assign(list_posts(params))
         |> assign(:changeset, Tools.change_post(%Post{}))
         |> assign(:announcements, list_announcements())}
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
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Tools.change_post(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    post_params =
      post_params
      |> Map.put("author_id", socket.assigns.current_user.id)

    save_post(socket, post_params)
  end

  # defp save_post(socket, :edit, post_params) do
  #   case Tools.update_post(socket.assigns.post, post_params) do
  #     {:ok, _post} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:success, "Post updated successfully")

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, :changeset, changeset)}
  #   end
  # end

  defp save_post(socket, post_params) do
    case Tools.create_post(post_params) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:success, "Post created successfully")
         |> assign(:changeset, Tools.change_post(%Post{}))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_info({event, _post}, socket) when event in [:new_post] do
    {:noreply, assign(socket, list_posts(socket.assigns.params))}
  end
end
