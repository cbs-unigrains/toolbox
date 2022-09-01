defmodule ToolboxWeb.SecteurLiveTest do
  use ToolboxWeb.ConnCase

  import Phoenix.LiveViewTest
  import Toolbox.ChronoFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_secteur(_) do
    secteur = secteur_fixture()
    %{secteur: secteur}
  end

  describe "Index" do
    setup [:create_secteur]

    test "lists all secteurs", %{conn: conn, secteur: secteur} do
      {:ok, _index_live, html} = live(conn, Routes.secteur_index_path(conn, :index))

      assert html =~ "Listing Secteurs"
      assert html =~ secteur.name
    end

    test "saves new secteur", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.secteur_index_path(conn, :index))

      assert index_live |> element("a", "New Secteur") |> render_click() =~
               "New Secteur"

      assert_patch(index_live, Routes.secteur_index_path(conn, :new))

      assert index_live
             |> form("#secteur-form", secteur: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#secteur-form", secteur: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.secteur_index_path(conn, :index))

      assert html =~ "Secteur created successfully"
      assert html =~ "some name"
    end

    test "updates secteur in listing", %{conn: conn, secteur: secteur} do
      {:ok, index_live, _html} = live(conn, Routes.secteur_index_path(conn, :index))

      assert index_live |> element("#secteur-#{secteur.id} a", "Edit") |> render_click() =~
               "Edit Secteur"

      assert_patch(index_live, Routes.secteur_index_path(conn, :edit, secteur))

      assert index_live
             |> form("#secteur-form", secteur: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#secteur-form", secteur: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.secteur_index_path(conn, :index))

      assert html =~ "Secteur updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes secteur in listing", %{conn: conn, secteur: secteur} do
      {:ok, index_live, _html} = live(conn, Routes.secteur_index_path(conn, :index))

      assert index_live |> element("#secteur-#{secteur.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#secteur-#{secteur.id}")
    end
  end

  describe "Show" do
    setup [:create_secteur]

    test "displays secteur", %{conn: conn, secteur: secteur} do
      {:ok, _show_live, html} = live(conn, Routes.secteur_show_path(conn, :show, secteur))

      assert html =~ "Show Secteur"
      assert html =~ secteur.name
    end

    test "updates secteur within modal", %{conn: conn, secteur: secteur} do
      {:ok, show_live, _html} = live(conn, Routes.secteur_show_path(conn, :show, secteur))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Secteur"

      assert_patch(show_live, Routes.secteur_show_path(conn, :edit, secteur))

      assert show_live
             |> form("#secteur-form", secteur: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#secteur-form", secteur: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.secteur_show_path(conn, :show, secteur))

      assert html =~ "Secteur updated successfully"
      assert html =~ "some updated name"
    end
  end
end
