include <BOSL2/std.scad>

kansi = [195,165,30];
kansi_edge = 3.2;
cover = 60; // Cover y axis
hand_w = 20;
rounding = 25;
support = 5;
real_h = 20;
outer_chamfer=5;


diff() {
    cuboid(kansi, edges=TOP, chamfer=outer_chamfer) {
        align(BOTTOM, inside=true) cuboid(kansi-[2*kansi_edge, 2*kansi_edge, kansi_edge], chamfer=kansi[2]-real_h-kansi_edge, edges=TOP);

        // Cuts
        for (a = [LEFT, RIGHT]) {
            align(a+BACK+TOP, inside=true) cuboid([($parent_size[0]-hand_w)/2,$parent_size[1]-cover, $parent_size[2]],
                                                  rounding = rounding, edges=[FWD-a]);
        }

        tag("keep") down(kansi_edge) align(TOP, inside=true) cuboid([hand_w, $parent_size[1]-2*kansi_edge, support-kansi_edge], chamfer=support-kansi_edge, edges=[BOTTOM+LEFT, BOTTOM+RIGHT]);
    }
}
