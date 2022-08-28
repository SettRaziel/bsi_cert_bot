#!/bin/bash
# @Author: Benjamin Held
# @Date:   2015-08-30 09:48:37
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2019-03-26 17:32:15

yardoc -q './**/*.rb' --private --readme README.md
printf "Looking for undocumented passages: \n"
yard stats './**/*.rb' --list-undoc
