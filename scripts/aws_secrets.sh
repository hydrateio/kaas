#!/bin/bash
sops -d ./secrets.json | jq -r 'to_entries[] | "export TF_VAR_" + .key + "=" + .value' || echo '{}'
