defmodule ParzivalWeb.App.ProfileLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  alias Parzival.Accounts
  alias Parzival.Accounts.User
  alias Parzival.Companies

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
    companies = Companies.list_companies([]) |> get_names()

    role =
      if Map.has_key?(assigns, :role) do
        assigns.role
      else
        user.role
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:role, role)
     |> assign(:companies, companies)
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
         |> push_redirect(to: build_return_to(socket))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_user(socket, :new, user_params) do
    if not is_nil(user_params["company_id"]) and String.length(user_params["company_id"]) != 0 do
      company =
        Companies.list_companies([])
        |> Enum.find(fn company -> company.name == user_params["company_id"] end)

      user_params = Map.put(user_params, "company_id", company.id)

      case Accounts.admin_create_user(
             user_params,
             &consume_picture_data(socket, &1),
             socket.assigns.role
           ) do
        {:ok, _user} ->
          {:noreply,
           socket
           |> put_flash(:success, "User created successfully")
           |> push_redirect(to: build_return_to(socket))}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
      end
    else
      case Accounts.admin_create_user(
             user_params,
             &consume_picture_data(socket, &1),
             socket.assigns.role
           ) do
        {:ok, _user} ->
          {:noreply,
           socket
           |> put_flash(:success, "User created successfully")
           |> push_redirect(to: build_return_to(socket))}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
      end
    end
  end

  defp build_return_to(socket) do
    if String.starts_with?(socket.assigns.return_to, "/app/profile") do
      socket.assigns.return_to
    else
      build_return_to_path(socket)
    end
  end

  defp build_return_to_path(socket) do
    case socket.assigns.role do
      :recruiter ->
        Routes.admin_user_index_path(socket, :index, %{
          "filters" => %{"0" => %{"field" => "role", "value" => "recruiter"}}
        })

      :staff ->
        Routes.admin_user_index_path(socket, :index, %{
          "filters" => %{"0" => %{"field" => "role", "value" => "staff"}}
        })

      :admin ->
        Routes.admin_user_index_path(socket, :index, %{
          "filters" => %{"0" => %{"field" => "role", "value" => "admin"}}
        })

      _ ->
        Routes.admin_user_index_path(socket, :index, %{
          "filters" => %{"0" => %{"field" => "role", "value" => "attendee"}}
        })
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

  defp get_names(companies) do
    Enum.map(companies, fn company -> company.name end)
  end
end
