#!/usr/bin/env python

from setuptools import setup, find_packages

setup(name='MinecraftPeNode',
      version='0.1.0',
      description='A game controller for led matrix + pocketmine + buttons',
      author='Troy Ross',
      author_email='kak.bo.che@gmail.com',
      url='http://github.com/kak-bo-che',
      package_dir=['MinecraftPeNode':'src'],
      install_requires = ['transitions', 'requests', 'evdev']
     )