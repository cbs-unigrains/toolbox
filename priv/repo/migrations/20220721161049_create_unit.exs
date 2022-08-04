defmodule Toolbox.Repo.Migrations.CreateUnit do
  use Ecto.Migration

  def change do
    create table(:unit) do
      add :label, :string
      add :short_label, :string

      timestamps()
    end
  end
end
