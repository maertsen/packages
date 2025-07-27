#!/bin/sh

case "$1" in
	"incus-agent")
		incus --version 2>&1 | grep "$2"
		;;
esac