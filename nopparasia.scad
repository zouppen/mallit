// Draws a polyhedron by its cartesian coordinates (simplified;
// all elements are assumed ±x).
module polyh(points) {
    // OpenSCAD can't draw zero widths, so, we have to make zeros an epsilon larger
    e = 0.001;
    function nonzerofy(xs) = [for (x = xs) x == 0 ? e : x];

    // Draw cubes and then take a convex hull of them
    // Rotate so that flat surface is down, easing printing etc.
    rotate([0,atan(phi),0]) hull() {
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
module mollukka () {
    minkowski() {
        difference() {
            scale(10) dode();
            scale(9.95) dode();
            // Open top
            cylinder(10, r=5.25, $fn=5);
        }
        scale(0.5) iko();
    }
}

module kansi() {
    difference() {
        translate([0,0,6.65]) cylinder(0.71, r=5.25, $fn=5);
        mollukka();
    }
    translate([0,0,6.65]) cylinder(2, r=0.53, $fn=5);
    translate([0,0,9]) rotate([0,0,36]) dode();
}

mollukka();
translate([15,0,0]) kansi();
