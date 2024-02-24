pfte_d = 4.2;
pfte_spread = 6.2;
pfte_x = -5;

difference() {
    union() {
        import("Top-plug-edge.stl");
        // Cover the R1 text
        translate([-5,0,3/2]) cube([6,12,3], center=true);
    }

    for(y=[-2,-1, 0, 1, 2]) {
        translate([pfte_x,pfte_spread*y,0]) {
            cylinder(h=10, d=pfte_d, $fn=60);
        }
    }
}

