defmodule ToolboxWeb.RubriqueLiveTest do
  use ToolboxWeb.ConnCase

  import Phoenix.LiveViewTest
  import Toolbox.ChronoFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_rubrique(_) do
    rubrique = rubrique_fixture()
    %{rubrique: rubrique}
  end

  describe "Index" do
    setup [:create_rubrique]

    test "lists all rubriques", %{conn: conn, rubrique: rubrique} do
      {:ok, _index_live, html} = live(conn, Routes.rubrique_index_path(conn, :index))

      assert html =~ "Listing Rubriques"
      assert html =~ rubrique.name
    end

    test "saves new rubrique", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.rubrique_index_path(conn, :index))

      assert index_live |> element("a", "New Rubrique") |> render_click() =~
               "New Rubrique"

      assert_patch(index_live, Routes.rubrique_index_path(conn, :new))

      assert index_live
             |> form("#rubrique-form", rubrique: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#rubrique-form", rubrique: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.rubrique_index_path(conn, :index))

      assert html =~ "Rubrique created successfully"
      assert html =~ "some name"
    end

    test "updates rubrique in listing", %{conn: conn, rubrique: rubrique} do
      {:ok, index_live, _html} = live(conn, Routes.rubrique_index_path(conn, :index))

      assert index_live |> element("#rubrique-#{rubrique.id} a", "Edit") |> render_click() =~
               "Edit Rubrique"

      assert_patch(index_live, Routes.rubrique_index_path(conn, :edit, rubrique))

      assert index_live
             |> form("#rubrique-form", rubrique: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#rubrique-form", rubrique: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.rubrique_index_path(conn, :index))

      assert html =~ "Rubrique updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes rubrique in listing", %{conn: conn, rubrique: rubrique} do
      {:ok, index_live, _html} = live(conn, Routes.rubrique_index_path(conn, :index))

      assert index_live |> element("#rubrique-#{rubrique.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#rubrique-#{rubrique.id}")
    end
  end

  describe "Show" do
    setup [:create_rubrique]

    test "displays rubrique", %{conn: conn, rubrique: rubrique} do
      {:ok, _show_live, html} = live(conn, Routes.rubrique_show_path(conn, :show, rubrique))

      assert html =~ "Show Rubrique"
      assert html =~ rubrique.name
    end

    test "updates rubrique within modal", %{conn: conn, rubrique: rubrique} do
      {:ok, show_live, _html} = live(conn, Routes.rubrique_show_path(conn, :show, rubrique))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Rubrique"

      assert_patch(show_live, Routes.rubrique_show_path(conn, :edit, rubrique))

      assert show_live
             |> form("#rubrique-form", rubrique: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#rubrique-form", rubrique: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.rubrique_show_path(conn, :show, rubrique))

      assert html =~ "Rubrique updated successfully"
      assert html =~ "some updated name"
    end
  end
end
