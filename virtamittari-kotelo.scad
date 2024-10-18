include <BOSL2/std.scad>
include <BOSL2/screws.scad>

inside_w = 30.7;
inside_l = 1.8*25.4;
upper_part_h = 6;
lower_part_h = 12;
wall = 2;
rail_w = 1.2;
pcb_thickness = 1.5;
side_w = 7;
hole_d = 4;
tol = 0.2;
daughterboard_w = 18.4;
daughterboard_h = 11.5;
daughterboard_wire_d = 1;
daughterboard_wire_pos = 2;
daughterboard_x = rail_w-tol;

sep = true;

inside_h = upper_part_h + lower_part_h + pcb_thickness;

diff() {
    // Outer
    cuboid([2*wall+inside_w, 3*wall+inside_l, 2*wall+inside_h], chamfer=wall, edges=[TOP,"Z"]) {
        // Inner
        fwd(wall) align(BACK,inside=true) cuboid([inside_w-2*rail_w, inside_l, inside_h]);
        // PCB insert
        fwd(wall) down(wall+upper_part_h) align(TOP+BACK, inside=true) cuboid([inside_w,inside_l,pcb_thickness]);
        align(BOTTOM, inside=true) tag("foot") cuboid([2*wall+inside_w+2*side_w, inside_l+3*wall, wall], edges="Z", chamfer=side_w+wall) {
            // Holes
            tag("remove") for (pos = [-1, 1]) {
                right(pos*(inside_w/2+wall+side_w/2)) cyl(d=hole_d, h=wall, $fn=8);
            }
        }
        // Front cut
        align(FRONT+BOTTOM, inside=true) cuboid([inside_w, 2*wall, inside_h+wall]) {
            // Front cut triangle
            align(BACK, inside=true) cuboid([inside_w+wall, wall, inside_h+wall], chamfer=wall, edges=[FWD+LEFT, FWD+RIGHT]);
        }

        // Slide panel
        down(sep ? 1.5*inside_h : 0) align(FRONT+BOTTOM, inside=true) tag("luukku") cuboid([inside_w-2*tol, 2*wall-tol, inside_h+wall-tol]) {
            align(BACK, inside=true) cuboid([inside_w+wall-4*tol, wall, inside_h+wall-tol], chamfer=wall, edges=[FWD+LEFT, FWD+RIGHT]);
            // Daughterboard cut
            left(daughterboard_x) align(TOP+RIGHT, inside=true) tag("remove") cuboid([daughterboard_w,2*wall,daughterboard_h]) {
                // Wire out
                right(daughterboard_wire_pos) align(BOTTOM+LEFT) cuboid([1,2*wall,1]);
                align(BOTTOM) cuboid([4.2,2*wall,2.1]);
            }
        }
    }
}
