module pcb_box(w, h, pcb_thickness, above, below, rail=3, wall=2) {
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
    }
}

module cable_tie_cup(spacing, width = 1, height = 4, depth = 0.5) {
    $fn = 20;
    translate([0,depth,0]) {
        difference () {
            difference () {
                cylinder(height, spacing+width/2, spacing+width/2, center = true);
                cylinder(height, spacing-width/2, spacing-width/2, center = true);
            }
            safe = spacing+width;
            translate([-safe,-safe,-height]) {
                cube([2*safe,safe,2*height]);
            }
        }

        difference () {
            translate([-spacing/2-width,-depth,-height/2]) {
                cube([spacing+2*width,depth,height]);
            }
            translate([-spacing/2,-depth,-height]) {
                cube([width,depth,2*height]);
            }
        }
    }
}

margin = 0.4;
pcb = 1.6;
pcb_real = 2.2;
h = 71.5+margin;
pcb_surface = 6;
difference () {
    pcb_box(34.5+margin, h, pcb_real, 11.5-pcb+margin, pcb_surface-pcb, rail=1.5);
    // SMA hole
    hole_w = 9;
    translate([2+12.5,h+2,2+pcb_surface-hole_w/2]) {
        cube([hole_w,2,hole_w]);
    }
}

// platter for connections
pull = 10;
difference () {
    thick = 2+1.2;
    translate([0,-pull+2,0]) {
        cube([34.5+margin+2*2,pull,thick]);
    }

    // holes for bandits
    for (x = [ 25, 25+4.5,21,17]) {
        translate([x,-6,0]) {
            cube([1.6,4,thick]);
        }
    }
    
    // Some tweak
    translate([14,-10,0]) {
        cube([20,10,1.2]);
    }
}
