bottom_hole_dist = 120;
bottom_rise = 10;
width = 205;
height = 111;
rounding_w = 200;
rounding_h = 110;
rounding_r = 10;
max_depth = 80;
plateau_depth = 4;
wall = 3;
hole_d = 3.5;
hole_indent_depth = 0;
hole_indent_d = 7;
support_side = 20;
support_dist = 93; // x distance between supports

small_hole_depth=10;
small_hole_d = 2.3;

dc_converter_angle = 40;
dc_converter_side = 75;
dc_converter_hole_dist = 63;

ups_w = 57.8;
ups_h = 36.8;
ups_hole_pos = 4;

rpi_w = 85;
rpi_h = 56.1;
rpi_hole_pos = 3.5;
rpi_hole_dist = 56.8;
whole_plate();

ethernet_hole_d = 35;

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
                // DC Converter
                translate([50,-6,0]) {
                    difference() {
                        wall(dc_converter_side,dc_converter_side,dc_converter_angle,30);
                        rotate([0,dc_converter_angle-90,0]) {
                            first = (dc_converter_side-dc_converter_hole_dist)/2;
                            hole(first,0);
                            hole(first+dc_converter_hole_dist,0);
                        }
                    }
                }
                
                // PicoUPS
                translate([-30,7,0]) {
                    rotate([0,0,90]) {

                        difference() {
                            wall(ups_w,ups_h,0,10);
                            rotate([0,-90,0]) {
                                for (y = [-ups_w/2+ups_hole_pos,ups_w/2-ups_hole_pos]) {
                                    for (x = [ups_hole_pos,ups_h-ups_hole_pos]) {
                                        hole(x,y);
                                    }
                                }
                            }
                            // Screw helper
                            translate([-1,0,ups_h-5]) rotate([0,90,0]) cylinder(13,20,20,$fn=6);
                        }
                    }
                }
                
                // Raspberry Pi
                translate([-43,dc_converter_side/2-6,0]) {
                    rotate([0,0,-90]) {
                        difference() {
                            wall(rpi_w,rpi_h,0,10);
                            rotate([0,-90,0]) {
                                for (y = [-rpi_w/2+rpi_hole_pos,-rpi_w/2+rpi_hole_pos+rpi_hole_dist]) {
                                    for (x = [rpi_hole_pos,rpi_h-rpi_hole_pos]) {
                                        hole(x,y);
                                    }
                                }
                            }
                            // Screw helper
                            translate([-1,-10,rpi_h-5]) rotate([0,90,0]) cylinder(13,25,25,$fn=6);
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
        // Hole for Ethernet jack
        translate([0,-height/2+ethernet_hole_d*0.21,0]) rotate([0,0,90]) cylinder(max_depth,ethernet_hole_d/2, ethernet_hole_d/2, $fn=6);
        
        // Cable tie holes for future proofing
        difference() {
            union() {
                for (x = [-85:15:35]) {
                    for (y = [-40:10:40]) {
                        cabletie(x,y);
                    }
                }
            }
            // Some safe areas: Ethernet hole
            translate([-ethernet_hole_d/2,-height/2,0]) cube([ethernet_hole_d,ethernet_hole_d*0.8,max_depth]);
            
            // Not puncturing support
            translate([-support_dist/2-support_side,-height/2,0]) cube([support_side, support_side,max_depth]);
            
            // Risers not punctured
            translate([-width/2,5,0]) cube([width/2,height/2,max_depth]);

            // Attachment hole
            translate([-bottom_hole_dist/2-5,-5,0]) cube([20,10,max_depth]);
            
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
        }
    }
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

module hole(x, y) {
    translate([x,y,1]) {
        mirror([0,0,1]) {
            cylinder(small_hole_depth+1, small_hole_d/2, small_hole_d/2);
        }
    }
}

module cabletie(x, y) {
    translate([x,y,0]) {
        cube([5,2.5,30], center=true);
    }
}
