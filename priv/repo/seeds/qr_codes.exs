defmodule Parzival.Repo.Seeds.QRCodes do
  alias Parzival.Repo

  alias Parzival.Accounts.QRCode

  require Logger

  def run do
    seed_qrs(100)
  end

  def seed_qrs(n) do
    case Repo.all(QRCode) do
      [] ->
        for _i <- 1..n do
          uuid = %{uuid: Ecto.UUID.generate()}

          %QRCode{}
          |> QRCode.changeset(uuid)
          |> Repo.insert()

          Logger.info(uuid.uuid)
        end

      _ ->
        Mix.shell().error("Found qr codes, aborting seeding qr codes.")
    end
  end
end

Parzival.Repo.Seeds.QRCodes.run()
