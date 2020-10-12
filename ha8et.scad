module pcb_box(w, h, pcb_thickness, above, below, rail=3, wall=2, dent_size = 5;
) {
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
pcb = 1.6;
pcb_real = 2.2;
h = 71.5+margin;
pcb_surface = 6;
difference () {
    thick = 2+1.2;

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

/*    // SMA hole
    hole_w = 9;
    translate([2+12.5,h+2,2+pcb_surface-hole_w/2]) {
        cube([hole_w,2,hole_w]);
    }
*/    
    // Holes for cable ties
    holes = [[29, 4], [19, 4]];
    for (hole = holes) {
        translate([hole[0],-4,thick]) {
            rotate([-90,0,0]) {
                cable_tie_cup(hole[1], 1.2, 4, 0);
            }
        }
    }

    
    // Some tweak
/*    translate([14,-10,0]) {
        cube([20,10,1.2]);
    }
*/
}

// platter for connections
pull = 10;
difference () {

 }


