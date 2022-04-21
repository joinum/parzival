defmodule ParzivalWeb.HomeView do
  use ParzivalWeb, :view

  def get_next_activity(schedule, day) do
    now = NaiveDateTime.utc_now()

    schedule
    |> Map.get(day)
    |> Enum.reduce([], fn x, acc ->
      if NaiveDateTime.compare(now, x["hours"]) == :lt do
        acc ++ [x["hours"]]
      else
        acc
      end
    end)
    |> Enum.min_by(&abs(NaiveDateTime.diff(&1, now)))
  end
end
