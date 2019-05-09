#!/bin/sh

release_ctl eval --mfa "Meadow.Runtime.Ingest.ingest/1" --argv -- "$@"
