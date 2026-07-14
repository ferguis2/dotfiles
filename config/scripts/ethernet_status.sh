#!/bin/sh

IP=$(ip route get 1 | awk '{print $7; exit}')

echo "%{F#2495e7} %{F#ffffff}$IP%{u-}"
