use Mix.Config

config :ingest, storage_bucket: "dev-masters"

config :ex_aws, :s3,
  access_key_id: "minio",
  secret_access_key: "minio123",
  host: "localhost",
  port: 9001,
  scheme: "http://",
  region: "us-east-1"
