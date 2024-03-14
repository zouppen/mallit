include <BOSL2/std.scad>

tv_depth = 58;
support_z = 110;
speaker = [340, 130];
hand = 20;
wall = 6;
spk_floor = wall;
fence = 3.8;

partition(spread=20, cutpath="dovetail", $slop=0.15, spin=90, size=[speaker[0], speaker[1]+wall, 220]) diff() cuboid([speaker[0]+wall, speaker[1]+wall, spk_floor+fence]) {
    tag("remove") align(TOP, inside=true) cuboid([speaker[0], speaker[1], fence]);
    xcopies(l = $parent_size[0]-wall, n=4) {
        align(BOTTOM+FRONT) cuboid([wall, wall, hand])
            back(tv_depth) tag("keep") position(BACK+TOP) wedge([wall,speaker[1]-tv_depth,support_z], anchor=BOTTOM+FWD, orient=DOWN);
    }
};
