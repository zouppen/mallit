// A box for an RF low pass filter (old 2024 design)

include <BOSL2/std.scad>
$align_msg=false;

coax_a_d = 2.9;
coax_b_d = 2.7;

size_in = [58, 15, 9];
edge = 1;
wall = 2;
e = 0.2;

screwbox = 5;

cut_plane = xrot(90);

module box() {
    // Box
    tag_diff("vehje") {
        cuboid(size_in + [2*wall, 2*wall, 2*wall]) tag("remove") {
            // Hollow inside
            cuboid(size_in) {
                // Screw bases
                tag("keep") for (x = [LEFT, RIGHT]) {
                    for (y = [FWD, BACK]) {
                        align(x+y, inside=true) cuboid([screwbox, screwbox, size_in[2]]);
                    }
                }
            }

            // Coax holes
            attach(LEFT) cyl(l=wall, d=coax_a_d, anchor=TOP, $fn=20);
            attach(RIGHT) cyl(l=wall, d=coax_b_d, anchor=TOP, $fn=20);

        }
    }
}

module cut(margin=0) {
    down(edge/2) {
        cuboid(70, anchor=TOP);
        cuboid([size_in[0]+2*edge+margin, size_in[1]+2*edge+margin, edge+margin/2], anchor=BOTTOM);
    }
}

up(5) diff() {
    box();
    tag("remove") cut(e);
}

intersect() {
    box();
    tag("intersect") cut();
}
