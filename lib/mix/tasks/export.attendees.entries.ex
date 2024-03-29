defmodule Mix.Tasks.Export.Attendees.Entries do
  @moduledoc """
  Task to export the entries for the final draw to a CSV.

  Run it as mix export.attendees.entries data/entries.csv Aggregate
  to have one row per attendee (with the number of entries in it)
  Run it as mix export.attendees.entries data/entries.csv Separate to have
  one row per entry (this is needed to run the draw in random.org, for example)

  As this script writes to a file, you need to run it in your local machine pointing
  to the production database.
  """

  use Mix.Task
  alias Parzival.Accounts
  alias Parzival.Gamification

  def run(args) do
    Mix.Task.run("app.start")

    cond do
      length(args) != 2 ->
        Mix.shell().info(
          "Needs to receive a path to write the file to and whether to aggregate the entries"
        )

      args |> List.last() == "Aggregate" ->
        write_csv(List.first(args), :aggregate)

      args |> List.last() == "Separate" ->
        write_csv(List.first(args), :separate)

      true ->
        Mix.shell().info("Second argument must be equal to Aggregate or Separate")
    end
  end

  defp write_csv(file, mode) do
    users = Accounts.list_users([]) |> Enum.filter(fn user -> user.role == :attendee end)
    tasks_user = Gamification.list_tasks_users([])

    data =
      users
      |> Enum.map(fn at -> csv_io(at, tasks_user, mode) end)
      |> List.flatten()
      |> Enum.with_index()
      |> Enum.map(fn {entry, index} -> "#{index + 1},#{entry}" end)
      |> add_header(mode)
      |> Enum.intersperse("\n")
      |> List.flatten()

    File.write!(file, data)
  end

  defp csv_io(attendee, tasks_user, :separate) do
    attendee_entries = Enum.count(Enum.filter(tasks_user, fn tu -> tu.user_id == attendee.id end))

    Enum.to_list(1..attendee_entries)
    |> Enum.map(fn _x -> "#{attendee.name},#{attendee.email}, #{attendee_entries}" end)
  end

  defp csv_io(attendee, tasks_user, :aggregate) do
    attendee_entries = Enum.count(Enum.filter(tasks_user, fn tu -> tu.user_id == attendee.id end))

    if attendee_entries > 0 do
      [
        "#{attendee.name},#{attendee.email},#{attendee_entries}"
      ]
    else
      []
    end
  end

  defp add_header(list, _) do
    ["id,name,email,entries" | list]
  end
end
