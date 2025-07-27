#!/bin/sh

case "$1" in
	"incus-agent")
		incus-agent --version 2>&1 | grep "$2"
		;;
esac
