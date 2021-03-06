text_left = "HACKLAB ";
text_right = " JYVÄSKYLÄ";
outer_size = 9.5;
inner_size = 8.5;

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

handle_separation = 4;
margin = 0.4;

module kauha() {
    z_adj = 0.1181*outer_size;

    handle_r = 1.5;
    handle_l = 33; // From the end of the pot
    handle_l_tweak = 5+handle_separation;

    difference() {
        union () {
            // Outer
            dodecahedron(outer_size, true);

            // Handle
            difference () {
                // Avoiding problems with Euler coordinates by nesting
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
                translate([0,-handle_l-handle_l_tweak+1.6,z_adj-1.39]) {
                    rotate([118,0,0]) {
                        rotate([0,0,360/5/4]) {
                            difference() {
                                cylinder(2, 2*handle_r, 2*handle_r);
                                #cylinder(2,handle_r*1.05, 1, $fn=5);
                            }
                        }
                    }
                }
                
                // Hole at the end
                translate([0,-handle_l-handle_l_tweak+2.5,0]) {
                    rotate([0,0,-18]) {
                        cylinder(5, 0.7, 0.7, $fn=5, center=true);
                    }
                }
                
                // Skewed insertion
                translate([-2,-handle_l_tweak,z_adj-handle_r*1.61]) {
                    rotate([26.5,0,0]) {
                        cube([4,4,4]);
                    }
                }
                
                // Insertion hole
                translate([0, -handle_l_tweak-0.45,0]) {
                    denting(0.5+margin/20,1+margin/10);
                }
            }
        }
        
        translate([0,0,z_adj]) {
            // Cut top part
            cylinder(15,15,15);
        }    
        // Cut inner part
        dodecahedron(inner_size, true);
        
        // Add text
        translate([-0.55,17-handle_l-handle_l_tweak,-2]) {
            mirror([1,0,0]) {
                rotate([0,0,90]) {
                    linear_extrude(1) {
                        text(text_left, font="Liberation Sans:style:Bold", size=1, halign="right", valign="baseline");
                        text(text_right, font="Liberation Sans:style:Bold", size=1, halign="left", valign="baseline");

                    }
                }
            }
        }
    }

    // Add plug
    translate([0,-0.54*outer_size,0]) {
        denting(0.5,1);
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

//cutpoints = [-400,-220,-61.8,100];
cutpoints = [-440,-250,100];

for (i = [0:len(cutpoints)-2]) {
    translate([0,20*i,0]) {
        intersection() {
            cutbox(cutpoints[i], cutpoints[i+1]);
            scale(10) {
                kauha();
            }
        }
    }
}
