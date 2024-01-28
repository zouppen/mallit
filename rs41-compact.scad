include <BOSL2/std.scad>

pcb_w = 37;
pcb_h = 120;
inner_h = 22;
wall = 2;
rounding = 2;
ant_d = 8;
ant_inner_d = 1.2;
ant_h = 136;
ant_pos = [-15.5,-10+4.5];
conn_size = [12.8,7.5];
conn_pos = [12.1,-7.25];

diff()
    cuboid([pcb_w+2*wall,pcb_h+wall, inner_h+2*wall], anchor=BOTTOM, edges=TOP, rounding=rounding) {
        tag("remove") translate([0,-wall/2, wall]) attach(BOTTOM) cube([pcb_w, pcb_h, inner_h], orient=DOWN, anchor=BOTTOM);
        attach(BACK) translate(ant_pos) {
            cylinder(h=ant_h-wall, d=ant_d, anchor=BOTTOM) attach(TOP) top_half() sphere(d=ant_d);
            tag("remove") translate([0,0,-wall]) cylinder(h=ant_h, d=ant_inner_d, anchor=BOTTOM);
            //tag("remove") translate(conn_pos) cube([
        }
        attach(BACK) tag("remove") translate(conn_pos) cube([conn_size[0],conn_size[1],wall], anchor=TOP);
    }
