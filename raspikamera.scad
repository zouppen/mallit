
bottom_end = 53;
left_end = 42.5;
bot_thickness = 17.5;
screw_out = 22-6;
plateau_thick = 9;
motor_pos_z = 33;
motor_pos_x = 22;
motor_r = 11.6; // Not really this accurate, just to make it beautiful
raspi_h = 65; // Raspi Zero W dimension
raspi_w = 30;
raspi_hole_pos = 3.5; // From the side
raspi_hole_dia = 2.2; // Add some margin, too!
raspi_backsupport= 2.2; // Support on the back side
camera_plat_y = 33;
camera_plat_w = 12; 
camera_space = 5.5;
camera_angle = 16;
camera_tilted_y = 13;
screw_insert_dia = 7.2;

// Printing aid
pentagon_rotate = 0;

// Calculated
plateau_over = (raspi_h-bottom_end)/2-1;
camera_y = camera_plat_y+plateau_thick;
camera_z = -raspi_h+plateau_over;

$fn = 20;
sep = 0;

rotate([0,-90,0]) {
    screwbar_side = 9;
    difference() {
        union() {
            difference() {
                // Screw bar
                translate([left_end,sep,-bottom_end]) mirror([1,0,0]) cube([bot_thickness+screwbar_side,bot_thickness,screwbar_side]);
                // Cut screw bar as a support
                sidelen = 2*sqrt(2)*screwbar_side;
                translate([left_end-screwbar_side-bot_thickness,0,0]) rotate([0,0,45]) cube([sidelen,sidelen,2*raspi_h], center=true);
            }
            // Plateau
            translate([0,bot_thickness,plateau_over]) mirror([0,0,180]) cube([left_end,plateau_thick,raspi_h]);
            // Camera extension. Cut later
            translate([0,bot_thickness,camera_z]) cube([camera_space,camera_y,camera_plat_w]);
            
            // Back support for raspi
            difference() {
                intersection() {
                    translate([2*raspi_hole_pos+camera_space,plateau_thick+bot_thickness,plateau_over]) mirror([0,0,1]) cube([raspi_w-4*raspi_hole_pos,raspi_backsupport,raspi_h]);
                    w = (raspi_w-4*raspi_hole_pos)/sqrt(2);
                    // Horizontal rounding
                    translate([camera_space+raspi_w/2,plateau_thick+bot_thickness,0]) rotate([0,0,45]) cube([w,w,2*raspi_h], center=true);
                    
                    // Vertical rounding
                    union() {
                        translate([camera_space+raspi_w/2,plateau_thick+bot_thickness,plateau_over]) rotate([90,45,90]) cube([2*w,2*w,2*raspi_w], center=true);
                        translate([camera_space+raspi_w/2,plateau_thick+bot_thickness,plateau_over-raspi_h]) rotate([90,45,90]) cube([2*w,2*w,2*raspi_w], center=true);
                    }

                }
            }
            // Hand on the back
            wall = 5;
            tweak = -1.2;
            difference () {
                translate([0,-wall,plateau_over]) mirror([0,0,1]) cube([camera_space,bot_thickness+wall,wall+plateau_over]);
                translate([0,0,tweak]) mirror([0,0,1]) cube([camera_space,2*bot_thickness,2*wall]);
            }
        }
        // Hole for motor screw
        translate([left_end-5,-10,-bottom_end+5]) rotate([-90,0,0]) cylinder(100,3.5/2,3.5/2);

        // Screw insert
        translate([left_end-5,screw_out,-bottom_end+5]) rotate([-90,0,0]) cylinder(bot_thickness,screw_insert_dia/2,screw_insert_dia/2, $fn=6);
         %translate([left_end-5,screw_out,-bottom_end+5]) rotate([-90,0,0]) cylinder(bot_thickness,6.4/2,6.4/2);
       
        // Hole for motor axis
        translate([motor_pos_x,bot_thickness,-motor_pos_z]) rotate([-90,pentagon_rotate,0]) #cylinder(plateau_thick+5, motor_r, motor_r, $fn=5);
        
        // Holes for raspi
        for (x = [raspi_hole_pos+camera_space,raspi_w-raspi_hole_pos+camera_space]) {
            for (z = [plateau_over-raspi_hole_pos,-raspi_h+plateau_over+raspi_hole_pos]) {
                translate([x,0,z]) rotate([-90,0,0]) {
                    #cylinder(plateau_thick+bot_thickness,raspi_hole_dia/2, raspi_hole_dia/2);
                }
            }
        }
        
        // Stylish cut on the left
        rounding = 16;
        difference() {
            translate([left_end,0,0]) rotate([0,45,0]) cube([100,100,rounding], center=true);
            // Add platform again
            translate([0,bot_thickness,plateau_over]) mirror([0,0,180]) cube([raspi_w+camera_space,2*plateau_thick,raspi_h]);

        }
        
        // Camera hand angle
        translate([0,camera_y+bot_thickness-camera_tilted_y,0]) {
            #rotate([-90,0,0]) {
                linear_extrude(camera_tilted_y,scale=1.07) {
                    polygon([[0,-camera_z],[0,-camera_plat_w-camera_z],[tan(camera_angle)*camera_plat_w,-camera_z]]);
                }
            }
        }
        
        // Cut bottom left corner
        rounding_left = 3.4;
        translate([left_end-50,0,-bottom_end-50+rounding_left]) rotate([0,45,0]) cube([100,100,100]);
        
        // Cable tie holder
        tie_hole = 2;
        tie_space = 9;
        translate([0,bot_thickness+plateau_thick/2,-raspi_h+plateau_over+camera_plat_w+tie_space/2+tie_hole]) {
            rotate([90,90,0]) {
                difference() {
                    cylinder(3,tie_space/2+tie_hole,tie_space/2+tie_hole, center=true);
                    cylinder(3,tie_space/2,tie_space/2, center=true);
                }
            }
        }
    }
}
