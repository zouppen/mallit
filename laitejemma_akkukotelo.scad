// A box containing 2 SATA drives, 2x M.2 drive and room for cables

include <laitejemma.scad>

box = [170,100,115];
tray_slot = [120, 20, 100];
tray_pos = 3;
tray_rail = 2.9;
tray_h = 2;
tray_slot_y = 35;
tray_top_part = 2;
powerpole_h = 25;

slots = [ ["size", [152, 66, 103], "pos", [  0, -11]], // Battery
          ["size", tray_slot, "pos", [  15,  tray_slot_y], "extra", false, "name", "luukku"]]; // Electronics

slots_insert = [["size", tray_slot-[4*tol, 4*tol, 2*tol], "pos", [  15,  tray_slot_y], "extra", false]];

fingerslots = [15];

//$box_hide = "lid rod";

render_box(box, slots, fingerslots, tray_slot_y) {
    cable_y = (-tray_h-tray_pos)/2;
    tube_x_len = 15.2;

    if ($name == "luukku") {
        // Tray rail
        fwd(tray_pos) position(BACK) cuboid([$parent_size[0]+2*tray_rail, tray_h, $parent_size[2]], anchor=BACK);

        // Charging powerpole slot
        curve=10;
        bezpath = flatten([bez_begin([20,cable_y,-15], LEFT, curve),
                           bez_end([0,0,0], DOWN, curve)]);

        left(80) down(cutsize+1) position(TOP) powerpole_slot() {
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
        fiber_curve=10;
        fiber_z_in = -11;
        fiber_z_out = 15;
        fiber_route_y = -8;
        fiber_route_z = (0.45*fiber_z_in+0.55*fiber_z_out);
        fiber_path = flatten([bez_begin([powerpole_h+tube_x_len,tray_slot_y+cable_y,fiber_z_in], LEFT, fiber_curve),
                              bez_tang([(0.4*powerpole_h+0.6*tube_x_len),tray_slot_y+fiber_route_y,fiber_route_z],[-10,0,7]),
                              bez_end([0,tray_slot_y,fiber_z_out], RIGHT, curve)]);

        tag("remove") position(LEFT) bezpath_sweep(circle(d=2.8,$fn=24), fiber_path, 32);
        //!debug_bezier(fiber_path);
    }
};


module powerpole_slot(extra) {
    // Make sure the cable fits
    clearance = [20.2, 12, 50];
    module tooth() {
        cuboid([5, $parent_size[2], 0.8], chamfer=0.5, edges=[TOP+RIGHT, TOP+LEFT]);
    }
    cuboid([16.4, 8.2, powerpole_h], anchor=TOP) {
        down(0.01) align(TOP) cuboid(clearance);
        attach(LEFT) tooth();
        attach(FWD) xcopies(8.2) tooth();
        // Drill hole
        up(15) back(2.2) position(BOTTOM+BACK) ycyl(l=31, d=3, anchor=BACK, $fn=24);
        children();
    }
}

// The PCB tray
back(40) render_box(box, slots_insert, [], tray_slot_y, $box_hide="lid rod case", $box_remove = "remove") {
        if ($name == "slot") {
            // Tray
            fwd(tray_pos) position(BACK) cuboid([$parent_size[0]+2*tray_rail-2*tol, tray_h-4*tol, $parent_size[2]], anchor=BACK) {
                // Carve PCB area
                tag("remove") position(FWD+BOTTOM) down(0.01) cuboid(tray_slot-[0,0,tray_top_part], anchor=BACK+BOTTOM);
            }
            // Fingerslot fill
            tag("keep") position(FWD+TOP) cuboid([fingerslot_d-4*tol,2.1,$parent_size[2]-tray_slot[2]+tray_top_part], anchor=BACK+TOP);
        }
}
