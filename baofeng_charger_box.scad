include <BOSL2/std.scad>
include <powerpole_lib.scad>

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa=1;
$fs=0.2;
$align_msg = false;

pcb_box = [26.5, 51.4, 15.7];
guide = 22.5;
y_pp = 30;
y_cable = 14.6;
wall = 2;
outside = pcb_box + [2*wall, y_pp+y_cable, 2*wall];
eps = 0.05;
cover = [outside[0]-2*wall, outside[1]-2*wall, wall+eps];
wire_room = [2*guide-pcb_box[0], pcb_box[1]+10+eps, pcb_box[2]+eps];
wire_hole = [3.7, 3.7];
// wire_hole = [4, 2.2]; // Ilkka's
screw_d = 2.2;
screw_h = 15.5;
screw_in = 5;
screw_pos = [outside[0]-2*screw_in, outside[1]-2*screw_in];
screw_cone_h = 5;
screw_cone_d = 6.75;
cover_h = 0.8;
tol = 0.4;

wire_round = min(wire_hole)/2;

module charger_box($tune_screw=0) {
    tag("base") cuboid(outside) {
        // Cover opening
        attach(TOP, TOP, inside=true, shiftout=eps) {
            tag("remove_base") cuboid(cover);
        }

        // PP
        tag("remove_base") yrot(180) attach(BACK) powerpole_slot();

        ymove(outside[1]/2-pcb_box[1]/2-y_pp) {
            align(BOTTOM, inside=true, shiftout=-wall) tag("remove_base") {
                cuboid(pcb_box+[0,0,eps]);
                cuboid(wire_room);
            }
        }

        attach(FRONT, TOP, inside=true, shiftout=eps) tag("remove_base") cuboid([wire_hole[0], wire_hole[1], y_cable], rounding=wire_round, edges="Z");

        up($tune_screw) attach(TOP, TOP, inside=true) tag("remove") grid_copies(screw_pos) {
            zcyl(h=screw_h, d=screw_d) {
                position(TOP) {
                    zcyl(h=screw_cone_h, d1=screw_d, d2=screw_cone_d, anchor=TOP);
                }
            }
        }

        // Top cover
        position(TOP) tag("cover") {
            cuboid([outside[0]-2*wall-tol, outside[1]-2*wall-tol, wall-tol/2], anchor=TOP) {
                position(TOP) cuboid([outside[0], outside[1], cover_h], anchor=BOTTOM);
            }
        }
    }
}


diff("remove remove_base", "keep") hide("cover") {
    charger_box();
}

up(10) diff("remove remove_top", "keep") hide("base remove_base") {
    charger_box($tune_screw=cover_h+eps);
}
