bottom_hole_dist = 120;
bottom_rise = 10;
width = 205;
height = 115;
rounding_w = 200;
rounding_h = 110;
rounding_r = 10;
max_depth = 80;
plateau_depth = 3;
wall = 3;
hole_d = 3;
hole_indent_depth = 0;
hole_indent_d = 7;
support_side = 20;
support_dist = 93; // x distance between supports

hole_depth=10;
dc_converter_side = 75;
dc_converter_hole_dist = 63;
dc_converter_hole_d = 2.3;

whole_plate();

module whole_plate() {
    difference() {
        union() {
            // Additive
            plateau();
            for (mx = [[0,0,0], [1,0,0]]) {
                mirror(mx) {
                    for (my = [[0,0,0], [0,1,0]]) {
                        mirror(my) {
                            support();
                        }
                    }
                }
            }
            translate([0,0,plateau_depth+bottom_rise]) {
    //wall(30,40,0);
    translate([50,-6,0]) {
        difference() {
            angle=40;
            wall(dc_converter_side,dc_converter_side,angle,30);
            rotate([0,angle+90,0]) {
                translate([-dc_converter_side/2,0,0]) #dc_converter_holes();
            }
        }
    }
}

        }
        // Substractive
        for (mx = [[0,0,0], [1,0,0]]) {
            mirror(mx) {
                for (my = [[0,0,0], [0,1,0]]) {
                    mirror(my) {
                        rounding();
                        mount_hole();
                    }
                }
            }
        }
    }
}

module wall(width, height, rotation, leg=10) {
    translate([0,-width/2,0]) {
        rotate([0,rotation,0]) {
            cube([wall,width,height]);
        }
    }
    
    trig_x = sin(rotation)*height+cos(rotation)*wall;
    trig_y = cos(rotation)*height-sin(rotation)*wall;

    hull() {
    for (my = [[0,0,0],[0,1,0]]) {
        mirror(my) {
            translate([0,width/2,0]) {
                rotate([90,0,0]) {
                    linear_extrude(1) {
                        polygon([[0, 0], [leg+wall/2,0], [trig_x,trig_y]]);
                    }
                }
            }
        }
    }}
}

module rounding() {
    translate([rounding_w/2, rounding_h/2, 0]) {
        cylinder(max_depth, rounding_r,rounding_r);
    }
}

module plateau() {
    translate([0,0,plateau_depth/2+bottom_rise]) {
        cube([width,height,plateau_depth], center=true);
    }
}

module mount_hole() {
    translate([bottom_hole_dist/2,0,0]) {
        // Through-hole
        cylinder(max_depth, hole_d/2, hole_d/2);
        // Indentation
        translate([0,0,bottom_rise+plateau_depth-hole_indent_depth]) {
            cylinder(max_depth, hole_indent_d/2, hole_indent_d/2);
        }
    }
}

module support() {
    translate([support_dist/2,height/2-support_side,0]) {
        cube([support_side,support_side,bottom_rise]);
    }
}

module dc_converter_holes() {
    for (x = [0, dc_converter_hole_dist]) {
        translate([x-dc_converter_hole_dist/2,0,-1]) {
            cylinder(hole_depth+1, dc_converter_hole_d/2, dc_converter_hole_d/2);
        }
    }
}
