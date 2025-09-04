// Weidmüller WDU 4 "sticker platforms"
//
// Useful for Dymo or other sticker printer to make smooth surface
// where to attach the marker stickers.
//
// To make platforms for different WDU models, change edge and
// mod_width constants accordingly.
include <BOSL2/std.scad>

mod_width = 6.1;
edge = 1;
h = 12;
tap_h = 2;
tap_w = 1.4;
tap_sep = 3.1;
taps = 4;
pf_w = 0.9;
pf_h = 12;
cham = 0.4;

sizes = 6;

module blokki(modules) {
    cuboid([pf_h, modules*mod_width, pf_w], anchor=BOTTOM) {
        fwd(edge/2) {
            grid_copies([tap_sep, mod_width], [taps, modules]) {
                position(TOP) cuboid([tap_w,mod_width-edge,tap_h], anchor=BOTTOM, edges=TOP, chamfer = cham);
            }
        }
    }
}

// Place different sizes on the bed
xcopies(pf_h+5, sizes) {
    blokki($idx+1);
}
