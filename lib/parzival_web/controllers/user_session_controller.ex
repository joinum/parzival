defmodule ParzivalWeb.UserSessionController do
  use ParzivalWeb, :controller

  alias Parzival.Accounts
  alias ParzivalWeb.UserAuth

  def new(conn, _params) do
    conn
    |> put_layout(false)
    |> render("new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_layout(false)
      |> render("new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "")
    |> UserAuth.log_out_user()
  end
end
