#!/bin/bash

# Color definitions
RED='\033[31m'
MAUVE='\033[95m'
PINK='\033[35m'
GREEN='\033[32m'
BLUE='\033[34m'
NC='\033[0m' # No Color

print_header() {
  local title=$1
  
  echo -e ""
  echo -e "${MAUVE}📦 Installing $title${NC}"
}
