use Mix.Config

config :event_page, ecto_repos: [EventPage.Repo]

config :arc,
  storage: Arc.Storage.S3,
  bucket: "event-page",
  virtual_host: true

config :ex_aws,
  access_key_id: [{:system, "EVENT_PAGE_AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "EVENT_PAGE_AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: "ap-northeast-1",
  host: "s3-ap-northeast-1.amazonaws.com"

import_config "#{Mix.env}.exs"
