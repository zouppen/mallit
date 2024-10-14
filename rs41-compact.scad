include <BOSL2/std.scad>
include <BOSL2/structs.scad>
include <elastobutton.scad>

pcb = [37.4, 120.4, 1.2];
conn = [12.4, 10, 7.2]; // Including pcb thickness
conn_adj = [0, 5.65, pcb[2]];
ant_h = 136;
ant_d = 9;
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
cover_pos = 4;
cover_indent = 1.6; // Wedge thingy size
indent_width = 10;
screw_hole_dist = 4.5;
screw_hole_d = 1.5;
wall = 2;
raise = [1,1]; // Width, height
cover_indent_z = 1; // Height of the holes in the front part
cover_tolerance = 0.2; // Tolerance in the rails. One layer height is a good guess
button_pos = 13;
antenna_eccentricity = [0.15,-2.34]; // From back
pcb_hold_bar_y = 28; // Mind the battery holder start
strap_opening = [25.6, 4];
much = 200;

// Display and STL export helpers
displace = "z";
show_color = false;

// Lookup table for variable displace for handy ways to move covers for printing and side views
displacements = struct_set([], ["x",   [[ -50,    0,   0], 0, 0],
                                "y",   [[   0, -150,   0], 0, 0],
                                "z",   [[   0,    0,  20], 0, 0],
                                "print", [[ 80, 0, headroom_top_front-headroom_bot], -45, [ 0, 180, -45]],
                                "top", [[ 0, 0, 0], false, [0,180,0]],
                                "bottom", [[ 0, 0, 0], -45, false]
                                ]);

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
            cylinder(h=wall, d1=ant_inner_d*3, d2=ant_inner_d, $fn=6, spin=180/6)
            align(BOTTOM, inside=true) cylinder(h=ant_h, d=ant_inner_d, $fn=6);
            tag("lower") move(antenna_eccentricity) cylinder(h=ant_h-wall, d=ant_d, anchor=BOTTOM, $fn=8, spin=180/8) attach(TOP) top_half() up(0.5) scale(1.085) sphere(d=ant_d, $fn=8); // Antenna outer part
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
        tag("keep-lower") move([0,wall+cover_tolerance,cover_pos-raise[1]]) align(BACK+BOTTOM) {
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
    size = [pcb[0]+2*side_wall, pcb[1]+front_wall+back_wall, wall+headroom_top_front-cover_pos+raise[1]];
    cuboid(size, chamfer=wall, edges=["Z",TOP], anchor=anchor, spin=spin, orient=orient) {
        children();
    }
}

module wedge_thingy(remove_tag) {
    add_soluble = ends_with($tag, $part_name);
    soluble_w = 0.7;
    align(BOTTOM+BACK) cube([$parent_size[0]-2*cover_tolerance, wall, cover_tolerance+cover_indent_z+cover_indent]) {

        for (a=[LEFT, RIGHT]) {
            // Opening for the wedge
            tag(remove_tag) align(FRONT+BOTTOM+a, inside=true) move(cover_tolerance*a) move([0, -cover_indent-cover_tolerance, 0]) cube([indent_width, cover_indent+cover_tolerance, cover_indent]);

            // Wedge (positive part)
            wedge_w = indent_width-2*cover_tolerance;
            align(FRONT+BOTTOM+a) wedge([wedge_w,cover_indent,cover_indent], spin=[180,0,0]) {
                if (add_soluble) {
                    feature("red") tag_scope() diff() align(BOTTOM) {
                        // Make support only to open sides
                        cube([wedge_w,cover_indent,cover_tolerance + cover_indent_z])
                            tag("remove") align(FRONT, inside=true) cube([wedge_w-2*soluble_w,cover_indent, cover_tolerance + cover_indent_z]);
                    }
                }
            }
        }
    }
}

