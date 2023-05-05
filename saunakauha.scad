text_left = "Hacklab ";
text_right = " Jyväskylä ry";
outer_size = 95;
inner_size = 85;

dent_mm = 8;
dent_l_mm = 15;
dent_first_mul = 1.4;

module box(size) {
    cube([2*size, 2*size, size], center = true); 
}

module dodecahedron(size, ish=false) {
      dihedral = 116.565;
      intersection() {
            box(size);
            intersection_for(i=[1:5])  {
                union() {
                    rotate([dihedral, 0, 360 / 5 * i])  box(size); 
                    if (i==5 && ish) translate([-size,0,-size]) cube([2*size,size,2*size]);
                }
           }
      }
}

handle_separation = 40;
margin = 0.4;

module varsi_cyl(l, r1, r2) {
    scale([1,1,cos(27)]) rotate([90,-90,0]) cylinder(l, r1, r2, $fn = 5);
}

module kauha() {
    z_adj = 0.1181*outer_size;

    handle_r = 15;
    handle_l = 330; // From the end of the pot
    handle_round = 7;
    handle_l_tweak = 50+handle_separation;

    difference() {
        union () {
            // Outer
            dodecahedron(outer_size, true);

            // Handle
            difference () {
                // Handle full part
                translate([0,-handle_l_tweak,z_adj-handle_r+1.64]) {
                    varsi_cyl(handle_l-handle_round, handle_r, handle_r);
                    translate([0,-handle_l+handle_round,0]) varsi_cyl(handle_round, handle_r, handle_r-handle_round);
                }
                    
                // Hole at the end
                translate([0,-handle_l-handle_l_tweak+25,0]) {
                    rotate([0,0,-18]) {
                        cylinder(50, 7, 7, $fn=5, center=true);
                    }
                }
                
                // Skewed insertion
                translate([-20,-handle_l_tweak,z_adj-handle_r*1.61]) {
                    rotate([26.5,0,0]) {
                        cube([40,40,40]);
                    }
                }
                
                // Insertion hole
                translate([0, -handle_l_tweak-1,0]) {
                    denting(dent_mm+margin/2,dent_first_mul*dent_l_mm+margin);
                }
            }
            // Add plug
            translate([0,-0.5*outer_size,0]) {
                denting(dent_mm,dent_first_mul* dent_l_mm);
            }
        }
        
        translate([0,0,z_adj]) {
            // Cut top part
            cylinder(150,150,150);
        }    
        // Cut inner part
        dodecahedron(inner_size, true);
        
        // Add text
        text_depth=0.6;
        translate([-5,170-handle_l-handle_l_tweak,-20]) {
            mirror([1,0,0]) {
                rotate([0,0,90]) {
                    linear_extrude(7.04+text_depth) {
                        text(text_left, font="Ubuntu:style:Bold", size=10, halign="right", valign="baseline");
                        text(text_right, font="Ubuntu:style:Bold", size=10, halign="left", valign="baseline");

                    }
                }
            }
        }

        // Logo
        logo_size = 0.5;
        tweak = 0.1;
        translate([0,0,-outer_size*0.5-tweak]) scale([logo_size, logo_size,1]) mirror([1,0,0]) linear_extrude(0.6+tweak) import("saunakauha-logo.svg");

    }
}

module denting(dent, dent_l) {
    // Hotfix by squeezing it a little on z axis
    translate([0,-dent_l,-2.4]) scale([1,1,0.9]) {
        rotate([-90,-90,0]) cylinder(dent_l, dent, dent, $fn=5);
    }
}

module cutbox(start, end, safe = 150) {
    difference() {
        // Box
        translate([-safe/2,start,-safe/2]) {
            cube([safe,end-start, safe]);
        }
        
        // Indent
        translate([0,end,0]) {
            denting(dent_mm+margin/2, dent_l_mm+1);
        }
    }
    
    // Outdent
    translate([0,start,0]) {
        denting(dent_mm, dent_l_mm);
    }
}

cutpoints = [-440,-250,100];

for (i = [0:len(cutpoints)-2]) {
    translate([0,20*i,0]) {
        intersection() {
            cutbox(cutpoints[i], cutpoints[i+1]);
            kauha();
        }
    }
}

// Hack to get stronger tap if desired
module just_tap() {
    // Add plug // -0.5*outer_size+40
    difference() {
        denting(dent_mm,0.5*outer_size+ dent_first_mul* dent_l_mm-20); // So ugly
        translate([0,20,0]) dodecahedron(inner_size, true); // Cut inner parts
    }
}
//!just_tap();
