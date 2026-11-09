include <BOSL2/std.scad>

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa=1;
$fs=0.2;
$align_msg = false;

psu = [115,100,50];
wall = 2;
mat = 5.5;
headroom = 50;
gap = 1; // The gap between the PSU and the lid
cham = 1;
box_wedge = 30;
plan_w = 0.8; // Only for the cutting guides
screw_top_d = 7.5;
screw_top_h = 2;

outer = psu + [2*mat+2*wall, mat+wall, mat+wall+headroom];
inner = psu + [2*mat, mat, mat+headroom];

holes = [
         [ LEFT,  215-32.5-150, 50/2-25/2],
         [ LEFT,  215-32.5-150, 50/2+25/2],
         [ RIGHT, 215-32.5-150, 50/2-25/2],
         ];

hole_d = 4.2;

module thingy($holes=true) {
    diff() {
        cuboid(outer, edges=["Z", TOP], chamfer=cham) {
            edge_mask(TOP+BACK)
                chamfer_edge_mask(chamfer=box_wedge);
            tag("remove") {
                position(FWD+BOTTOM) cuboid(inner, anchor=FWD+BOTTOM, edges=BACK+TOP, rounding=headroom);
                position(BACK+BOTTOM) cuboid([inner[0], wall, psu[2]+gap], anchor=BACK+BOTTOM);
                if ($holes) for (hole = holes) {
                        position(BOTTOM+FWD+hole[0]) move([0, hole[1], hole[2]]) {
                            xcyl(h=wall, d=hole_d, anchor=hole[0]);
                            cyl(h=screw_top_h, d1=screw_top_d, d2=hole_d, anchor=BOTTOM, orient=-hole[0]);
                        }
                }
            }
        }
    }
}

thingy();

// Plan for cutting the acoustic material
left(150) linear_extrude(plan_w) difference() {
    projection(true) down(psu[0]/2+mat+0.05) yrot(90) thingy($holes=false);
    projection(true) yrot(90) thingy();
}

left(300) cuboid([inner[0]-2*mat, inner[1]-headroom+headroom*PI/2, plan_w]);
