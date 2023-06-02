defmodule Parzival.Tasks do
  @moduledoc """
  Tasks for Parzival
  """
  @app :parzival

  alias Parzival.Accounts.QRCode
  alias Parzival.Repo

  @doc """
  Will generate `number_of_qrs` QR codes and save them to the `qrs` directory. A CSV file will also be generated with the codes.
  """
  def generate_qrs(number_of_qrs) do
    load_app()

    if !File.exists?("qrs") do
      File.mkdir!("qrs")
    end

    codes =
      1..(number_of_qrs + 1)
      |> Enum.map(fn n ->
        index =
          n
          |> Integer.to_string()
          |> String.pad_leading(4, "0")

        code = Ecto.UUID.generate()

        qr =
          "https://parzival-stg.fly.dev/profile/#{code}"
          |> QRCodeEx.encode()
          |> QRCodeEx.png(width: 460)

        File.write("qrs/#{index}.png", qr, [:binary])

        "#{index},#{code}"
      end)

    File.write("codes.csv", Enum.join(codes, "\n"))
  end

  @doc """
  Will insert the QR codes from the CSV file into the database.
  """
  def insert_qrs(filename) do
    load_app()

    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.each(fn lines ->
      [_index, code] = String.split(lines, ",", trim: true)

      %QRCode{}
      |> QRCode.changeset(%{uuid: code})
      |> Repo.insert()
    end)
  end

  defp load_app do
    Application.ensure_all_started(:ssl)
    Application.load(@app)
  end
end
