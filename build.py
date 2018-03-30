#!/usr/bin/env python3

import sys
from subprocess import call

build_filename = 'scumm-8_fmt.p8'

if __name__ == '__main__':
  call(['git', 'submodule', 'init'])
  call(['git', 'submodule', 'update'])
  from picotool_scumm8.pico8 import tool
  tool.main(['luamin', 'scumm-8.p8'])
  contents = open(build_filename).read()
  open(build_filename, 'w').write(contents.replace(
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\',
    '\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92'
  ))
  print('Built ' + build_filename + '!')
  sys.exit(0)
