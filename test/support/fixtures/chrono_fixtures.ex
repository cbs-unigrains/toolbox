defmodule Toolbox.ChronoFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Toolbox.Chrono` context.
  """

  @doc """
  Generate a unit.
  """
  def unit_fixture(attrs \\ %{}) do
    {:ok, unit} =
      attrs
      |> Enum.into(%{
        label: "some label",
        short_label: "some short_label"
      })
      |> Toolbox.Chrono.create_unit()

    unit
  end

  @doc """
  Generate a serie.
  """
  def serie_fixture(attrs \\ %{}) do
    {:ok, serie} =
      attrs
      |> Enum.into(%{
        code: "some code",
        comment: "some comment",
        label: "some label",
        periodicity: "some periodicity",
        rubrique: "some rubrique",
        secteur: "some secteur",
        type: "some type"
      })
      |> Toolbox.Chrono.create_serie()

    serie
  end
end
