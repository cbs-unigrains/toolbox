defmodule Toolbox.Repo.Migrations.CreateSeries do
  use Ecto.Migration

  def change do
    create table(:series) do
      add :secteur, :string
      add :rubrique, :string
      add :code, :string
      add :label, :string
      add :periodicity, :string
      add :comment, :string
      add :type, :string
      add :unit, references(:unit, on_delete: :nothing)

      timestamps()
    end

    create index(:series, [:unit])
  end
end
