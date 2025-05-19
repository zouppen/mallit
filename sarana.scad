include <pathbuilder/pathbuilder.scad>
include <BOSL2/std.scad>

// Put the joint along x axis
conv = scale(1/40) * yflip() * zrot(-90) * left(10);

hinge_neg_iface = svgRegion("
m 0,0
v 15
c 0,1.7 0.3,3.4 0.9,5
H 10
V 0.9
C 11.6,0.3 13.3,0 15,0
Z
");

hinge_neg = svgRegion("
M 10 20
L 15 20
C 12.2 20 10 17.8 10 15
L 10 20
z
");

hinge_pos = svgRegion("
m 20,10
v 5
c 0,2.8 -2.2,5 -5,5
l -10,0
v 20
h 5
c 0.12,-2.53 -0.38,-7.74 7.4,-9.35 7.34,-1.52 12.6,-6.55 12.6,-15.65 0,-1.7 -0.3,-3.4 -0.9,-5
z
");

function svgRegion(str) = apply(conv, make_region(svgPoints(str)));

module jack(h, d) {
    both = apply(scale(h), union(hinge_neg, hinge_pos));
    tag("remove") linear_sweep(both, d, center=true, orient=BACK) children();
}


module plug(h, d, tol=0) {
    trimmed = offset(apply(scale(h), hinge_pos), delta=-tol/2);
    obj = linear_sweep(trimmed, d-tol, center=true);
    vnf_polyhedron(obj, orient=FWD) children();
    //halftol = front_half(zscale((h+tol)/h, obj), h/15);
    //vnf_polyhedron(halftol, orient=FWD);
}

module iface(h, d, rot=0) {
    tag("remove") linear_sweep(apply(xrot(rot) * scale(h), hinge_neg_iface), d, center=true, orient=BACK);
}

hookbar_size = [10, 25, 10];
hook_h = 10;
hook_w = 5;
hook_ys = [-8, 8];
tol = 0.4;

diff() {
    cube(hookbar_size) up($parent_size[2]/2) attach(LEFT, spin=-90) {
        for(y = hook_ys) fwd(y) {
                iface(hook_h, $parent_size[1]);
                jack(hook_h, hook_w);
            }
    }
    
    left(40) cube(hookbar_size) up($parent_size[2]/2) attach(RIGHT, spin=-90) {
        for(y = hook_ys) fwd(y) {
                iface(hook_h, $parent_size[1], 180);
                plug(hook_h, hook_w, tol);
            }
    }
}
