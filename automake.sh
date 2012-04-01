#!/bin/sh

while true
do
	inotifywait -q -r -e close_write src/
	make
done
