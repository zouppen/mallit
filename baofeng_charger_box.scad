include <BOSL2/std.scad>
include <powerpole_lib.scad>

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa=1;
$fs=0.2;
$align_msg = false;

pcb_box = [26.5, 51.0, 15.7];
guide = 22.5;
y_pp = 30;
y_cable = 15;
wall = 2;
outside = pcb_box + [2*wall, y_pp+y_cable, 2*wall];
eps = 0.05;
cover = [outside[0]-2*wall, outside[1]-2*wall, wall+eps];
wire_room = [2*guide-pcb_box[0], pcb_box[1]+10+eps, pcb_box[2]+eps];
wire_d = 3.7;
screw_d = 2.2;
screw_h = 15.5;
screw_in = 5;
screw_pos = [outside[0]-2*screw_in, outside[1]-2*screw_in];
screw_cone_h = 5;
screw_cone_d = 6.75;

diff() {
    cuboid(outside) {
        // Cover opening
        attach(TOP, TOP, inside=true, shiftout=eps) {
            cuboid(cover);
        }

        // PP
        tag("remove") yrot(180) attach(BACK) powerpole_slot();

        ymove(outside[1]/2-pcb_box[1]/2-y_pp) {
            align(BOTTOM, inside=true, shiftout=-wall) {
                cuboid(pcb_box+[0,0,eps]);
                cuboid(wire_room);
            }
        }

        attach(FRONT, TOP, inside=true, shiftout=eps) zcyl(d=wire_d, h=y_cable);

        attach(TOP, TOP, inside=true) grid_copies(screw_pos) {
            zcyl(h=screw_h, d=screw_d) {
                position(TOP) {
                    zcyl(h=screw_cone_h, d1=screw_d, d2=screw_cone_d, anchor=TOP);
                }
            }
        }
    }
}
