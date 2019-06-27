#!/bin/sh

clingo two_wires.lp --quiet=1,0,2 | grep redstone | ./draw_map.py
