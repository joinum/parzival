defmodule ParzivalWeb.App.CompanyLive.Show do
  @moduledoc false
  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Accounts
  alias Parzival.Companies
  alias Parzival.Uploaders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :companies)
     |> assign(:page_title, "Show company")
     |> assign(:company, Companies.get_company!(id, preloads: :level))
     |> assign(:params, params)
     |> assign(:recruiters, list_recruiters(params))
     |> assign(list_offers(params))}
  end

  @impl true
  def handle_event("delete", _payload, socket) do
    case Companies.delete_company(socket.assigns.company) do
      {:ok, _company} ->
        {:noreply,
         socket
         |> put_flash(:success, "Company deleted successfully!")
         |> push_redirect(to: Routes.company_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, elem(changeset.errors[:error], 0))
         |> assign(:changeset, changeset)}
    end
  end

  defp list_offers(%{"id" => id} = params) do
    params =
      params
      |> Map.put("page_size", 6)

    case Companies.list_offers(
           params,
           preloads: [:company, :offer_type, :offer_time],
           where: [company_id: id]
         ) do
      {:ok, {offers, meta}} ->
        %{offers: offers, offers_meta: meta}

      {:error, flop} ->
        %{offers: [], offers_meta: flop}
    end
  end

  defp list_recruiters(%{"id" => id}) do
    Accounts.list_users(
      preloads: :company,
      where: [company_id: id]
    )
  end
end
