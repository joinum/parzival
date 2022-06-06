defmodule ParzivalWeb.Backoffice.UserLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  alias Parzival.Accounts
  alias Parzival.Accounts.User

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user(user)

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"user" => user}, socket) do
    #case (user, socket) do
    #  {:ok, _user} -> {:noreply,
    #    socket
    #    |> put_flash(:success, "User updated successfully!")
    #    |> push_redirect(to: socket.assigns.return_to)}
#
    #  {:error, %Ecto.Changeset{} = changeset} ->
    #    {:noreply, assign(socket, :changeset, changeset)}
    #end
    save_user(socket, socket.assigns.action, user)
  end

  def handle_event("validate", %{"user" => params}, socket) do
    # params
    # |> Map.put(:password, socket.assigns.user.password)
    # |> Map.put(:role, socket.assigns.user.role)

    changeset =
      %User{}
      |> Accounts.change_user(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  defp save_user(socket, :edit, user_params) do
    case Accounts.admin_update_user(socket.assigns.user, user_params) do
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
    case Accounts.admin_create_user(user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:success, "User updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
