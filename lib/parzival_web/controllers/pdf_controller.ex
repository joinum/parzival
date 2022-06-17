defmodule ParzivalWeb.App.PdfController do
  use ParzivalWeb, :controller

  alias Parzival.Accounts
  alias Parzival.Gamification
  alias Parzival.Uploaders.ProfilePicture

  require Integer

  def cv(conn, _params) do
    current_user = Accounts.get_user!(conn.assigns.current_user.id)

    curriculum = Gamification.get_user_curriculum(current_user)

    conn
    |> assign(:user, current_user)
    |> assign(:curriculum, curriculum)
    |> assign(
      :profile_picture,
      ProfilePicture.url({current_user.picture, current_user}, :original)
    )
    |> render_document("cv", "#{current_user.name} CV")
  end

  def cv_preview(conn, _params) do
    preview_document(conn, "cv_name")
  end

  defp render_document(conn, name, file_name) do
    conn
    |> put_resp_content_type("application/pdf")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=\"#{file_name}.pdf\""
    )
    |> render("#{name}.pdf")
  end

  defp preview_document(conn, name) do
    conn
    |> put_root_layout(:pdf)
    # No live nor app layout for document
    |> put_layout({ParzivalWeb.LayoutView, :pdf})
    |> render("#{name}.html")
  end
end
