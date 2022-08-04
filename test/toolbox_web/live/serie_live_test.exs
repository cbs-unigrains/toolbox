defmodule ToolboxWeb.SerieLiveTest do
  use ToolboxWeb.ConnCase

  import Phoenix.LiveViewTest
  import Toolbox.ChronoFixtures

  @create_attrs %{
    code: "some code",
    comment: "some comment",
    label: "some label",
    periodicity: "some periodicity",
    rubrique: "some rubrique",
    secteur: "some secteur",
    type: "some type"
  }
  @update_attrs %{
    code: "some updated code",
    comment: "some updated comment",
    label: "some updated label",
    periodicity: "some updated periodicity",
    rubrique: "some updated rubrique",
    secteur: "some updated secteur",
    type: "some updated type"
  }
  @invalid_attrs %{
    code: nil,
    comment: nil,
    label: nil,
    periodicity: nil,
    rubrique: nil,
    secteur: nil,
    type: nil
  }

  defp create_serie(_) do
    serie = serie_fixture()
    %{serie: serie}
  end

  describe "Index" do
    setup [:create_serie]

    test "lists all series", %{conn: conn, serie: serie} do
      {:ok, _index_live, html} = live(conn, Routes.serie_index_path(conn, :index))

      assert html =~ "Listing Series"
      assert html =~ serie.code
    end

    test "saves new serie", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.serie_index_path(conn, :index))

      assert index_live |> element("a", "New Serie") |> render_click() =~
               "New Serie"

      assert_patch(index_live, Routes.serie_index_path(conn, :new))

      assert index_live
             |> form("#serie-form", serie: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#serie-form", serie: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.serie_index_path(conn, :index))

      assert html =~ "Serie created successfully"
      assert html =~ "some code"
    end

    test "updates serie in listing", %{conn: conn, serie: serie} do
      {:ok, index_live, _html} = live(conn, Routes.serie_index_path(conn, :index))

      assert index_live |> element("#serie-#{serie.id} a", "Edit") |> render_click() =~
               "Edit Serie"

      assert_patch(index_live, Routes.serie_index_path(conn, :edit, serie))

      assert index_live
             |> form("#serie-form", serie: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#serie-form", serie: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.serie_index_path(conn, :index))

      assert html =~ "Serie updated successfully"
      assert html =~ "some updated code"
    end

    test "deletes serie in listing", %{conn: conn, serie: serie} do
      {:ok, index_live, _html} = live(conn, Routes.serie_index_path(conn, :index))

      assert index_live |> element("#serie-#{serie.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#serie-#{serie.id}")
    end
  end

  describe "Show" do
    setup [:create_serie]

    test "displays serie", %{conn: conn, serie: serie} do
      {:ok, _show_live, html} = live(conn, Routes.serie_show_path(conn, :show, serie))

      assert html =~ "Show Serie"
      assert html =~ serie.code
    end

    test "updates serie within modal", %{conn: conn, serie: serie} do
      {:ok, show_live, _html} = live(conn, Routes.serie_show_path(conn, :show, serie))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Serie"

      assert_patch(show_live, Routes.serie_show_path(conn, :edit, serie))

      assert show_live
             |> form("#serie-form", serie: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#serie-form", serie: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.serie_show_path(conn, :show, serie))

      assert html =~ "Serie updated successfully"
      assert html =~ "some updated code"
    end
  end
end
