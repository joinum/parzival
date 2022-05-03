defmodule ParzivalWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  alias ParzivalWeb.Router.Helpers, as: Routes

  @conn ParzivalWeb.Endpoint

  def pages(conn, current_user) do
    live_pages(conn) ++ role_pages(conn, current_user.role)
  end

  def role_pages(conn, role) do
    case role do
      :admin -> admin_pages(conn)
      :attendee -> attendee_pages(conn)
    end
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
      },
      %{
        key: :login,
        title: "Login",
        url: Routes.user_session_path(@conn, :new),
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
      }
    ]
  end

  def attendee_pages(conn) do
    [
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
      }
    ]
  end

  def admin_pages(conn) do
    [
      %{
        key: :store,
        title: "Store",
        url: Routes.product_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :accounts,
        title: "Accounts",
        url:
          Routes.admin_user_index_path(conn, :index, %{
            "filters" => %{"0" => %{"field" => "role", "value" => "attendee"}}
          }),
        tabs: [
          %{
            key: :student,
            title: "Attendees",
            url:
              Routes.admin_user_index_path(conn, :index, %{
                "filters" => %{"0" => %{"field" => "role", "value" => "attendee"}}
              })
          },
          %{
            key: :admin,
            title: "Admins",
            url:
              Routes.admin_user_index_path(conn, :index, %{
                "filters" => %{"0" => %{"field" => "role", "value" => "admin"}}
              })
          },
          %{
            key: :staff,
            title: "Staff",
            url:
              Routes.admin_user_index_path(conn, :index, %{
                "filters" => %{"0" => %{"field" => "role", "value" => "staff"}}
              })
          },
          %{
            key: :company,
            title: "Companies",
            url:
              Routes.admin_user_index_path(conn, :index, %{
                "filters" => %{"0" => %{"field" => "role", "value" => "company"}}
              })
          }
        ]
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
