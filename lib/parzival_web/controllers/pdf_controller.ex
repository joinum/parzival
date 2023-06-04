defmodule ParzivalWeb.PdfController do
  use ParzivalWeb, :controller

  require Integer

  alias Parzival.Accounts
  alias Parzival.Gamification
  alias Parzival.Companies
  alias Parzival.Uploaders.ProfilePicture

  defguard is_attendee?(conn) when conn.assigns.current_user.role == :attendee

  defguard is_recruiter_or_admin?(conn)
           when conn.assigns.current_user.role in [:recruiter, :admin]

  def download_cv(conn, _params) when is_attendee?(conn) do
    send_cv(conn, Accounts.get_user!(conn.assigns.current_user.id))
  end

  def download_cv(conn, %{"attendee_id" => attendee_id}) when is_recruiter_or_admin?(conn) do
    send_cv(conn, Accounts.get_user!(attendee_id))
  end

  def send_cv(conn, user) do
    curriculum = Gamification.get_user_curriculum(user)

    conn
    |> assign(:user, user)
    |> assign(:curriculum, curriculum)
    |> assign(:avatar, ProfilePicture.url({user.picture, user}, :medium))
    |> render_pdf("cv.pdf", filename: "#{normalize_name(user.name)}_cv.pdf")
  end

  def preview_cv(conn, _params) do
    preview_document(conn, "cv_name")
  end

  defp normalize_name(name) do
    name
    |> String.normalize(:nfd)
    |> String.replace(~r/[^A-z\s]/u, "")
    |> String.replace(" ", "_")
    |> String.downcase()
  end

  defp render_pdf(conn, template, opts) when is_list(opts) do
    conn
    |> put_resp_content_type("application/pdf")
    |> put_resp_header("content-disposition", "attachment; filename=\"#{opts[:filename]}\"")
    |> render(template)
  end

  defp preview_document(conn, name) do
    conn
    |> put_root_layout(:pdf)
    # No live nor app layout for document
    |> put_layout({ParzivalWeb.LayoutView, :pdf})
    |> render("#{name}.html")
  end

  def download_pdfs(conn, company_id) do
    IO.inspect(company_id)
    users = Companies.get_company_connections(company_id)
    IO.inspect(users)
    # get all users with a cv
    users_with_cv = Enum.filter(users, fn user ->
      Gamification.get_user_curriculum(user) != nil
    end)

    IO.inspect(users_with_cv)

  end
end
