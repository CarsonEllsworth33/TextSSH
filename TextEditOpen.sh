#!/bin/bash
#define path to editor

EditorPath=/Applications/"Sublime Text.app"
#attempt to open application at $EditorPath
echo $EditorPath
open -a "$EditorPath" $1