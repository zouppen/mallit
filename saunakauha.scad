module box(size) {
    cube([2*size, 2*size, size], center = true); 
}

module dodecahedron(size, ish=false) {
      dihedral = 116.565;
      intersection(){
            box(size);
            intersection_for(i=[1:5])  {
                union() {
                    rotate([dihedral, 0, 360 / 5 * i])  box(size); 
                    if (i==5 && ish) translate([-size,0,-size]) cube([2*size,size,2*size]);
                }
           }
      }
}

module dodecahedronish(size) {
    intersection() {
        dodecahedron(size);
        sphere(0.59*size, $fn = 50);
    }
}

/*
module asympt(start, end, a , b) {
    linear_extrude(20) {
        points = [[end,0], [start,0], for (x = [start : 0.1 : end]) [ x, a/(x-b)]];
        polygon(points);
    }
}
*/

module kauha() {
    z_adj = 1.18;

    difference() {
        union () {
            // Outer
            dodecahedron(10, true);

        // Handle
        handle_r = 1.5;
        handle_l = 33; // From the end of the pot
        handle_l_tweak = 5;

        difference () {
            // Avoiding problems with euclidian coordinates by nesting
            translate([0,-handle_l_tweak,z_adj-handle_r+0.164]) {
                rotate([90,0,0]) {
                    linear_extrude(handle_l) {
                        rotate([-27,0,0]) {
                            rotate([0,0,360/5/4]) {
                                circle(handle_r, $fn = 5);
                            }
                        }
                    }
                }
            }
                
            // Some rounding at the end
            translate([0,-handle_l-handle_l_tweak+1.6,-0.164]) {
                rotate([118,0,0]) {
                    rotate([0,0,360/5/4]) {
                        difference() {
                            cylinder(2, 2*handle_r, 2*handle_r);
                            cylinder(2,handle_r*1.05, 1, $fn=5);
                        }
                    }
                }
            }
            
            // Hole at the end
            translate([0,-handle_l-handle_l_tweak+3,0]) {
                rotate([0,0,-18]) {
                    cylinder(5, 0.7, 0.7, $fn=5, center=true);
                }
            }
        }
    } 
    translate([0,0,z_adj]) {
        // Cut top part
        cylinder(15,15,15);
    }    
    // Cut inner part
    dodecahedron(8, true);
    }
}

module denting(dent, dent_l) {
    translate([-dent/2,-dent_l,-dent/2]) {
        cube([dent,dent_l,dent]);
    }
}

module cutbox(start, end, safe = 150) {
    dent = 5;
    dent_l = 2*dent;
    margin = 0.4;
    difference() {
        // Box
        translate([-safe/2,start,-safe/2]) {
            cube([safe,end-start, safe]);
        }
        
        // Indent
        translate([0,end,0]) {
            denting(dent+margin/2, dent_l+margin); // TODO varalta isompi
        }
    }
    
    // Outdent
    translate([0,start,0]) {
        denting(dent, dent_l);
    }
}

cutpoints = [-400,-220,-61.8,100];

// Tests
//cutbox(0,20,safe=20);
//cutbox(40,60,safe=20);

for (i = [0:len(cutpoints)-2]) {
    translate([0,20*i,0]) {
        intersection() {
            #cutbox(cutpoints[i], cutpoints[i+1]);
            scale(10) {
                kauha();
            }
        }
    }
}
