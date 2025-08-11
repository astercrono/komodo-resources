#!/usr/bin/bash

[ -z "$BWS_TOKEN" ] && echo "Missing secret: bws_token" && exit 1

bws_list_output="$(BWS_ACCESS_TOKEN="$bws_token" bws secret list)"

for var_name in "${!BWS_VAR_@}"; do
	var_value="${!var_name}"

	[ -z "$var_value" ] && echo "Unable to read BWS_VAR value" && exit 1

	bws_entry_name="${var_value%%=*}"
	bws_mapped_name="${var_value#*=}"

	[ -z "$bws_entry_name" ] && echo "Invalid or missing BWS_VARS name" && exit 1
	[ -z "$bws_mapped_name" ] && echo "Invalid or missing BWS_VARS mapped name" && exit 1

	bws_value=$(echo $bws_list_output | jq -r ".[] | select(.key == \"$bws_entry_name\") | .value")

	export "$bws_mapped_name=$bws_value"
done

unset BWS_TOKEN

exec "$@"
