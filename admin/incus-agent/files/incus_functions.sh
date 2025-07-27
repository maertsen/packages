#!/bin/sh

INCUS_AGENT_PATH="/run/incus_agent"
INCUS_AGENT_PROG="incus-agent"
INCUS_AGENT="${INCUS_AGENT_PATH}/${INCUS_AGENT_PROG}"

function log() {
    PRI="$1"
    MDG="$2"
    [ -z "${PRI}" ] && [ -z "${MSG}" ] && return
    logger -p daemon.${PRI} -t "incus_agent" "${2}"
}

function fail() {
    MSG=$1
    [ -n "${MSG}" ] && MSG='Unknown error'
    log 'error' "${MSG}"
    exit 1
}

function setup_vports() {
    for i in $(grep '' /sys/class/virtio-ports/*/name)
    do 
	VPORT="$(basename $(dirname ${i}))"
	VLINK="$(basename ${i})"; VLINK=${VLINK#*:}
	mkdir -p "/dev/virtio-ports/" && \
	    [ -c "/dev/${VPORT}" ] && \
	    ln -sf "../${VPORT}" "/dev/virtio-ports/${VLINK}"
    done
}

function create_incus_agent_dir() {
    mkdir -p "${INCUS_AGENT_PATH}"
    mount -t tmpfs tmpfs "${INCUS_AGENT_PATH}" -o mode=0700,size=24M
}

function mount_incus() {
    DEV=$1
    MNT_P=$2
    ERR=""
    if [ -z "${DEV}" ] || [ -z "${MNT_P}" ]
    then 
	log error 'Unable to mount if "device" and/or "mount point" parameters are not set.'
	return 255
    fi
    ERR=$(mount -t 9p "${DEV}" -o access=0,trans=virtio,size=1048576 "${MNT_P}")
    EC=$?
    [ ${EC} -eq 0 ] && ERR=""
    if [ -n "${ERR}" ]
    then
	log error "$ERR"
	return $EC
    fi
}

function copy_config() {
    MNT_P="${INCUS_AGENT_PATH}/.mnt"
    mkdir -p "${MNT_P}"
    mount_incus config "${MNT_P}"
    cp -Ra "${MNT_P}"/* "${INCUS_AGENT_PATH}"
    umount "${MNT_P}"
    rmdir "${MNT_P}"
    chown -R root:root "${INCUS_AGENT_PATH}"
}

function incus_agent_exists() {
    [ -d "${INCUS_AGENT_PATH}" ] && [ -x "${INCUS_AGENT}" ] && return 0 || return 1
}

function incus_agent_start() {
    cd "${INCUS_AGENT_PATH}"; \
    ./"${INCUS_AGENT_PROG}"
}

incus_agent_stop() {
    PIDS=$(pidof "${INCUS_AGENT_PROG}")
    [ -n "${PIDS}$" ] && for PID in $PIDS; do kill ${PID}; done
}
