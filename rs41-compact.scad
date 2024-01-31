include <BOSL2/std.scad>
include <BOSL2/structs.scad>

pcb = [37.4, 120.4, 1.2];
conn = [12.4, 10, 7.2]; // Including pcb thickness
conn_adj = [0, 5.65, pcb[2]];
ant_h = 136;
ant_d = 8;
ant_inner_d = 1.8;
ant_adj = [-3,0,-1.1];
tolerance = 0.2;
support_rail = [4, 50];
support_rail_start_y = 32;
support_rail_b = [4, 30];
headroom_bot = 5;
headroom_top_front = 18; // Not including the PCB!
headroom_top_back = 6; // Not including the PCB!
headroom_split_y = 23;
cover_pos = 3;
cover_indent = 1.5;
indent_width = 10;
screw_hole_dist = 4.5;
screw_hole_d = 1.5;
wall = 2;
raise = [1,1]; // Width, height
cover_indent_z = 1; // Height of the holes in the front part
cover_tolerance = 0.2; // Tolerance in the rails. One layer height is a good guess
antenna_eccentricity_z = -1.2;
pcb_hold_bar_y = 30; // Battery holder start
much = 200;
displace = "z";
$fn = 100;

// Lookup table for variable displace for handy ways to move covers for printing and side views
displacements = struct_set([], ["x", [ -50,    0,   0],
                                "y", [   0, -150,   0],
                                "z", [   0,    0,  20]]);

// Derived constants
front_wall = wall + cover_indent;
back_wall = conn_adj[1];
side_wall = wall + raise[0];

// Antenna and PCB room without cover
module pcb_positive() {
    // The base of the PCB
    left(pcb[0]/2) cube(pcb) {
        // Peripheral connector
        move(conn_adj) align(LEFT+BACK+BOTTOM) cube(conn);
        // Antenna wire hole
        move(ant_adj) right(pcb[0]/2) attach(BACK) {
            cylinder(h=wall, d1=ant_inner_d*3, d2=ant_inner_d, $fn=5, spin=180/5-90)
            align(BOTTOM, inside=true) cylinder(h=ant_h, d=ant_inner_d, $fn=5);
            tag("lower") back(antenna_eccentricity_z) cylinder(h=ant_h-wall, d=ant_d, anchor=BOTTOM, $fn=8, spin=180/8) attach(TOP) top_half() scale(1.085)sphere(d=ant_d, $fn=8); // Antenna outer part
        }
        // Support rails
        tag("keep-lower") for (a = [LEFT, RIGHT]) {
            align(a+BOTTOM+BACK) fwd(support_rail_start_y) cube([support_rail[0], support_rail[1], headroom_bot]);
            
            align(a+BOTTOM+FRONT) cube([support_rail_b[0], support_rail_b[1], headroom_bot]);

        }
        // PCB clearout area (top+bottom)
        align(TOP) down(headroom_bot+pcb[2]) headroom() {
            // PCB supporter
            tag("keep-upper") align(TOP+FRONT, inside=true) back(pcb_hold_bar_y-wall) cube([pcb[0], wall, headroom_top_front-cover_pos-cover_tolerance]) align(BOTTOM,BOTTOM) prismoid([pcb[0], wall], [wall,wall], cover_pos-pcb[2]);

            // Top pillar for the wedge
            tag("keep-upper") align(TOP+FRONT, inside=true) {
                // The front wedge thingy
                cube([pcb[0], cover_tolerance+wall, headroom_top_front-cover_pos-cover_tolerance]) {
                    wedge_thingy("rm-lower");
                }
            }

            // Slight cut for the back
            align(TOP+BACK, inside=true) tag("rm-upper") down(headroom_top_front-headroom_top_back) cube([pcb[0],4,wall+cover_tolerance], spin=[90,0,0]);
        }

        // Screw hole
        align(BOTTOM+BACK) tag("keep-lower") tag_scope() diff() {
            cube([2*screw_hole_dist,2*screw_hole_dist,headroom_bot])
            tag("remove") attach(TOP) cylinder(headroom_bot, d=screw_hole_d, orient=BOTTOM);
        }

        // Back part wedge thingy
        tag("keep-lower") move([0,wall+cover_tolerance,cover_pos]) align(BACK+BOTTOM) {
            cube([pcb[0],wall+cover_tolerance]) {
                rotate([180,0,0]) wedge_thingy("rm-upper");
            }
        }
    }
}

