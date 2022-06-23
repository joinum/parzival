codes =
  1..1000
  |> Enum.map(fn n ->
    index =
      n
      |> Integer.to_string
      |> String.pad_leading(4, "0")

    code = Ecto.UUID.generate()

    qr =
      "https://join.di.uminho.pt/profile/#{code}"
      |> QRCodeEx.encode()
      |> QRCodeEx.svg(shape: "circle", width: 460)

    File.write("qrs/#{index}.svg", qr, [:binary])

    "#{index},#{code}"
    |> IO.inspect
  end)

File.write("codes.csv", Enum.join(codes, "\n"))
