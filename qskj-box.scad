include <BOSL2/std.scad>

pcb_box = [36.8, 65.4, 22.6];
pcb_thickness = 1.6;
holes = [23.5+3, 55.5+3];
hole_d = 2.5;
support_d = 7;
wall = 2;
cooler_w = 47;
bottom_room = 3;
screw_terminal = [20, 7];
plateau_w = 10;
screw_up = 7;
screw_down = 4;
tol = 0.2;
thin_bottom = 0.5;

diff() {
    cuboid(pcb_box + [2*wall, 2*wall, wall+bottom_room], chamfer=wall, edges=BOTTOM) {
        down(bottom_room) {
            align(TOP, inside=true) cuboid(pcb_box);

            tag("keep") for (pos = [[-1,-1], [-1, 1], [1, -1], [1, 1]]) {
                move([0.5*pos[0]*holes[0], 0.5*pos[1]*holes[1]]) align(TOP, inside=true) cyl(d=hole_d, h=pcb_thickness, $fn=20) {
                    align(BOTTOM) move(1.8*pos) cuboid([support_d, support_d, pcb_box[2]-pcb_thickness]);
                }
            }
        }
        for (side = [LEFT, RIGHT]) {
            align(TOP+side, inside=true) cuboid([wall, cooler_w, pcb_box[2]+bottom_room]);
        }

        // Indent
        align(TOP, inside=true) cuboid([pcb_box[0] + wall, pcb_box[1] + wall, bottom_room]);

        // Wire input
        fwd(plateau_w) align(FRONT+TOP, inside=true) cuboid([screw_terminal[0], wall+plateau_w, screw_terminal[1]+bottom_room+pcb_thickness]);

        for (side = [FRONT, BACK]) {
            position(TOP+side) cuboid([$parent_size[0], plateau_w, wall], anchor = -side+TOP);

            // Screw up everything
            tag("remove") for (edge = [LEFT, RIGHT]) {
                move(-edge*plateau_w/2) move(side*plateau_w/2) position(edge+TOP+side) cyl(d1=screw_up, d2=screw_down, h=wall, anchor=TOP, $fn=20);
            }
        }
    }
}

// Top
up(pcb_box[2]/2+wall/2+20) diff() {
    cuboid([pcb_box[0]+wall-2*tol, pcb_box[1]+wall-2*tol, bottom_room-tol]) {
        tag("remove") tag_scope() diff() {
            align(BOTTOM, inside=true) cuboid([pcb_box[0], pcb_box[1], bottom_room-thin_bottom]);

            // Support pads
            for (pos = [[-1,-1], [-1, 1], [1, -1], [1, 1]]) {
                tag("remove") move([0.5*pos[0]*holes[0], 0.5*pos[1]*holes[1]]) align(TOP, inside=true) move(1.8*pos) cuboid([support_d, support_d, pcb_box[2]-pcb_thickness]);
            }
        }
        // Left and right walls
        for (pos = [LEFT, RIGHT]) {
            position(pos+TOP) cuboid([wall/2+tol,cooler_w-2*tol,bottom_room+pcb_thickness-tol], anchor=TOP-pos);
        }

        // Wire input wall
        position(FRONT+TOP) cuboid([screw_terminal[0]-2*tol,wall/2+tol, bottom_room+pcb_thickness], anchor=TOP+BACK);
    }
}