module headroom(center, anchor, spin=0, orient=UP) {

    anchor = get_anchor(anchor, center, -[1,1,1], -[1,1,1]);
    size = [pcb[0], pcb[1], headroom_bot + headroom_top_front];
    attachable(anchor,spin,orient, size=size) {
        tag_scope() diff() {
            cube(size, center=true) align(TOP+BACK, inside=true) tag("remove") cube([pcb[0], headroom_split_y, headroom_top_front - headroom_top_back]);
        }
        children();
    }
}

// Top part of the case, outer geometry
module top_outer(center, anchor, spin=0, orient=UP) {
    anchor = get_anchor(anchor, center, -[1,1,1], -[1,1,1]);
    size = [pcb[0]+2*side_wall, pcb[1]+front_wall+back_wall, wall+headroom_top_front-cover_pos+raise[1]];
    gap = headroom_top_front-headroom_top_back;
    attachable(anchor,spin,orient, size=size) {
        down(gap/2) cuboid(size-[0,0,gap], rounding=wall, edges=["Z",TOP])
            align(BOTTOM+FRONT, inside=true) cuboid(size-[0,headroom_split_y+back_wall-wall,0], rounding=wall, edges=["Z",TOP]);
        children();
    }
}

module wedge_thingy(remove_tag) {
    for (a=[LEFT, RIGHT]) {
        // Opening for the wedge
        tag(remove_tag) align(BOTTOM+BACK+a) move([0, -wall, -cover_tolerance-cover_indent_z]) cube([indent_width, cover_indent+cover_tolerance, cover_indent]);

        // Wedge (positive part)
        wedge_w = indent_width-2*cover_tolerance;
        align(BOTTOM+BACK+a) move(-cover_tolerance*a) cube([wedge_w,wall, cover_tolerance+cover_indent_z+cover_indent])
            align(FRONT+BOTTOM) wedge([wedge_w,cover_indent,cover_indent], spin=[180,0,0]);
    }
}

module bottom_part() tag_scope() diff("rm rm-lower", "keep keep-lower") hide("rm-upper keep-upper upper") {
    // Casing
    move([0, -front_wall, cover_pos]) cuboid([pcb[0]+2*side_wall, pcb[1]+front_wall+back_wall, wall+headroom_bot+cover_pos], rounding=wall, edges=["Z",BOT], anchor=FRONT+TOP) {
        // Make cuts for rails
        tag("rm") down(raise[1]) {
            for (a = [LEFT, RIGHT]) {
                align(TOP+a) cube([wall, much, raise[1]]);
            }
            align(TOP+BACK) cube([much,wall, raise[1]]);
        }
        // PUPU logo
        tag("rm") position(BOTTOM) linear_extrude(0.4) import_2d("/home/joell/vektori/pupu-logo.svg", [150.290,111.372], size=28, center=true);
    }
    // Carve interior + antenna
    tag("rm") pcb_positive();
}

module top_part() tag_scope() diff("rm rm-upper","keep keep-upper") hide("rm-lower keep-lower lower") {
    // Include "rims"
    rim_w = pcb[0] + 2*raise[0] + 2*cover_tolerance;
    rim_h = front_wall + pcb[1] + back_wall - wall + cover_tolerance;

    move([0, -front_wall, headroom_top_front+wall]) top_outer(anchor=FRONT+TOP) {
        // Remove bottom margin
        tag("rm") align(BOTTOM, inside=true) cube([much,much,cover_tolerance]);
        // Remove inside rim
        tag("rm") align(FRONT+BOTTOM, inside=true) cube([rim_w, rim_h, raise[1] + cover_tolerance]);
    }
    // Carve interior + antenna
    tag("rm") pcb_positive();
}

module import_2d(file_name, file_geom, size=1, center, anchor, spin) {
    anchor = get_anchor(anchor, center, [-1,-1], [-1,-1]);
    ratio = size/file_geom[0];
    attachable(anchor, spin, two_d=true, size=ratio*file_geom) {
        scale(ratio) move(-file_geom/2) import(file_name);
        children();
    }
}

bottom_part();
move(struct_val(displacements, displace, [0,0,0])) top_part();
