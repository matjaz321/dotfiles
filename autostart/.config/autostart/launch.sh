#!/bin/bash

killall -q polybar
 
echo "---" | tee /tmp/polybar.log
date  | tee -a /tmp/polybar.log

polybar 2>&1 | tee -a /tmp/polybar.log & disown

echo "Bars launched"
