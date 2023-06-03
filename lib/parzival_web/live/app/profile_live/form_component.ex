defmodule ParzivalWeb.App.ProfileLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  alias Parzival.Accounts
  alias Parzival.Accounts.User

  @extensions_whitelist ~w(.jpg .jpeg .gif .png)
  @cycles [:Bachelors, :Masters, :Phd]

  defguard is_admin?(socket) when socket.assigns.current_user.role == :admin
  defguard is_current_user?(socket, id) when socket.assigns.current_user.id == id

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> allow_upload(:picture, accept: @extensions_whitelist, max_entries: 1)}
  end

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:user, user)
     |> assign(:cycles, @cycles)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      %User{}
      |> Accounts.change_user(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    save_user(socket, socket.assigns.action, user_params)
  end

  defp save_user(socket, :edit, user_params)
       when is_admin?(socket) or is_current_user?(socket, socket.assigns.user.id) do
    case Accounts.admin_change_user_info(
           socket.assigns.user,
           user_params,
           &consume_picture_data(socket, &1)
         ) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:success, "User updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_user(socket, :new, user_params) do
    case Accounts.admin_create_user(
           user_params,
           &consume_picture_data(socket, &1),
           socket.assigns.role
         ) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:success, "User created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp consume_picture_data(socket, user) do
    consume_uploaded_entries(socket, :picture, fn %{path: path}, entry ->
      Accounts.admin_update_user_picture(user, %{
        "picture" => %Plug.Upload{
          content_type: entry.client_type,
          filename: entry.client_name,
          path: path
        }
      })
    end)
    |> case do
      [{:ok, user}] ->
        {:ok, user}

      _errors ->
        {:ok, user}
    end
  end
end
