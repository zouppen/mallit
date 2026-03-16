// A box containing 2 SATA drives, 2x M.2 drive and room for cables

box = [170,100,115];
tray_slot_h = 20;
tray_pos = 3;
tray_rail = 2.9;
tray_h = 2;
tray_slot_y = 35;
powerpole_h = 25;

slots = [ ["size", [152, 66, 103], "pos", [  0, -11]], // Battery
          ["size", [120, tray_slot_h, 100 ], "pos", [  15,  tray_slot_y], "extra", false, "name", "luukku"]]; // Electronics

fingerslots = [0];


// Heretic way to communicate with global vars
include <laitejemma.scad>
render_box(tray_slot_y) {
    cable_y = (-tray_h-tray_pos)/2;
    tube_x_len = 15.2;

    if ($name == "luukku") {
        // Charging slot
        fwd(tray_pos) position(BACK) cuboid([$parent_size[0]+2*tray_rail, tray_h, $parent_size[2]], anchor=BACK);

        curve=10;

        bezpath = flatten([bez_begin([20,cable_y,-15], LEFT, curve),
                           bez_end([0,0,0], DOWN, curve)]);

        left(80) position(TOP) powerpole_slot(cutsize+1) {
            position(BOTTOM) bezpath_sweep(yscale(1.5,circle(d=$parent_size[1], spin=360/12,$fn=6)), bezpath);
        };
    }
    if ($name == "chassis") {
        // Output powerpole slot
        curve=5;

        bezpath = flatten([bez_begin([0,cable_y,-tube_x_len], UP, curve),
                           bez_end([0,0,0], DOWN, curve)]);

        tag("remove") move([-0.05,tray_slot_y,0]) position(LEFT) yrot(-90) powerpole_slot() {
            position(BOTTOM) bezpath_sweep(xscale(1.5, circle(d=$parent_size[1],$fn=6)), bezpath);
        }

        // Fiber (light bridge)
        fiber_curve=5;
        fiber_z_in = -11;
        fiber_z_out = 15;
        fiber_route_y = -9;
        fiber_route_z = (0.4*fiber_z_in+0.6*fiber_z_out);
        fiber_path = flatten([bez_begin([powerpole_h+tube_x_len,tray_slot_y+cable_y,fiber_z_in], LEFT, fiber_curve),
                              bez_tang([(powerpole_h+tube_x_len)/2,tray_slot_y+fiber_route_y,fiber_route_z],[-10,0,6]),
                              bez_end([0,tray_slot_y,fiber_z_out], RIGHT, curve)]);

        tag("remove") position(LEFT) bezpath_sweep(circle(d=2.6,$fn=24), fiber_path, 32);
        //!debug_bezier(fiber_path);
    }
};


module powerpole_slot(extra=0) {
    module tooth() {
        cuboid([4.6, $parent_size[2], 0.6], chamfer=0.5, edges=[TOP+RIGHT, TOP+LEFT]);
    }
    cuboid([16.2, 8.2, powerpole_h+extra], anchor=TOP) {
        attach(LEFT) tooth();
        attach(FWD) xcopies(8.2) tooth();
        children();
    }
}
