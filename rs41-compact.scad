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
support_rail_start_y = 32;
support_rail_b = [4, 25];
headroom_bot = 5;
headroom_top = 5;
cover_pos = 4;
cover_indent = 1.5;
indent_width = 10;
screw_hole_dist = 4.5;
screw_hole_d = 1.5;
wall = 2;
raise = [1,1]; // Width, height
much = 200;
$fn = 100;

module pcb_positive() {
    // The base of the PCB
    tag("remove") cube(pcb) {
        // Peripheral connector
        translate(conn_adj) align(LEFT+BACK+BOTTOM) cube(conn);
        // Antenna wire hole
        translate(ant_adj) translate([pcb[0]/2,0,-pcb[2]/2]) attach(BACK) {
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
        up(cover_pos-1) for (a = [LEFT, RIGHT]) align(FRONT+TOP+a) cube([indent_width,cover_indent,cover_indent], spin=[180,0,0]);

        // Screw hole
        align(BOTTOM+BACK) tag("keep2") diff() {
            cube([2*screw_hole_dist,2*screw_hole_dist,headroom_bot])
            tag("remove") attach(TOP) cylinder(headroom_bot, d=screw_hole_d, orient=BOTTOM);
        }
    }
}

module bottom_part() diff("remove","keep keep2") {
    // The outer case
    translate([-wall-raise[0],-wall-cover_indent,pcb[2]+cover_pos]) cuboid([pcb[0]+2*wall+2*raise[0],wall+pcb[1]+conn_adj[1]+cover_indent,headroom_bot+pcb[2]+wall+cover_pos], anchor=TOP+LEFT+FRONT, rounding=wall, edges=["Z",BOT]) {
        tag("remove") down(raise[1]) {
            for (a = [LEFT, RIGHT]) {
                align(TOP+a) cube([wall, much, raise[1]]);
            }
            align(TOP+BACK) cube([much,wall, raise[1]]);
        }        
    }
    // The inner structure + antenna
    pcb_positive();
}

difference() {
    bottom_part();
    // PUPU logo has to be done using non-BOSL2-way
    translate([pcb[0]/2,pcb[1]/2+5,-headroom_bot-wall]) linear_extrude(0.4) scale(0.15) translate([-90,-70,0]) import("/home/joell/vektori/pupu-logo.svg");
}
