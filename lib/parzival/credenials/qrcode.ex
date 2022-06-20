defmodule Parzival.Credentialas.QRCode do
  @moduledoc """
  A qrcode found in the credentials for the attendees during the event
  """
  use Parzival.Schema

  alias Parzival.Accounts

  @required_fields ~w(uuid)a

  schema "qrcodes" do
    field :uuid, :binary_id

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(qr_code, attrs) do
    qr_code
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
