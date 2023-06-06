defmodule Parzival.Tools.EventDays do
  @moduledoc false

  @first_day_start Application.compile_env(:parzival, :event)[:first_day_start]
  @first_day_end Application.compile_env(:parzival, :event)[:first_day_end]
  @second_day_start Application.compile_env(:parzival, :event)[:second_day_start]
  @second_day_end Application.compile_env(:parzival, :event)[:second_day_end]
  @third_day_start Application.compile_env(:parzival, :event)[:third_day_start]
  @third_day_end Application.compile_env(:parzival, :event)[:third_day_end]

  def get_first_day_start, do: @first_day_start
  def get_first_day_end, do: @first_day_end
  def get_second_day_start, do: @second_day_start
  def get_second_day_end, do: @second_day_end
  def get_third_day_start, do: @third_day_start
  def get_third_day_end, do: @third_day_end
end
