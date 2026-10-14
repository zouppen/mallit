include <BOSL2/std.scad>

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa=1;
$fs=0.2;
$align_msg = false;

pcb = [79, 50, 1.6];
tray_w = 1;
room_top = 13.8;
room_bottom = 2;
wall = 2;
tol = 0.2;
sma_panel_w = 1.5;
sma_w = 7.2;
sma_n = 4;
sma_sep = (45-sma_w)/(sma_n-1); // 5.933 väli
sma_z = 0.5;

hexa_d = 8;
hexa_wall = 1.5;
hexas = 9;

foot_hole = 4.2;
foot = 9;
foot_chamfer=3;

pcb_real = pcb + [2*tol, 2*tol, 2*tol];
inner_room = [pcb[0], pcb[1] - 2*tray_w, pcb[2] + room_top + room_bottom];
cover = [inner_room[0]+sma_panel_w, pcb[1]+2*wall, inner_room[2]+2*wall];

//%cuboid(pcb);
diff() {
    cuboid(cover, edges=[TOP+FWD, TOP+BACK], chamfer=wall) {
        tag("remove") {
            // Opening for PCB and components
            position(LEFT) cuboid(inner_room, anchor=LEFT) {
                up(room_bottom-tol) position(BOTTOM) cuboid(pcb_real, anchor=BOTTOM);
            }

            // SMA holes
            position(RIGHT+BOTTOM) up(wall+sma_z) ycopies(sma_sep, sma_n) cuboid(sma_w, anchor=BOTTOM);

            position(TOP) up(tol) zrot(90) grid_copies(n=hexas, spacing=hexa_d+hexa_wall, stagger="alt") {
                zcyl(h=wall+2*tol, d=hexa_d, $fn=6, anchor=TOP, spin=360/12);
            }
        }
        // Feet
        for (x = [LEFT, RIGHT]) {
            for (y = [FRONT, BACK]) {
                position(x+y+BOTTOM) {
                    cuboid([foot+wall, foot, wall], anchor=x-y+BOTTOM, edges=[x+y, y-x], rounding=foot_chamfer) {
                        tag("remove") move(-0.5*wall*x) zcyl(h=wall+tol, d=foot_hole);
                    }
                    edge = foot - foot_chamfer;
                    up(wall) cuboid([wall, edge, edge], anchor=x-y+BOTTOM, edges=TOP+y, chamfer=edge);
                }
            }
        }
    }
}
