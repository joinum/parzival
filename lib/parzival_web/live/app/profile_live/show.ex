defmodule ParzivalWeb.App.ProfileLive.Show do
  @moduledoc false
  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Buttons
  import ParzivalWeb.Components.Curriculum

  alias Parzival.Accounts
  alias Parzival.Companies
  alias Parzival.Gamification
  alias Parzival.Uploaders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"qr" => qr}, _url, socket) do
    user = Accounts.get_user_by_qr(qr)

    if Map.has_key?(socket.assigns, :current_user) and not is_nil(user) do
      if socket.assigns.current_user.role == :recruiter && user.role == :attendee do
        company = Companies.get_company!(socket.assigns.current_user.company_id)

        case Companies.create_connection(company, user) do
          {:ok, _connection} ->
            {:noreply,
             socket
             |> put_flash(:success, gettext("New Connection!"))}

          {:error, _error} ->
            {:noreply, socket}
        end
      end
    else
      if is_nil(user) do
        {:noreply,
         socket
         |> push_redirect(to: Routes.user_registration_path(socket, :new, qr))}
      else
        {:noreply,
         socket
         |> push_redirect(to: Routes.profile_show_path(socket, :show, user.id))}
      end
    end
  end

  @impl true
  def handle_params(%{"id" => id} = params, _url, socket) do
    user = Accounts.get_user!(id, [:company])

    if socket.assigns.current_user.role == :recruiter && user.role == :attendee do
      company = Companies.get_company!(socket.assigns.current_user.company_id)

      case Companies.create_connection(company, user) do
        {:ok, _connection} ->
          {:noreply,
           socket
           |> put_flash(:success, gettext("New Connection!"))}

        {:error, _error} ->
          {:noreply, socket}
      end
    end

    {:noreply,
     socket
     |> assign(:current_page, :profile)
     |> assign(:current_tab, user.role)
     |> assign(:page_title, "Show User")
     |> assign(:params, params)
     |> assign(:user, user)
     |> handle_user_role(user)
     |> handle_current_user_role(socket.assigns.current_user)}
  end

  defp handle_user_role(socket, user) do
    case user.role do
      :recruiter ->
        if user.company do
          socket
          |> assign(:recruiters, list_recruiters(user.company.id))
        else
          socket
          |> assign(:recruiters, [])
        end

      :attendee ->
        socket
        |> assign(:curriculum, Gamification.get_user_curriculum(user))

      _ ->
        socket
    end
  end

  defp handle_current_user_role(socket, user) do
    case user.role do
      :staff ->
        socket
        |> assign(
          :connections,
          Companies.list_connections(
            where: [user_id: socket.assigns.user.id],
            preloads: :company
          )
        )

      :admin ->
        socket
        |> assign(
          :connections,
          Companies.list_connections(
            where: [user_id: socket.assigns.user.id],
            preloads: :company
          )
        )

      _ ->
        socket
    end
  end

  @impl true
  def handle_event("delete", _payload, socket) do
    {:ok, _} = Accounts.delete_user(socket.assigns.user)

    {:noreply,
     push_redirect(socket,
       to:
         Routes.admin_user_index_path(socket, :index, %{
           "filters" => %{"0" => %{"field" => "role", "value" => socket.assigns.user.role}}
         })
     )}
  end

  defp list_recruiters(id) do
    Accounts.list_users(
      preloads: :company,
      where: [company_id: id]
    )
  end

  defp draw_qr_code(profile) do
    internal_route = Routes.profile_show_path(ParzivalWeb.Endpoint, :show, profile.id)
    url = build_url() <> internal_route

    qrcode =
      url
      |> QRCodeEx.encode()
      |> QRCodeEx.svg(color: "#1F2937", width: 295, background_color: :transparent)

    {qrcode, url}
  end

  defp build_url do
    "https://#{Application.fetch_env!(:parzival, ParzivalWeb.Endpoint)[:url][:host]}"
  end
end
