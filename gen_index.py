#!/usr/bin/env python3

import os
import sys

from os.path import join

def walk(path, level):
    ident = ' ' * 4 * level
    dirs = [entry.name for entry in os.scandir(path) if entry.is_dir()]
    for dir in sorted(dirs):
        full_path = join(path, dir)
        print(f'{ident}- [`{dir}`]({full_path})')
        walk(full_path, level + 1)

path = '.'
if len(sys.argv) > 1:
    path = sys.argv[1]
walk(path, 0)
