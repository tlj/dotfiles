#!/usr/bin/env bash

declare -A HOSTS

# client linux computers
HOSTS["cachybox"]='arch desktop private client internal'
HOSTS["lenovomarchy"]='arch laptop private client internal'

# linux internal servers
HOSTS["macminux"]='linux server private internal'

# mac laptops
HOSTS["mba13.local"]='mac laptop private client internal'
HOSTS["trd-m-ryv9rxyyj5"]='mac laptop work client'

# linux external facing servers
HOSTS["dns1"]='linux server private'
HOSTS["dns2"]='linux server private'
HOSTS["caddy"]='linux server private'

