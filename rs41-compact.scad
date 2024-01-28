include <BOSL2/std.scad>

pcb = [37.4, 120.4, 1.2];
conn = [12.4, 10, 7.2]; // Including pcb thickness
conn_adj = [0, 5.65, pcb[2]];
ant_h = 136;
ant_d = 8;
ant_inner_d = 1.8;
ant_adj = [-3,0,-0.5];
tolerance = 0.2;
support_rail = [4, 50];
support_start_y = 32;
headroom_bot = 5;
headroom_top = 5;
cover_pos = 3;
cover_indent = 1;
indent_width = 5;
screw_hole_dist = 4.5;
screw_hole_d = 1.5;
wall = 2;
$fn = 100;

module pcb_positive() {
    // The base of the PCB
    tag("remove") cube(pcb) {
        // Peripheral connector
        translate(conn_adj) align(LEFT+BACK+BOTTOM) cube(conn);
        // Antenna wire hole
        translate(ant_adj) translate([pcb[0]/2,0,-pcb[2]/2]) attach(BACK) {
            cylinder(h=ant_h, d=ant_inner_d, $fn=8);
            tag("") cylinder(h=ant_h-wall, d=ant_d, anchor=BOTTOM) attach(TOP) top_half() sphere(d=ant_d); // Antenna outer part
        }
        // Support rails
        tag("keep") for (a = [LEFT, RIGHT]) {
            align(a+BOTTOM+BACK) fwd(support_start_y) cube([support_rail[0], support_rail[1], headroom_bot]);
        }
        // PCB "component area"
        align(BOTTOM) cube([pcb[0], pcb[1], headroom_bot]);
        // PCB "top clearout area
        align(TOP) cube([pcb[0], pcb[1], headroom_top]);

        // Indent of the cover
        for (a = [LEFT, RIGHT]) translate([0,-0.5*cover_indent,cover_pos-1.5*cover_indent]) align(FRONT+a) rotate([270,0,0]) wedge([indent_width,cover_indent,cover_indent], spin=[0,180,0]);

        // Screw hole
        align(BOTTOM+BACK) tag("keep2") diff() {
            cube([2*screw_hole_dist,2*screw_hole_dist,headroom_bot])
            tag("remove") attach(TOP) cylinder(headroom_bot, d=screw_hole_d, orient=BOTTOM);
        }
    }
}
/*
!holetsu();

module holetsu() tag("keepo") diff() {
    cube([2*screw_hole_dist,2*screw_hole_dist,headroom_bot])
    tag("remove") attach(TOP) cylinder(headroom_bot, d=screw_hole_d, orient=BOTTOM);
}
*/
//!tag("keep") diff() {
//   !tag("keep") 
//!diff() cube([2*screw_hole_dist,2*screw_hole_dist,headroom_bot])
//    tag("remove") translate([0,0,0]) cylinder(headroom_bot, d=screw_hole_d, align=TOP);


diff("remove","keep keep2") {
    // The outer case
    translate([-wall,-wall-cover_indent,pcb[2]+cover_pos]) cuboid([pcb[0]+2*wall,wall+pcb[1]+conn_adj[1]+cover_indent,headroom_bot+pcb[2]+wall+cover_pos], anchor=TOP+LEFT+FRONT, rounding=wall, edges=["Z",BOT]);
    // The inner structure + antenna
    pcb_positive();
}
