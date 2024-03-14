include <BOSL2/std.scad>

wall = 6;
tv_depth = 58;
support_z = 110;
speaker = [340-wall, 130];
hand = 20;
spk_floor = wall;
fence = 3.8;
$slop = 0.1;

partition(spread=20, cutpath="dovetail", spin=90, size=[speaker[0], speaker[1]+wall, 230]) diff() cuboid([speaker[0]+wall, speaker[1]+wall, spk_floor+fence]) {
    tag("remove") align(TOP, inside=true) cuboid([speaker[0], speaker[1], fence]);
    xcopies(l = $parent_size[0]-wall, n=4) {
        align(BOTTOM+FRONT) cuboid([wall, wall, hand])
            back(tv_depth) position(BACK+TOP) cuboid([wall, wall, support_z], anchor=TOP+FWD)
            position(BACK+TOP) wedge([wall,speaker[1]-tv_depth-wall,support_z], anchor=BOTTOM+FWD, orient=DOWN);
    }
};
