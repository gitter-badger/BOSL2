#!/bin/bash

if [[ $# > 0 ]]; then
    PREVIEW_LIBS="$@"
else
    PREVIEW_LIBS="compat attachments math arrays vectors matrices coords geometry triangulation quaternions hull constants transforms primitives shapes masks paths beziers walls metric_screws threading involute_gears sliders joiners linear_bearings nema_steppers wiring phillips_drive torx_drive polyhedra debug"
fi

dir="$(basename $PWD)"
if [ "$dir" = "BOSL2" ]; then
    cd BOSL2.wiki
elif [ "$dir" != "BOSL2.wiki" ]; then
    echo "Must run this script from the BOSL2 or BOSL2/BOSL2.wiki directories."
    exit 1
fi

rm -f tmpscad*.scad
for lib in $PREVIEW_LIBS; do
    lib="$(basename $lib .scad)"
    mkdir -p images/$lib
    # rm -f images/$lib/*.png images/$lib/*.gif
    echo ../scripts/docs_gen.py ../$lib.scad -o $lib.scad.md -c -i -I images/$lib/
    ../scripts/docs_gen.py ../$lib.scad -o $lib.scad.md -c -i -I images/$lib/ || exit 1
    open -a Typora $lib.scad.md
done