module bottom_part() tag_scope() diff("rm rm-lower", "keep keep-lower keep-color") hide("rm-upper keep-upper upper") final_touch(){
    $part_name = "lower";
    // Casing
    move([0, -front_wall, cover_pos]) cuboid([pcb[0]+2*side_wall, pcb[1]+front_wall+back_wall, wall+headroom_bot+cover_pos], chamfer=wall, edges=["Z",BOT], anchor=FRONT+TOP) {
        // Make cuts for rails
        tag("rm") down(raise[1]) {
            for (a = [LEFT, RIGHT]) {
                align(TOP+a) cube([wall, much, raise[1]]);
            }
            align(TOP+BACK) cube([much,back_wall-wall, raise[1]]);
        }
    }
    // Carve interior + antenna
    tag("rm") pcb_positive();
}

module strap_opening() {
    // The walls
    w = pcb[0]+2*(wall+raise[0]);
    strap_wall = 1;
    cube([pcb[0], strap_opening[0]+2*strap_wall, strap_opening[1]+2*strap_wall], anchor=TOP)
        tag("remove") align(CENTER) cube([w,strap_opening[0],strap_opening[1]]) {
        for (a = [LEFT, RIGHT]) {
            // Rounding
            move(-1*a) attach(a) prismoid(size1=strap_opening, size2=[strap_opening[0]+2, strap_opening[1]+2], h=2);
        }
        children();
    }
}

module top_part() tag_scope() diff("rm rm-upper" ,"keep keep-upper keep-color") hide("rm-lower keep-lower lower") final_touch() {
    $part_name = "upper";
    // Include "rims"
    rim_w = pcb[0] + 2*raise[0] + 2*cover_tolerance;
    rim_h = front_wall + pcb[1] + wall + cover_tolerance;

    move([0, -front_wall, headroom_top_front+wall]) top_outer(anchor=FRONT+TOP) {
        // Remove bottom margin
        tag("rm") align(BOTTOM, inside=true) cube([much,much,cover_tolerance]);
        // Remove inside rim
        tag("rm") align(FRONT+BOTTOM, inside=true) cube([rim_w, rim_h, raise[1] + cover_tolerance]);

        // PUPU logo
        position(TOP) {
            feature("yellow") half_of(BACK, cp=[0,2,0]) pupu(0.4)
                feature("white") position(BOTTOM) half_of(BACK, cp=[0,2,0]) pupu(0.4);
            feature("white") half_of(FWD, cp=[0,2,0]) pupu(0.4);
        }

        // Button
        but_size = 8;
        shaft_h = 14;
        align(BACK+LEFT+TOP, inside=true) right(wall+raise[0]) fwd(button_pos-but_size/2) elastobutton(but_size, shaft_h, raise[0]);

        // LED hole
        position(TOP+BACK+RIGHT) move([-5,-12]) orient(BOTTOM) {
            tag("rm") cylinder(h=shaft_h, d=5, $fn=3);
            feature("blue") cylinder(1, d=5, $fn=3);
        }
    }
    // Carve interior + antenna
    tag("rm") pcb_positive();
}

module pupu(extrude) {
    import_2d("assets/pupu-logo.svg", [150.290,111.372], size=28, anchor=TOP, extrude=extrude) children();
}

module import_2d(file_name, file_geom, size=1, center, anchor, spin, extrude=0.4) {
    anchor = get_anchor(anchor, center, [-1,-1], [-1,-1]);
    ratio = size/file_geom[0];
    attachable(anchor, spin, size=list_insert(ratio*file_geom, 2, extrude)) {
        linear_extrude(extrude, center=true) scale(ratio) move(-file_geom/2) import(file_name);
        children();
    }
}

module feature(col) {
    if (show_color == false) {
        tag("rm") children(); // Carve
    } else if (col == show_color) {
        tag("keep-color") children();
    } else {
        recolor(col) children();
    }
}

module final_touch() {
    if (show_color == true || show_color == false) {
        children();
    } else {
        show_only("keep-color") children();
    }
}

placement = struct_val(displacements, displace, [[0,0,0],0,0]);

if (placement[1] != false) rotate(placement[1]) diff() {
    bottom_part();
    if (show_color == false || show_color == true) down(0.4) back(pcb[1]/2) strap_opening();
};
if (placement[2] != false) move(placement[0]) rotate(placement[2]) top_part();
