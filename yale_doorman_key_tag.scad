include <BOSL2/std.scad>

tag_size = [38.7, 22.4, 1.2];
tag_rounding = 1;

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa=1;
$fs=0.2;
$align_msg = false;

// This small snippet is just the hole for the tag. You need the
// actual model where to put this hole for the tag.

cuboid(tag_size, rounding=tag_rounding, edges="Z");
