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
iko();
dode();
