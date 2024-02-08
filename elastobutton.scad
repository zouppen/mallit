include <BOSL2/std.scad>

module elastobutton(size, h, wall_w) {
    elastic = 0.6;
    cut = 0.2;
    surface_size = [size-cut,size-2*cut,elastic];
    support_slope = 0.7;
    shaft_w = 0.6; // The shaft between elastic parts
    support_w = size - shaft_w - 2*cut; // Internal support width
    support_h = support_slope*support_w;
    straight_part = h - 2*elastic - 2*support_h; // Straight part of the support

    // Outer support frame
    tag("keep") rect_tube(h, isize=size, wall=wall_w) {
        default_tag() children();

        force_tag("keep") rotate([90,0,180]) move([-size/2, elastic-h/2, -size/2]) linear_extrude(size) polygon(turtle(["xymove", [support_w, support_h], "ymove", straight_part, "xymove", [-support_w, support_h], "ymove", -straight_part-2*support_w]));

        // The cut for the button
        for (a=[TOP, BOTTOM]) align(a, inside=true) tag("rm") cube([size, size, elastic]) {
            // The button
            right(cut) align(LEFT, inside=true) tag("keep") cuboid(surface_size);
        }

        // Shaft
        right(wall_w+cut) align(LEFT, inside=true) cube([shaft_w, size-2*cut, straight_part+2*support_h-2*cut]);

        // Make sure the shaft is empty of walls, etc.
        tag("rm") align(CENTER) cube([size,size,h]);
    }
}
