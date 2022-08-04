import Config

config :ueberauth, Ueberauth.Strategy.Microsoft.OAuth,
  tenant_id: "1839f17e-240c-44a4-8d24-b717d8b4bcdf",
  client_id: "3dc47379-90de-48d4-9853-0780c0a6a314",
  client_secret: "djUycT7K_2_Yb4.9yIM62T5-k5g9_r-O_t"

# Configure your database
config :toolbox, Toolbox.EfrontRepo,
  username: "agenttalend",
  password: "Bvn862/1"

config :toolbox, Toolbox.Repo,
  username: "cbs",
  password: "Kdi765lc76tG"
