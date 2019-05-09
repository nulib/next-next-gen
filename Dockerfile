#===========
#Build Stage
#===========
FROM elixir:1.8-alpine as build
ENV APP_NAME="meadow" \
    MIX_ENV="prod"
RUN apk update && \
    apk add -u musl musl-dev musl-utils nodejs-npm build-base
RUN mix local.hex --force && \
    mix local.rebar --force
RUN for app in ingest meadow_data meadow_ui; do mkdir -p apps/$app; done
COPY mix.exs mix.exs
COPY mix.lock mix.lock
COPY apps/ingest/mix.exs apps/ingest/mix.exs
COPY apps/meadow_data/mix.exs apps/meadow_data/mix.exs
COPY apps/meadow_ui/mix.exs apps/meadow_ui/mix.exs
RUN mix do deps.get, deps.compile
COPY . .
RUN mix compile
RUN cd apps/meadow_ui/assets && \
    npm install && \
    node ./node_modules/brunch/bin/brunch b -p && \
    cd -
RUN mix do phx.digest, release
RUN RELEASE_DIR=`ls -d _build/${MIX_ENV}/rel/$APP_NAME/releases/*/` && \
    mkdir /export && \
    tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export

#================
#Deployment Stage
#================
FROM erlang:21-alpine
EXPOSE 4000
ENV REPLACE_OS_VARS=true \
    PORT=4000
RUN apk --update add bash && \
    adduser -S app
USER app
WORKDIR /home/app
COPY --from=build /export/ .
ENTRYPOINT ["/home/app/bin/meadow"]
CMD ["foreground"]