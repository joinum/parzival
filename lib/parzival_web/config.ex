defmodule ParzivalWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  alias ParzivalWeb.Router.Helpers, as: Routes

  def pages(conn, _current_user) do
    live_pages(conn)
  end

  def pages(conn) do
    base_pages(conn)
  end

  defp base_pages(conn) do
    [
      %{
        key: :home,
        title: "Home",
        url: Routes.home_path(conn, :index),
        tabs: []
      },
      %{
        key: :schedule,
        title: "Schedule",
        url: Routes.schedule_path(conn, :index),
        tabs: []
      },
      %{
        key: :missions,
        title: "Missions",
        url: Routes.missions_path(conn, :index),
        tabs: []
      },
      %{
        key: :speakers,
        title: "Speakers",
        url: Routes.speakers_path(conn, :index),
        tabs: []
      },
      %{
        key: :faqs,
        title: "Faqs",
        url: Routes.faqs_path(conn, :index),
        tabs: []
      },
      %{
        key: :team,
        title: "Team",
        url: Routes.team_path(conn, :index),
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
        url: Routes.faqs_index_path(conn, :index),
        tabs: [
          %{
            key: :faqs,
            title: "FAQs",
            url: Routes.faqs_index_path(conn, :index)
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
