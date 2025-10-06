declare -A HOST_ROLES
declare -A HOSTS

# Configure the available roles and which modules they use
HOST_ROLES["client"]="module:basics module:languages module:vpn module:shell module:gui module:devtools module:dns module:ssh"

HOSTS["cachovo"]="role:client"
HOSTS["cachybox"]="role:client"

