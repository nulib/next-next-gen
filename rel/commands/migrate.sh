#!/bin/sh

release_ctl eval --mfa "Meadow.Runtime.Migrations.migrate/1" --argv -- "$@"
