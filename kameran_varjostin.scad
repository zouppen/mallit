// Screw hole indentation
screw_indent = 1;
// Screw head radius
screw_top = 8;
// Screw hole radius
screw_bot = 4;
// Screw head height
screw_height = 3;
// No need to change unless you're going to do a BIG one
screw_cutmargin = 5;
// How fine are the circles
$fn = 40;

// Hole for the screw.
module screwhole() {
    translate([0,0,-screw_indent]) {
        rotate_extrude() {
            polygon([[0,screw_indent],[screw_top/2,screw_indent],[screw_top/2,0],[screw_bot/2,-screw_height],[screw_bot/2,-screw_height-screw_cutmargin], [0,-screw_height-screw_cutmargin]]);
        }
    }
}

module flap(width) {
    border_width = 4;
    border_height = 4;
    import("reuna.svg");
    translate([width,0,0]) mirror([1,0,0]) import("reuna.svg");
    translate([border_width,0,0]) square([width-2*border_width,border_height]);
}

module platform(width, height) {
    intersection() {
        linear_extrude(height) flap(width);
        mirror([0,0,1]) rotate([0,90,0]) linear_extrude(width) flap(height);
    }
}

thing_height=17;
thing_width=115;
screw_adjust=9;
flap_width=110;
flap_height=55;
flap_thickness=2;

difference() {
    union() {
        rotate([90,0,90]) platform(thing_height,thing_width);
        // Flap
        translate([(thing_width-flap_width)/2,thing_height/2,0]) {
            rotate([90,0,0]) {
                linear_extrude(flap_thickness, center=true) {
                    scale(flap_height/4) {
                        flap(flap_width/flap_height*4);
                    }
                }
            }
        }
    }
    translate([0,thing_height/2,4]) {
        translate([screw_adjust,0,0]) screwhole();
        translate([thing_width-screw_adjust,0,0]) screwhole();
    }
}
