defmodule ParzivalWeb.ViewUtils do
  @moduledoc """
  Utility functions to be used on all views.
  """

  use Timex

  alias Timex.Format.DateTime.Formatters.Relative

  def extract_initials(nil), do: ""

  def extract_initials(name) do
    initials = name |> String.upcase() |> String.split(" ") |> Enum.map(&String.slice(&1, 0, 1))

    case length(initials) do
      1 -> hd(initials)
      _ -> List.first(initials) <> List.last(initials)
    end
  end

  def extract_first_last_name(nil), do: ""

  def extract_first_last_name(name) do
    initials = name |> String.split(" ")

    case length(initials) do
      1 -> hd(initials)
      _ -> List.first(initials) <> " " <> List.last(initials)
    end
  end

  def relative_datetime(nil), do: ""

  def relative_datetime(""), do: ""

  def relative_datetime(datetime) do
    Relative.lformat!(datetime, "{relative}", Gettext.get_locale())
  end

  def display_date(nil), do: ""

  def display_date(""), do: ""

  def display_date(date) when is_binary(date) do
    date
    |> Timex.parse!("%FT%H:%M", :strftime)
    |> Timex.format!("{0D}-{0M}-{YYYY}")
  end

  def display_date(date) do
    Timex.format!(date, "{0D}-{0M}-{YYYY}")
  end

  def display_time(nil), do: ""

  def display_time(""), do: ""

  def display_time(date) when is_binary(date) do
    date
    |> Timex.parse!("%FT%H:%M", :strftime)
    |> Timex.format!("{0D}-{0M}-{YYYY}")
  end

  def display_time(date) do
    date
    |> Timex.format!("{h24}:{m}")
  end

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

  def text_800(color) do
    case color do
      :gray -> "text-gray-800"
      :red -> "text-red-800"
      :orange -> "text-orange-800"
      :amber -> "text-amber-800"
      :yellow -> "text-yellow-800"
      :lime -> "text-lime-800"
      :green -> "text-green-800"
      :emerald -> "text-emerald-800"
      :teal -> "text-teal-800"
      :cyan -> "text-cyan-800"
      :sky -> "text-sky-800"
      :blue -> "text-blue-800"
      :indigo -> "text-indigo-800"
      :violet -> "text-violet-800"
      :purple -> "text-purple-800"
      :fuchsia -> "text-fuchsia-800"
      :pink -> "text-pink-800"
      :rose -> "text-rose-800"
    end
  end

  def bg_100(color) do
    case color do
      :gray -> "bg-gray-100"
      :red -> "bg-red-100"
      :orange -> "bg-orange-100"
      :amber -> "bg-amber-100"
      :yellow -> "bg-yellow-100"
      :lime -> "bg-lime-100"
      :green -> "bg-green-100"
      :emerald -> "bg-emerald-100"
      :teal -> "bg-teal-100"
      :cyan -> "bg-cyan-100"
      :sky -> "bg-sky-100"
      :blue -> "bg-blue-100"
      :indigo -> "bg-indigo-100"
      :violet -> "bg-violet-100"
      :purple -> "bg-purple-100"
      :fuchsia -> "bg-fuchsia-100"
      :pink -> "bg-pink-100"
      :rose -> "bg-rose-100"
    end
  end
end
