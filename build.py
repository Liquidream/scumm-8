#!/usr/bin/env python3

import sys
import os
from subprocess import call

src_dir = 'src'
dist_dir = 'dist'
lib_source_filename = 'scumm-8.p8'
picotool_build_filename = 'scumm-8_fmt.p8'
minified_lua_filename = 'scumm-8.min.lua'
lib_header = \
"""
-- ==============================
-- scumm-8 public api functions
-- 
-- (you should not need to modify anything below here!)


"""
lib_start_pattern = 'function shake'
gfx_header = '__gfx__'
cart_sources_to_interpolate = ['game.p8', 'template.p8']
interpolation_token = '__include_scumm_8__\n'

if __name__ == '__main__':
  # initialize picotool-scumm-8 submodule if not present already
  call(['git', 'submodule', 'init'])
  call(['git', 'submodule', 'update'])

  # import tool after loading submodule
  from picotool_scumm8.pico8 import tool

  # minify and extract engine
  tool.main(['luamin', os.path.join(src_dir, lib_source_filename)])
  contents = open(os.path.join(src_dir, picotool_build_filename)).read()
  lib_only = \
    lib_header + \
    lib_start_pattern + \
    contents \
      .split(lib_start_pattern)[1] \
      .split(gfx_header)[0] \
      .replace(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\\\',
        '\\65\\66\\67\\68\\69\\70\\71\\72\\73\\74\\75\\76\\77\\78\\79\\80\\81\\82\\83\\84\\85\\86\\87\\88\\89\\90\\91\\92'
      ) \
      .replace('"\\\n"', '"\\n"') # line breaks mangled for some reason

  # remove unneeded intermediate file
  os.remove(os.path.join(src_dir, picotool_build_filename))

  # write minified engine to file
  lib_out_filename = os.path.join(dist_dir, minified_lua_filename)
  open(lib_out_filename, 'w').write(lib_only)
  print('Built ' + lib_out_filename + '!')

  # interpolate carts using minified engine
  for filename in cart_sources_to_interpolate:
    src_contents = open(os.path.join(src_dir, filename)).read()
    dist_contents = src_contents.replace(interpolation_token, lib_only)
    out_filename = os.path.join(dist_dir, filename)
    open(out_filename, 'w').write(dist_contents)
    print('Built ' + out_filename + '!')

  sys.exit(0)
