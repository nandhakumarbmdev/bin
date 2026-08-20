#!/bin/sh

epoch="$1"

if [ -z "$epoch" ]; then
    echo "Usage: $0 <epoch_seconds_or_millis>" >&2
    exit 1
fi

case "$epoch" in
    *[!0-9]*) echo "Error: input must be a positive integer" >&2; exit 1 ;;
esac

if [ ${#epoch} -gt 10 ]; then
    epoch=$((epoch / 1000))
fi

TZ="Asia/Kolkata" date -r "$epoch" "+%I:%M:%S %p IST, %A, %d %B %Y"