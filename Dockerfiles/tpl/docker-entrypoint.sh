#!/bin/sh
# vim:sw=4:ts=4:et

set -e

ENTRYPOINT_DIR="/docker-entrypoint.d"              # All entrypoint scripts

###
### Bootstrap
###
# shellcheck disable=SC1090,SC1091
. "${ENTRYPOINT_DIR}/bootstrap/bootstrap.sh"

###
### Source available entrypoint scripts
###
# shellcheck disable=SC2012
for f in $( ls -1 "${ENTRYPOINT_DIR}/"*.sh | sort -u ); do
        # shellcheck disable=SC1090
        . "${f}"
done

###################################################################################################
###################################################################################################
###
### MAIN ENTRYPOINT
###
###################################################################################################
###################################################################################################

# -------------------------------------------------------------------------------------------------
# SET ENVIRONMENT VARIABLES AND DEFAULT VALUES
# -------------------------------------------------------------------------------------------------

###
### Show Debug level
###
log "info" "Entrypoint debug: $( env_get "DEBUG_ENTRYPOINT" )"
log "info" "Runtime debug: $( env_get "DEBUG_RUNTIME" )"


###
### Show environment vars
###
log "info" "-------------------------------------------------------------------------"
log "info" "Environment Variables (set/default)"
log "info" "-------------------------------------------------------------------------"

log "info" "Variables: General:"
env_var_export "NEW_UID" 1000
env_var_export "NEW_GID" 1000
env_var_export "TIMEZONE" "UTC"


# -------------------------------------------------------------------------------------------------
# APPLY SETTINGS
# -------------------------------------------------------------------------------------------------

log "info" "-------------------------------------------------------------------------"
log "info" "Apply Settings"
log "info" "-------------------------------------------------------------------------"

###
### Change uid/gid
###
set_uid "${NEW_UID}" "${MY_USER}"
set_gid "${NEW_GID}" "${MY_USER}" "${MY_GROUP}"

###
### Set timezone
###
set_timezone "${TIMEZONE}"

exec "$@"
