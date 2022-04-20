defmodule ParzivalWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  alias ParzivalWeb.Router.Helpers, as: Routes

  def pages(conn, current_user) do
    base_pages(conn)
  end

  defp base_pages(conn) do
    [
      %{
        key: :home,
        title: "Home",
        url: Routes.home_index_path(conn, :index),
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
