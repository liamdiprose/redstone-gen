#!/usr/bin/python3

from sys import stdin
import re

REDSTONE_CHAR = "\033[91m+\033[0m"

def print_map(positions: [(int, int)], width=4):
    redstone_map = [[False for y in range(4)] for x in range(4)]
    for position in positions:
        x,y = map(int, position)
        redstone_map[x-1][y-1] = True

    for y in range(width):
        for x in range(width):
            redstone = redstone_map[x][y]
            if redstone:
                print(REDSTONE_CHAR, end='')
            else:
                print('.', end='')
        print()

BLOCK_REGEX = re.compile(r"(?P<name>\w+)\((\d+),(\d+)\)")

def parse_block(s: str) -> (str, (str, str)):
    m = BLOCK_REGEX.match(s)
    if m:
        return m.group('name'), (m[2], m[3])
    else:
        return s, ('','')


for line in stdin.readlines():
    words = line.split(' ')

    if len(words) > 2:
        answer = words

        redstone_positions = []

        for constraint in answer:
            name, coords = parse_block(constraint)

            if name == "redstone":
                redstone_positions.append(tuple(coords))

        print_map(redstone_positions)
    if words[0] == "Optimization:":
        print(f"Optimisation: {words[1].strip()}")
