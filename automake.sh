#!/bin/sh

while true
do
	inotifywait -q -e close_write src/*.coffee
	make
done
