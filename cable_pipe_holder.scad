include <BOSL2/std.scad>

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa=1;
$fs=0.2;
$align_msg = false;

// Cable holder box for upstairs
outer_d = 63;
pipe_l = 37;
wall = 2;
ring = 10;
ring_h = 1;
pipe_in = 18;
pipe_d = 20;
ziptie = [2.6,8];
ziptie_headroom = 8;
pipe_h_adj = -8.5+15;
attach_d = 3.6;
cut_plane_deg = -27;
cut_plane_h = 6.9;

diff() {
    tube(h=pipe_l, od=outer_d, wall=wall) {
        position(BOTTOM) tube(h=ring_h, od=outer_d+2*ring, id=outer_d-2*wall, anchor=TOP);
        position(FWD+TOP) cuboid([$parent_size[0]*0.9, pipe_in, $parent_size[2]+ring_h-ziptie_headroom], anchor=FWD+TOP);
        tag("remove") tube(h=pipe_l, id=outer_d, wall=ring*2);
        tag("remove") position(FWD) up(pipe_h_adj) cyl(h=pipe_in, d=pipe_d, orient=FWD, anchor=TOP);
        for (pos = [-1,1]) {
            m = pipe_d/2+ziptie[0]/2;
            tag("remove") down(ring_h) back(pipe_in-wall) left(m*pos) position(BOTTOM+FWD) cuboid([ziptie[0],ziptie[1],$parent_size[2]/2+ring_h+pipe_h_adj], anchor=BOTTOM+BACK);
        }

        // cutout
        tag("remove") position(FWD+TOP) cuboid([$parent_size[0]*0.9, pipe_in-wall, $parent_size[2]/2-pipe_h_adj], anchor=FWD+TOP);

        tag("remove") for (a = [60, 180, 300]) {
            zrot(a) fwd(outer_d/2+ring/2) position(BOTTOM) cyl(d=attach_d, h=wall, anchor=TOP);
        }

        // The cut plane to make printing faster
        #tag("remove") down(cut_plane_h) position(TOP) xrot(cut_plane_deg) cuboid(outer_d*1.2, anchor=BOTTOM);
    }
}
