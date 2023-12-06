// Draws a polyhedron by its cartesian coordinates (simplified;
// all elements are assumed ±x).
module polyh(points) {
    // OpenSCAD can't draw zero widths, so, we have to make zeros an epsilon larger
    e = 0.001;
    function nonzerofy(xs) = [for (x = xs) x == 0 ? e : x];

    // Draw cubes and then take a convex hull of them
    hull() {
        for(p = points) {
            cube(nonzerofy(p), center=true);
        }
    }
}

phi = (1 + sqrt(5))/2;

module iko() {
    polyh([
        [0,1,phi],
        [1,phi,0],
        [phi,0,1]
    ]);
}

module dode() {
    polyh([
        [1, 1, 1],
        [0, phi, 1/phi],
        [1/phi, 0, phi],
        [phi, 1/phi, 0]
    ]);
}

// https://en.wikipedia.org/wiki/Compound_of_dodecahedron_and_icosahedron
// With top and bottom parts removed
module topless_compound(height) {
    // h is the distance between top and bottom faces of a dodecahedron
    h = 0.5*sqrt(2*phi*phi+1/(phi*phi)+2);

    scale(height/h) intersection() {
        // The compound is rotated dodecahedron face down
        rotate([0,atan(phi),0]) {
            iko();
            dode();
        }

        // Cut top and lower parts away.
        cube([10,10, h-0.004], center=true);
    }
}

module riser(low_h, rise_h, ring_d) {
    hull() {
        // Sorry about the magic numbers, don't have time to solve equations
        cylinder(low_h*0.997, d=1.524*low_h, $fn=5);
        cylinder(low_h+rise_h, d=ring_d, $fn=100);
    }
}

// Lamp socket thread outer diameter
socket_d = 43;

// Shade height
shade_h = 140;

// Riser part height
riser_h = 20;

// Base diameter (the outer ring of the lamp socket)
base_d = 70;

// Set the final scale and make a hole for the lamp stuff
difference() {
    union () {
        topless_compound(shade_h);
        riser(shade_h/2, riser_h, base_d);
    }
    cylinder(shade_h, d=socket_d, $fn=100);

    // Just for the looks, won't affect vase printing
    topless_compound(shade_h-1);
    mirror([0,0,1]) rotate([0,0,36])cylinder(shade_h, d=0.75*shade_h, $fn=5);
}
