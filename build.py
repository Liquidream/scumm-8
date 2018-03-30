#!/usr/bin/env python3

import sys
import os
from subprocess import call

source_filename = 'scumm-8.p8'
picotool_build_filename = 'scumm-8_fmt.p8'
minified_lua_filedname = 'scumm-8.min.lua'
lib_header = \
"""
-- ==============================
-- scumm-8 public api functions
--
-- (you should not need to modify anything below here!)


"""
lib_start_pattern = 'function shake'
gfx_header = '__gfx__'

if __name__ == '__main__':
  call(['git', 'submodule', 'init'])
  call(['git', 'submodule', 'update'])
  from picotool_scumm8.pico8 import tool
  tool.main(['luamin', source_filename])
  contents = open(picotool_build_filename).read()
  lib_only = \
    lib_header + \
    lib_start_pattern + \
    contents \
      .split(lib_start_pattern)[1] \
      .split(gfx_header)[0] \
      .replace(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\\\',
        '\\65\\66\\67\\68\\69\\70\\71\\72\\73\\74\\75\\76\\77\\78\\79\\80\\81\\82\\83\\84\\85\\86\\87\\88\\89\\90\\91\\92'
      )
  open(minified_lua_filedname, 'w').write(lib_only)
  os.remove(picotool_build_filename)
  print('Built ' + minified_lua_filedname + '!')
  sys.exit(0)
