module pcb_box(w, h, pcb_thickness, above, below, rail=3, wall=2, dent_size = 5) {
    inside_h = above+below+pcb_thickness;
    difference () {
        // Outer wall
        cube([w+2*wall, h+2*wall, inside_h+2*wall]);
        // Inner wall
        translate([wall+rail,0,wall]) {
            cube([w-2*rail, h+wall, inside_h]);
        }
        // Rail
        translate([wall,wall,wall+below]) {
            cube([w,h, pcb_thickness]);
        }
        // Front opening
        translate([wall,0,wall]) {
            cube([w,wall,inside_h]);
        }
        
        // Cover dent
        for (x = [wall, wall+w-rail]) {
            translate([x,2*wall, wall+below+pcb_thickness+above/2-dent_size/2]) {
                cube([rail,dent_size,dent_size]);
            }
        }
    }
}

module cable_tie_cup(spacing, width = 1, height = 4, depth = 0.5) {
    $fn = 20;
    translate([0,depth,0]) {
        // Round part
        difference () {
            difference () {
                cylinder(height, spacing/2+width/2, spacing/2+width/2, center = true);
                cylinder(height, spacing/2-width/2, spacing/2-width/2, center = true);
            }
            safe = spacing+width;
            translate([-safe,-safe,-height]) {
                cube([2*safe,safe,2*height]);
            }
        }

        // Straigth part
        difference () {
            translate([-spacing/2-width/2,-depth,-height/2]) {
                cube([spacing+width,depth,height]);
            }
            translate([-spacing/2+width/2,-depth,-height]) {
                cube([spacing-width,depth,2*height]);
            }
        }
    }
}

margin = 0.4;
pcb = 3.6;
pcb_real = 2.2;
h = 71.5+margin;
pcb_surface = 6;
pull = 10;

thick = 2+1.2; // Thickness of front panel
holes = [[29, 4], [19, 4]];

difference () {

    union () {
        // PCB box
        pcb_box(34.5+margin, h, pcb_real, 11.5-pcb+margin, pcb_surface-pcb, rail=1.5);
        
        translate([0,-pull+2,0]) {
            cube([34.5+margin+2*2,pull,thick]);
        }
    }
    
        // SMA hole
        hole_w = 9;
        translate([2+17,h+3,2+pcb_surface]) {
            rotate([90,0,0]) {
                cylinder(2,hole_w/2, hole_w/2, center=true, $fn=20);
            }
        }

    // Holes for cable ties
    for (hole = holes) {
        translate([hole[0],-4,thick]) {
            rotate([-90,0,0]) {
                cable_tie_cup(hole[1], 1.2, 4, 0);
            }
        }
    }
}

// Calculated from magic values
inner_height = pcb_real+ 11.5-pcb+margin+pcb_surface-pcb-thick+2;
pcb_width = 34.5+margin;

translate([50,0,0]) {
    difference () {
        union () {
            // Outer box
            translate([0,-pull+2,thick]) {
                cube([pcb_width+2*2,pull-2,inner_height+2]);
            }

            // Indent
            translate([0+2+margin/2,0,thick]) {
                cube([pcb_width-margin,2,inner_height-margin/2]);
            }
        }
        // Empty space
        translate([0+2+2,-pull+2*2,thick]) {
            cube([pcb_width-2*2,10,inner_height-2]);
        }
        // Cable inputs
        for (hole = [20,28]) { // Old holes
            translate([hole,-pull+2,thick+4/2]) {
                cube([4,10,4], center=true);
            }
        }
        
        // Text
        translate([(pcb_width+4)/2,-pull+2+1.2,13]) {
            rotate([90,0,00]) {
                linear_extrude(2) {
                    text("OH64K | APRS", font="Liberation Sans Narrow:style:Bold", size=4.2, halign="center", valign="center");
            }
        }
    }

    }
}
