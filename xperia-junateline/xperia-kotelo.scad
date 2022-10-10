bot_thick = 2;
hole_pos_x = 60;
hole_d = 4.5;
bridge_w = 20;
bridge_start=36.5;
bridge_conn=32;
bridge_h=5;
bridge_y_adj=-13;

difference() {
    union() {
        //import("Xperia-10-iii-Cover.stl");
        translate([0,bridge_y_adj,0]) for (m = [0,1]) mirror([m,0,0]) {
            $fn = 32;
            // Bridge platform
            translate([hole_pos_x,0,bridge_h]) cylinder(bot_thick, bridge_w/2, bridge_w/2);
            // Bridge rounding
            translate([bridge_start,-bridge_w/2,bridge_h]) cube([hole_pos_x-bridge_start,bridge_w,bot_thick]);
            // Bridge entry
            translate([bridge_conn,-bridge_w/2,-bot_thick]) cube([bridge_start-bridge_conn,bridge_w,bot_thick]);
            // Vertical part of the bridge
            translate([bridge_start-bot_thick,-bridge_w/2,0]) cube([bot_thick,bridge_w,bridge_h+bot_thick]);


            
        }
    }
    for (x = [hole_pos_x, -hole_pos_x]) {
        $fn = 12;
        translate([x,bridge_y_adj,0]) cylinder(20, hole_d/2, hole_d/2, center=true); 
    }
}