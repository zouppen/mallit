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

wrap_left = make_region(svgPoints("
M -0 -24.46 L -0 -26.9 L -0.68 -26.9 L -2.25 -26.86 L -3.82 -26.8
L -5.39 -26.69 L -6.96 -26.56 L -8.53 -26.39 L -10.09 -26.19 L -11.66 -25.96
L -13.22 -25.69 L -14.78 -25.4 L -16.34 -25.07 L -17.9 -24.72 L -19.46 -24.34
L -22.58 -23.49 L -25.69 -22.53 L -26.19 -22.33 L -26.67 -22.05 L -27.1 -21.72
L -27.49 -21.33 L -27.64 -21.16 L -27.97 -20.7 L -28.24 -20.2 L -28.44 -19.67
L -28.56 -19.12 L -28.6 -18.55 L -28.6 23.4 L -28.57 23.66 L -28.47 23.9
L -28.31 24.11 L -28.1 24.27 L -27.86 24.37 L -27.6 24.4 L -9.4 24.4
L -8.95 24.45 L -8.53 24.6 L -8.15 24.84 L -7.84 25.15 L -7.6 25.53
L -7.45 25.95 L -7.44 26.07 L -7.45 26.14 L -7.6 26.56 L -7.84 26.94
L -8.15 27.25 L -8.53 27.49 L -8.95 27.64 L -9.4 27.69 L -10.4 27.69
L -10.66 27.74 L -10.9 27.84 L -11.11 27.99 L -11.27 28.2 L -11.37 28.44
L -11.4 28.69 L -11.4 38.69 L -11.37 38.93 L -11.27 39.17 L -11.11 39.38
L -10.9 39.54 L -10.66 39.64 L -10.4 39.69 L -9.4 39.69 L -8.95 39.74
L -8.53 39.88 L -8.15 40.12 L -7.94 40.31 L -4.6 40.32 L -4.6 25.4
L -4.57 25.14 L -4.47 24.9 L -4.31 24.69 L -4.1 24.53 L -3.86 24.43
L -3.6 24.4 L -2.4 24.4 L -2.14 24.43 L -1.9 24.53 L -1.69 24.69
L -1.53 24.9 L -1.43 25.14 L -1.4 25.4 L -1.4 40.4 L 1.4 40.4
L 1.4 22.92 L 1.37 22.66 L 1.27 22.42 L 1.11 22.21 L 0.9 22.05
L 0.66 21.95 L 0.4 21.92 L -24.78 21.92 L -25.04 21.88 L -25.28 21.78
L -25.49 21.62 L -25.65 21.42 L -25.75 21.18 L -25.78 20.92 L -25.78 -17.72
L -25.73 -18.23 L -25.72 -18.3 L -25.64 -18.63 L -25.61 -18.71 L -25.54 -18.87
L -25.47 -19.03 L -25.42 -19.14 L -25.34 -19.26 L -25.2 -19.5 L -25.01 -19.71
L -24.91 -19.83 L -24.82 -19.91 L -24.7 -20.01 L -24.58 -20.11 L -24.46 -20.2
L -24.19 -20.36 L -24.07 -20.42 L -23.67 -20.58 L -20.73 -21.45 L -17.78 -22.22
L -14.84 -22.88 L -11.9 -23.43 L -10.42 -23.67 L -8.95 -23.87 L -7.48 -24.05
L -6.01 -24.2 L -4.53 -24.31 L -3.06 -24.39 L -1.59 -24.44 L -0.11 -24.46
L -0 -24.46 z
"));

wrap_right = make_region(svgPoints("
M -0 -24.46 L 0 -24.46 L 1.48 -24.45 L 2.96 -24.4 L 4.45 -24.32
L 5.93 -24.2 L 7.41 -24.06 L 8.89 -23.88 L 10.37 -23.68 L 11.85 -23.44
L 14.82 -22.89 L 17.78 -22.22 L 20.75 -21.45 L 23.71 -20.58 L 24.11 -20.42
L 24.23 -20.36 L 24.49 -20.2 L 24.61 -20.11 L 24.74 -20.01 L 24.85 -19.91
L 24.95 -19.83 L 25.06 -19.7 L 25.24 -19.5 L 25.38 -19.26 L 25.46 -19.13
L 25.51 -19.03 L 25.58 -18.87 L 25.64 -18.71 L 25.68 -18.63 L 25.77 -18.23
L 25.82 -17.72 L 25.82 20.92 L 25.79 21.18 L 25.69 21.42 L 25.53 21.62
L 25.32 21.78 L 25.08 21.88 L 24.82 21.92 L 5.6 21.92 L 5.34 21.95
L 5.1 22.05 L 4.89 22.21 L 4.73 22.42 L 4.63 22.66 L 4.6 22.92
L 4.6 40.32 L 7.4 40.32 L 7.4 26.4 L 7.45 25.95 L 7.6 25.53
L 7.84 25.15 L 8.15 24.84 L 8.53 24.6 L 8.95 24.45 L 9.4 24.4
L 27.6 24.4 L 27.86 24.37 L 28.1 24.27 L 28.31 24.11 L 28.47 23.9
L 28.57 23.66 L 28.6 23.4 L 28.6 -18.57 L 28.56 -19.13 L 28.44 -19.68
L 28.24 -20.21 L 27.97 -20.71 L 27.64 -21.16 L 27.49 -21.33 L 27.11 -21.71
L 26.69 -22.04 L 26.23 -22.31 L 25.73 -22.52 L 22.61 -23.48 L 19.48 -24.33
L 17.92 -24.71 L 16.35 -25.07 L 14.78 -25.4 L 13.21 -25.69 L 11.64 -25.96
L 10.07 -26.19 L 8.5 -26.39 L 6.93 -26.56 L 5.35 -26.7 L 3.78 -26.8
L 2.2 -26.87 L 0.63 -26.9 L -0 -26.9 z
"));

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

hookbar_size = [7, 17, 10];
hookbar_lower = 5.2;
hook_h = 10;
hook_w = 5;
hook_ys = [-6, 6];
tol = 0.4;

module hingejack(anchor) {
    cuboid(hookbar_size, anchor=anchor, $fn=40, rounding=2, edges=[TOP+LEFT, TOP+RIGHT]) {
        up($parent_size[2]/2) attach(LEFT, spin=-90) {
            iface(hook_h, $parent_size[1]);
            for(y = hook_ys) fwd(y) {
                    jack(hook_h, hook_w);
                }
        }
        children();
    }
}

module hingeplug(anchor) {
    cuboid(hookbar_size+[-3,0,-hookbar_lower], anchor=anchor, $fn=40, rounding=2, edges=[TOP+LEFT]) {
        up($parent_size[2]/2+hookbar_lower) attach(RIGHT, spin=-90) {
            iface(hook_h, $parent_size[1], 180);
            for(y = hook_ys) fwd(y+(0.25*sign(y)*tol)) {
                    plug(hook_h, hook_w+0.2, tol);
                }
        }
        children();
    }
}

module hinges() {
    diff() {
        hingejack();
        left(40) hingeplug();
        //tag("keep") cuboid(100);
    }
}

//hinges();


wrap_h = 17;
h_adj = 2.4;

diff() {
    linear_sweep(wrap_left, wrap_h) {
        back(h_adj) position(FWD+RIGHT+BOTTOM) orient(FWD) hingeplug(BOTTOM+FWD+RIGHT);
    }

    right(30) linear_sweep(wrap_right, wrap_h) {
        back(h_adj) position(FWD+LEFT+BOTTOM) orient(FWD) hingejack(BOTTOM+FWD+LEFT);

        tag("remove") back(33) xcyl(h=100, d=5.2, $fn=40);
    }


}
