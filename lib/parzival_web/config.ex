defmodule ParzivalWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  alias ParzivalWeb.Router.Helpers, as: Routes

  @conn ParzivalWeb.Endpoint

  def pages(conn, _current_user) do
    live_pages(conn)
  end

  def pages do
    base_pages()
  end

  defp base_pages do
    [
      %{
        key: :home,
        title: "Home",
        url: Routes.landing_home_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :schedule,
        title: "Schedule",
        url: Routes.landing_schedule_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :missions,
        title: "Missions",
        url: Routes.landing_missions_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :speakers,
        title: "Speakers",
        url: Routes.landing_speakers_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :faqs,
        title: "Faqs",
        url: Routes.landing_faqs_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :team,
        title: "Team",
        url: Routes.landing_team_index_path(@conn, :index),
        tabs: []
      }
    ]
  end

  defp live_pages(conn) do
    [
      %{
        key: :home,
        title: "Home",
        url: Routes.home_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :store,
        title: "Store",
        url: Routes.product_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :vault,
        title: "Vault",
        url: Routes.order_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :tools,
        title: "Tools",
        url: Routes.admin_faqs_index_path(conn, :index),
        tabs: [
          %{
            key: :faqs,
            title: "FAQs",
            url: Routes.admin_faqs_index_path(conn, :index)
          },
          %{
            key: :announcements,
            title: "Announcements",
            url: Routes.announcement_index_path(conn, :index)
          }
        ]
      }
    ]
  end
end
