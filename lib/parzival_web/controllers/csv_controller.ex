defmodule ParzivalWeb.CsvController do
  use ParzivalWeb, :controller

  alias Parzival.Accounts
  alias Parzival.Gamification

  defguard is_admin?(conn) when conn.assigns.current_user.role == :admin

  def create(conn, _params) when is_admin?(conn) do
    data = write_csv()

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"export_entries.csv\"")
    |> put_root_layout(false)
    |> send_resp(200, data)
  end

  defp write_csv do
    users = Accounts.list_users([]) |> Enum.filter(fn user -> user.role == :attendee end)
    tasks_user = Gamification.list_tasks_users([])

    users
    |> Enum.map(fn at -> csv_io(at, tasks_user, :separate) end)
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.map(fn {entry, index} -> "#{index + 1},#{entry}" end)
    |> add_header()
    |> Enum.intersperse("\n")
    |> Enum.to_list()
    |> to_string()
  end

  defp csv_io(attendee, tasks_user, :separate) do
    attendee_entries = Enum.count(Enum.filter(tasks_user, fn tu -> tu.user_id == attendee.id end))

    if attendee_entries > 0 do
      Enum.to_list(1..attendee_entries)
      |> Enum.map(fn _x -> "#{attendee.name},#{attendee.email}, #{attendee_entries}" end)
    else
      []
    end
  end

  defp add_header(list) do
    ["id,name,email,entries" | list]
  end
end
