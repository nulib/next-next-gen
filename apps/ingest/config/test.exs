use Mix.Config

config :ingest, storage_bucket: "test-masters"

config :ex_aws, :s3,
  access_key_id: "minio",
  secret_access_key: "minio123",
  host: "localhost",
  port: if(System.get_env("CI"), do: 9000, else: 9002),
  scheme: "http://",
  region: "us-east-1"
