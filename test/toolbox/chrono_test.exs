defmodule Toolbox.ChronoTest do
  use Toolbox.DataCase

  alias Toolbox.Chrono

  describe "unit" do
    alias Toolbox.Chrono.Unit

    import Toolbox.ChronoFixtures

    @invalid_attrs %{label: nil, short_label: nil}

    test "list_unit/0 returns all unit" do
      unit = unit_fixture()
      assert Chrono.list_unit() == [unit]
    end

    test "get_unit!/1 returns the unit with given id" do
      unit = unit_fixture()
      assert Chrono.get_unit!(unit.id) == unit
    end

    test "create_unit/1 with valid data creates a unit" do
      valid_attrs = %{label: "some label", short_label: "some short_label"}

      assert {:ok, %Unit{} = unit} = Chrono.create_unit(valid_attrs)
      assert unit.label == "some label"
      assert unit.short_label == "some short_label"
    end

    test "create_unit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chrono.create_unit(@invalid_attrs)
    end

    test "update_unit/2 with valid data updates the unit" do
      unit = unit_fixture()
      update_attrs = %{label: "some updated label", short_label: "some updated short_label"}

      assert {:ok, %Unit{} = unit} = Chrono.update_unit(unit, update_attrs)
      assert unit.label == "some updated label"
      assert unit.short_label == "some updated short_label"
    end

    test "update_unit/2 with invalid data returns error changeset" do
      unit = unit_fixture()
      assert {:error, %Ecto.Changeset{}} = Chrono.update_unit(unit, @invalid_attrs)
      assert unit == Chrono.get_unit!(unit.id)
    end

    test "delete_unit/1 deletes the unit" do
      unit = unit_fixture()
      assert {:ok, %Unit{}} = Chrono.delete_unit(unit)
      assert_raise Ecto.NoResultsError, fn -> Chrono.get_unit!(unit.id) end
    end

    test "change_unit/1 returns a unit changeset" do
      unit = unit_fixture()
      assert %Ecto.Changeset{} = Chrono.change_unit(unit)
    end
  end

  describe "series" do
    alias Toolbox.Chrono.Serie

    import Toolbox.ChronoFixtures

    @invalid_attrs %{
      code: nil,
      comment: nil,
      label: nil,
      periodicity: nil,
      rubrique: nil,
      secteur: nil,
      type: nil
    }

    test "list_series/0 returns all series" do
      serie = serie_fixture()
      assert Chrono.list_series() == [serie]
    end

    test "get_serie!/1 returns the serie with given id" do
      serie = serie_fixture()
      assert Chrono.get_serie!(serie.id) == serie
    end

    test "create_serie/1 with valid data creates a serie" do
      valid_attrs = %{
        code: "some code",
        comment: "some comment",
        label: "some label",
        periodicity: "some periodicity",
        rubrique: "some rubrique",
        secteur: "some secteur",
        type: "some type"
      }

      assert {:ok, %Serie{} = serie} = Chrono.create_serie(valid_attrs)
      assert serie.code == "some code"
      assert serie.comment == "some comment"
      assert serie.label == "some label"
      assert serie.periodicity == "some periodicity"
      assert serie.rubrique == "some rubrique"
      assert serie.secteur == "some secteur"
      assert serie.type == "some type"
    end

    test "create_serie/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chrono.create_serie(@invalid_attrs)
    end

    test "update_serie/2 with valid data updates the serie" do
      serie = serie_fixture()

      update_attrs = %{
        code: "some updated code",
        comment: "some updated comment",
        label: "some updated label",
        periodicity: "some updated periodicity",
        rubrique: "some updated rubrique",
        secteur: "some updated secteur",
        type: "some updated type"
      }

      assert {:ok, %Serie{} = serie} = Chrono.update_serie(serie, update_attrs)
      assert serie.code == "some updated code"
      assert serie.comment == "some updated comment"
      assert serie.label == "some updated label"
      assert serie.periodicity == "some updated periodicity"
      assert serie.rubrique == "some updated rubrique"
      assert serie.secteur == "some updated secteur"
      assert serie.type == "some updated type"
    end

    test "update_serie/2 with invalid data returns error changeset" do
      serie = serie_fixture()
      assert {:error, %Ecto.Changeset{}} = Chrono.update_serie(serie, @invalid_attrs)
      assert serie == Chrono.get_serie!(serie.id)
    end

    test "delete_serie/1 deletes the serie" do
      serie = serie_fixture()
      assert {:ok, %Serie{}} = Chrono.delete_serie(serie)
      assert_raise Ecto.NoResultsError, fn -> Chrono.get_serie!(serie.id) end
    end

    test "change_serie/1 returns a serie changeset" do
      serie = serie_fixture()
      assert %Ecto.Changeset{} = Chrono.change_serie(serie)
    end
  end
end
