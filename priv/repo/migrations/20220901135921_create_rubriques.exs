defmodule Toolbox.Repo.Migrations.CreateRubriques do
  use Ecto.Migration

  def change do
    create table(:rubriques) do
      add :name, :string
      add :secteur_id, references(:secteurs, on_delete: :nothing)

      timestamps()
    end

    create index(:rubriques, [:secteur_id])
  end
end
