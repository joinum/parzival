defmodule ParzivalWeb.App.ProfileLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Accounts
  alias Parzival.Gamification

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _url, socket) do
    user = Accounts.get_user!(id, [:company])

    case user.role do
      :recruiter ->
        {:noreply,
         socket
         |> assign(:current_page, :accounts)
         |> assign(:current_tab, user.role)
         |> assign(:page_title, "Show User")
         |> assign(:params, params)
         |> assign(:recruiters, list_recruiters(user.company.id))
         |> assign(:user, user)}

      :attendee ->
        {:noreply,
         socket
         |> assign(:current_page, :accounts)
         |> assign(:current_tab, user.role)
         |> assign(:page_title, "Show User")
         |> assign(:params, params)
         |> assign(:curriculum, Gamification.get_user_curriculum(user, []))
         |> assign(:user, user)}

      _ ->
        {:noreply,
         socket
         |> assign(:current_page, :accounts)
         |> assign(:current_tab, user.role)
         |> assign(:page_title, "Show User")
         |> assign(:params, params)
         |> assign(:user, user)}
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
end
