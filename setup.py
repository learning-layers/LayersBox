#!/usr/bin/env python

import os
from setuptools import setup

# Utility function to read the README file.
# Used for the long_description.  It's nice, because now 1) we have a top level
# README file and 2) it's easier to type in the README file than to put a raw
# string in below ...
def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

setup(
    name = "LayersBox",
    version = "0.0.1",
    author = "Andreas Guth",
    author_email = "andreas.guth@rwth-aachen.de",
    description = ("Management tools for LayersBoxes"),
    license = "BSD",
    keywords = "LayersBox",
    url = "https://github.com/learning-layers/LayersBox",
    scripts=['layersbox'],
    requires=['pyyaml'],
    long_description=read('README.md'),
    classifiers=[
        "Development Status :: 2 - Pre-Alpha",
        "Topic :: Utilities",
        "License :: OSI Approved :: BSD License",
    ],
)

