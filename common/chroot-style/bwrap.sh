#!/bin/sh
#
# This chroot script uses bubblewrap (see https://github.com/containers/bubblewrap)
#
set -e
readonly MASTERDIR="$1"
readonly DISTDIR="$2"
readonly HOSTDIR="$3"
readonly EXTRA_ARGS="$4"
shift 4

if ! command -v bwrap >/dev/null 2>&1; then
	exit 1
fi

if [ -z "$MASTERDIR" -o -z "$DISTDIR" ]; then
	echo "$0 MASTERDIR/DISTDIR not set"
	exit 1
fi

exec bwrap --bind "$MASTERDIR" / --ro-bind "$DISTDIR" /cereus-pkgs \
	 --dev /dev --tmpfs /tmp --proc /proc \
	${HOSTDIR:+--bind "$HOSTDIR" /host} $EXTRA_ARGS "$@"
