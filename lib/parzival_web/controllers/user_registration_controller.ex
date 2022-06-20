defmodule ParzivalWeb.UserRegistrationController do
  use ParzivalWeb, :controller

  alias Parzival.Accounts
  alias Parzival.Accounts.{QRCode,User}
  alias ParzivalWeb.UserAuth

  def new(conn, %{"qr" => qr_value}) do
    qr_code = Accounts.get_qr_code(qr_value)

    case qr_code do
      %QRCode{} ->
        changeset = Accounts.change_user_registration(%User{}, %{qrcode: qr_code})
        conn
        |> put_layout(false)
        |> render("new.html", changeset: changeset)
      _ ->
        conn
        |> put_layout(false)
        |> render("404.html", changeset: nil)
    end
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "User created successfully!")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
