defmodule ParzivalWeb.UserRegistrationController do
  use ParzivalWeb, :controller

  alias Parzival.Accounts
  alias Parzival.Accounts.{QRCode, User}
  alias ParzivalWeb.UserAuth

  def new(conn, %{"qr" => qr_value}) do
    qr_code = Accounts.get_qr_code(qr_value)

    case qr_code do
      %QRCode{} ->
        changeset = Accounts.change_user_registration(%User{}, %{qrcode_id: qr_code.id})
        conn
        |> put_layout(false)
        |> render("new.html", changeset: changeset, qr: qr_code.uuid)
      _ ->
        conn
        |> put_layout(false)
        |> render("404.html", changeset: nil)
    end
  end
  require Logger
  def create(conn, %{"user" => user_params, "qr" => qr}) do

    qr_code = Accounts.get_qr_code(qr)

    user_params = user_params
    |> Map.put("role", :attendee)
    |> Map.put("qrcode_id", qr_code.id)

    Logger.info (user_params)
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        Logger.info("Aqui")
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "User created successfully!")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.info("Merda")
        Logger.info(changeset)
        render(conn, "new.html", changeset: changeset, qr: qr, current_page: "Register")
    end
  end
end
