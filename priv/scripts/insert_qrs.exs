# $ cat codes.csv
# 0001,2f172-b285-4afd-89b9-31cbaca0aa6a
# 0002,577e7618-5398-4954-9aa2-6af351923ec5
# 0003,6877f018-d1de-4d99-aad9-2aea602e5a03
#
# $ mix run priv/scripts/insert_qrs.exs
alias Parzival.Repo
alias Parzival.Accounts.QRCode

"codes.csv"
|> File.read!()
|> String.split("\n")
|> Enum.each(fn lines ->
  [_index, code] = String.split(lines, ",", trim: true)

  %QRCode{}
  |> QRCode.changeset(%{uuid: code})
  |> Repo.insert()
end)
