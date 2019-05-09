use Mix.Config

config :ingest, storage_bucket: System.get_env("MEADOW_STORAGE_BUCKET")

aws_key = fn key ->
  profile = System.get_env("AWS_PROFILE") || System.get_env("AWS_DEFAULT_PROFILE")
  [ {:system, key}, {:awscli, profile, 30}, :instance_role ]
end

shared_config = [
  access_key_id: aws_key.("AWS_ACCESS_KEY_ID"),
  secret_access_key: aws_key.("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION") || System.get_env("AWS_DEFAULT_REGION")
]

case System.get_env("MEADOW_AWS_ENDPOINT") do
  nil ->
    config :ex_aws, shared_config

  url ->
    with %URI{scheme: scheme, host: host, port: port} <- URI.parse(url) do
      config :ex_aws,
             :s3,
             shared_config ++
               [host: host, port: port, scheme: scheme]
    end
end
