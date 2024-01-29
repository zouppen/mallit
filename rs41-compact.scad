include <BOSL2/std.scad>

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
support_rail_b = [4, 25];
headroom_bot = 5;
headroom_top = 5;
cover_pos = 5.2;
cover_indent = 1.5;
indent_width = 10;
screw_hole_dist = 4.5;
screw_hole_d = 1.5;
wall = 2;
raise = [1,1]; // Width, height
cover_indent_z = 1; // Height of the holes in the front part
cover_tolerance = 0.2; // Tolerance in the rails
much = 200;
$fn = 100;

// Derived constants
front_wall = wall + cover_indent;
back_wall = conn_adj[1];
side_wall = wall + raise[0];

// Antenna and PCB room without cover
module pcb_positive() {
    // The base of the PCB
    left(pcb[0]/2) cube(pcb) {
        // Peripheral connector
        translate(conn_adj) align(LEFT+BACK+BOTTOM) cube(conn);
        // Antenna wire hole
        translate(ant_adj) right(pcb[0]/2) attach(BACK) {
            cylinder(h=ant_h, d=ant_inner_d, $fn=8);
            tag("ant") cylinder(h=ant_h-wall, d=ant_d, anchor=BOTTOM, $fn=6) attach(TOP) top_half() sphere(d=ant_d, $fn=6); // Antenna outer part
        }
        // Support rails
        tag("keep") for (a = [LEFT, RIGHT]) {
            align(a+BOTTOM+BACK) fwd(support_rail_start_y) cube([support_rail[0], support_rail[1], headroom_bot]);
            
            align(a+BOTTOM+FRONT) cube([support_rail_b[0], support_rail_b[1], headroom_bot]);

        }
        // PCB "component area"
        align(BOTTOM) cube([pcb[0], pcb[1], headroom_bot]);
        // PCB "top clearout area
        align(TOP) cube([pcb[0], pcb[1], headroom_top]);

        // Indent of the cover
        up(cover_pos-cover_indent_z) for (a = [LEFT, RIGHT]) align(FRONT+BOTTOM+a) cube([indent_width,cover_indent,cover_indent], spin=[-90,0,0]);

        // Screw hole
        align(BOTTOM+BACK) tag("keep") tag_scope() diff() {
            cube([2*screw_hole_dist,2*screw_hole_dist,headroom_bot])
            tag("remove") attach(TOP) cylinder(headroom_bot, d=screw_hole_d, orient=BOTTOM);
        }
    }
}

module bottom_part() diff() {
    // Casing
    move([0, -front_wall, cover_pos]) cuboid([pcb[0]+2*side_wall, pcb[1]+front_wall+back_wall, wall+headroom_bot+cover_pos], rounding=wall, edges=["Z",BOT], anchor=FRONT+TOP) {
        // Make cuts for rails
        tag("remove") down(raise[1]) {
            for (a = [LEFT, RIGHT]) {
                align(TOP+a) cube([wall, much, raise[1]]);
            }
            align(TOP+BACK) cube([much,wall, raise[1]]);
        }
        // PUPU logo
        tag("remove") position(BOTTOM) linear_extrude(0.4) import_2d("/home/joell/vektori/pupu-logo.svg", [150.290,111.372], size=28, center=true);
    }
    // Carve interior + antenna
    tag("remove") pcb_positive();
}

module top_part() tag_scope() up(0) diff() {
    // Include "rims"
    rim_w = pcb[0] + 2*raise[0] + 2*cover_tolerance;
    rim_h = front_wall + pcb[1] + back_wall - wall + cover_tolerance;

    move([0, -front_wall, headroom_top+wall]) cuboid([pcb[0]+2*side_wall, pcb[1]+front_wall+back_wall, wall+headroom_top-cover_pos+raise[1]], rounding=wall, edges=["Z",TOP], anchor=FRONT+TOP) {
        // Remove bottom margin
        tag("remove") align(BOTTOM, inside=true) cube([much,much,cover_tolerance]);
        // Remove inside rim
        tag("remove") align(FRONT+BOTTOM, inside=true) cube([rim_w, rim_h, raise[1] + cover_tolerance]);
    }
}

bottom_part();
top_part();

module import_2d(file_name, file_geom, size=1, center, anchor, spin) {
    anchor = get_anchor(anchor, center, [-1,-1], [-1,-1]);
    ratio = size/file_geom[0];
    attachable(anchor, spin, two_d=true, size=ratio*file_geom) {
        scale(ratio) move(-file_geom/2) import(file_name);
        children();
    }
}
