#!/usr/bin/bash

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color


SERVICES=(
	"gammastep"
)

service_exists() {
	systemctl --user list-unit-files | grep -q "^$1.service"
}

setup_service() {
	local service=$1

	if ! service_exists "$service"; then
		echo "${RED} Service $service.service not found ${NC}"
		return 1
	fi
	
	systemctl --user enable "$service" 2>/dev/null
	systemctl --user start "$service" >/dev/null
	systemctl --user is-active "$service" >/dev/null
}

for service in "${SERVICES[@]}"; do
	setup_service "$service"
	
	echo -e "${GREEN} Service $service enabled ${NC}"
done
