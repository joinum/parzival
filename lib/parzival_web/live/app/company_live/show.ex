defmodule ParzivalWeb.App.CompanyLive.Show do
  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Accounts
  alias Parzival.Companies

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
     |> assign(:company, Companies.get_company!(id))
     |> assign(:params, params)
     |> assign(list_offers(params))
     |> assign(list_recruiters(params))}
  end

  defp list_offers(%{"id" => id} = params) do
    params =
      params
      |> Map.put("limit", 6)

        case Companies.list_offers(
               params,
               [preloads: [:company, :offer_type, :offer_time], where: [company_id: id]]
             ) do
          {:ok, {offers, meta}} ->
            %{offers: offers, meta: meta}

          {:error, flop} ->
            %{offers: [], meta: flop}
        end
  end

  defp list_recruiters(%{"id" => id} = params) do
    params =
      params
      |> Map.put("limit", 4)

    case Accounts.list_users(
          params,
          [preloads: :company, where: [company_id: id]]
        ) do
      {:ok, {recruiters, meta}} ->
        %{recruiters: recruiters, meta: meta}

      {:error, flop} ->
        %{recruiters: [], meta: flop}
    end
  end

end
