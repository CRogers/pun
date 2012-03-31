#!/bin/sh

while true
do
	inotifywait -e modify src/*.coffee
	make
done
