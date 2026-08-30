// Anderson PowerPole like housing
// compatible with original contacts.
//
// Written before BOSL2 so not converted to use it.

thinwall=0.8;
cupdepth=8.25;
cupwidth=7.6;
margin=0.2; // make the lower part a bit smaller
backwall=2*thinwall+margin/2; // Thickness of the wall of the back side of the plug
tongue_angle=18;
tongue_thickness=1;
tongue_rise=7; // Adjust this with the angle
tongue_depth=2.6; // From connector tip to tongue tip
tongue_width=3.5; // On y axis
tonguelike_h = 1.3; // Tongue replacement height
conn_spacing=7.9; // Spacing between connectors
hole_x = 10;
hole_r = 1.1;
wedge_slope = 0.4; // 3D printing aid wedges

// Some magic values
lower_pole_inner_h = cupwidth/2-backwall;

// Square pipe, from origo
module sqpipe(d, w, h, wall) {
    difference() {
        cube([d,w,h]);
        translate([-wall,wall,wall]) {
            cube([d+2*wall,w-2*wall,h-2*wall]);
        }
    }
}

// PowerPolish contact cup, centered on y axis and nudged on z axis
module poletip(d, w, h, wall, wall_bottom, fill=false) {
    difference() {
        // Outer
        translate([0,-w/2,0]) cube([d,w,h]);
        // Inner
        if (!fill)
            translate([-thinwall,-w/2+wall,-wall_bottom]) cube([d,w-2*wall,h]);
    }
}

module pole(backdepth, tongue, cap) {
    // Front part
    difference() {
        union() {
            // Upper part
            poletip(cupdepth+thinwall, cupwidth, cupwidth/2, thinwall, thinwall);
            // Lower part
            rotate([180,0,180]) {
                translate([-(cupdepth+thinwall),0,0]) {
                    lower_pole_h = cupwidth/2-thinwall-margin;
                    poletip(cupdepth+thinwall, cupwidth-2*thinwall-margin, lower_pole_h, thinwall, lower_pole_h - lower_pole_inner_h, cap);
                }
            }
        }
        cube([2*cupdepth,cupwidth+margin,margin], center=true);
    }

    if (cap) {
        // Draw nothing
    } else if (tongue) {
        // Emulates a metal strip
        translate([tongue_rise+tongue_depth,0,-cupwidth/2+thinwall+margin]) {
            tongue(tongue_angle, tongue_width, tongue_rise, tongue_thickness);
        }
    } else {
        // For PCB mounts
        tonguelike_x = cupdepth*0.3; // Visual guess
        translate([tongue_depth,-cupwidth/2+thinwall+margin/2,-lower_pole_inner_h]) {
            cube([tonguelike_x,cupwidth-2*thinwall-margin,tonguelike_h]);
        }
        // PCB mount platform wedge
        translate([tongue_depth+tonguelike_x,cupwidth/2-thinwall-margin/2,-lower_pole_inner_h]) {
            rotate([90,0,0]) wedge(tonguelike_h,wedge_slope,cupwidth-2*thinwall-margin);
        }
    }

    // Cap back is rendered in poles function
    if (!cap) {
        // Back part
        translate([cupdepth,-cupwidth/2,-cupwidth/2]) {
            sqpipe(backdepth, cupwidth, cupwidth, backwall);
        }

        // Back weddge to ease printing
        translate([cupdepth+thinwall,-cupwidth/2,cupwidth/2-backwall]) rotate([90,180,180]) wedge(cupwidth/2-backwall,wedge_slope,cupwidth);
    }
    
    // Front wedge
    lower_height=cupwidth/2-thinwall-1.5*margin;
    translate([thinwall,cupwidth/2-thinwall-margin/2,-lower_height-margin/2]) rotate([90,0,0]) wedge(lower_height,wedge_slope,cupwidth-2*thinwall-margin);
    
}

module tongue(angle, width, length, thickness) {
    intersection () {
        difference() {
            rotate([0,angle,0]) {
                cube([3*length,width,thickness], center=true);
            }
            translate([0,0,-length]) {
                cube([3*length,width*2,2*length], center=true);
            }
        }
        cube([2*length, 2*width, length*2], center=true); 
    }
}

module pole_clearance(count, backdepth=16.6) {
    // Lowest support
    translate([0,-count/2*conn_spacing,-conn_spacing/2]) {
        cube([cupdepth+backdepth,count*conn_spacing,cupwidth/2+conn_spacing/2]);
    }
}


module poles(count, backdepth=16.6, framing=false, tongue=true, cap=false) {
    ends = framing ? [0 : 1: count] : [1 : 1: count-1];

    translate([0,-conn_spacing*(count/2-0.5),0]) difference() {
        union() {
            // Actual poles
            for (i = [0 : 1: count-1]) {
                translate([0,conn_spacing*i,0]) {
                    pole(backdepth, tongue, cap);
                }
            }

            // Fill gaps between the poles
            for (i = ends) {
                translate([0,conn_spacing*i,0]) {
                    gapwidth=conn_spacing-cupwidth;
                    translate([0,(-conn_spacing-gapwidth)/2,margin/2]) {
                        cube([backdepth+cupdepth,gapwidth,cupwidth/2-margin/2]);
                    }
                    translate([cupdepth, cupwidth/2-conn_spacing, -cupwidth/2]) {
                        cube([backdepth, gapwidth, cupwidth]);
                    }
                }
            }

            if (cap) {
                translate([cupdepth, -cupwidth/2, -cupwidth/2]) {
                    cube([backdepth, (count-1)*conn_spacing+cupwidth, cupwidth]);
                }
            }
            
            // Add bottom support if framing used
            if (framing) {
                // Inner gap
                translate([cupdepth,cupwidth/2-conn_spacing,-cupwidth/2]) {
                    mirror([0,0,1]) {
                        cube([backdepth,(count+1)*conn_spacing-cupwidth,conn_spacing-cupwidth]);
                    }
                }
                // Lowest support
                translate([0,cupwidth/2-conn_spacing,-conn_spacing/2]) {
                    mirror([0,0,1]) {
                        cube([cupdepth+backdepth,(count+1)*conn_spacing-cupwidth,thinwall]);
                    }
                }
                
                // Side covers
                for (y_pos = [0, count*conn_spacing+thinwall]) {
                    translate([0,-thinwall-conn_spacing/2+y_pos,-conn_spacing/2-thinwall]) {
                        cube([cupdepth+backdepth,thinwall,cupwidth/2+conn_spacing/2+thinwall]);
                    }
                }
            }
        }
        
        // Add holes
        if (!framing && !cap) {
            for (i = [1 : 1 : count-1]) {
                translate([hole_x,i*conn_spacing-cupwidth/2,-cupwidth]) {
                    cylinder(cupwidth*2, hole_r, hole_r, $fn=16);
                }
            }
        }
    }
}

module wedge(x, slope, z) {
    linear_extrude(z)
        polygon([[0,0], [0,x], [slope*x,0]]);
}
