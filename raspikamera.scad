
bottom_end = 53;
left_end = 42.5;
bot_thickness = 17.5;
screw_out = 22; // 15.2;
plateau_thick = 9;
motor_pos_z = 30.5;
motor_pos_x = 22;
raspi_h = 65; // Raspi Zero W dimension
raspi_w = 30;
raspi_hole_pos = 3.5; // From the side
raspi_hole_dia = 2.2; // Add some margin, too!
raspi_hole_nut_dia = 10.5;
camera_plat_y = 40;
camera_plat_w = 12; 
camera_space = 5.5;
wall = 3;

// Calculated
plateau_over = (raspi_h-bottom_end)/2;

$fn = 20;
sep = 0;

rotate([0,0,0]) {
    difference() {
        union() {
            // Vertical back
            //translate([left_end,0,-bottom_end]) mirror([1,0,0]) cube([9,bot_thickness,30]);
            // Horizontal back
            translate([left_end,sep,-bottom_end]) mirror([1,0,0]) cube([10,bot_thickness,9]);
            // Plateau
            translate([0,bot_thickness,plateau_over]) mirror([0,0,180]) cube([left_end,plateau_thick,raspi_h]);
            //translate([0,bot_thickness,0]) mirror([0,0,180]) cube([left_end,plateau_thick,raspi_h-2*plateau_over]);
            // Camera extension
            translate([camera_space-wall,bot_thickness,-raspi_h+plateau_over]) {
                y = camera_plat_y+plateau_thick;
                intersection() {
                    union() {
                        rotate([0,-10,0]) cube([wall,y,camera_plat_w]);
                        cube([wall,y,camera_plat_w*2]);
                    }
                    translate([-wall,0,0]) cube([2*wall,y,camera_plat_w]);
                }
            }
            
            // Add a support for the camera hand
            translate([0,bot_thickness,-raspi_h+plateau_over]) cube([camera_space,plateau_thick,camera_plat_w]);

        }
        // Hole for motor screw
        translate([left_end-5,-10,-bottom_end+5]) rotate([-90,0,0]) cylinder(100,3.5/2,3.5/2);

        // Screw insert
        translate([left_end-5,screw_out,-bottom_end+5]) rotate([-90,0,0]) cylinder(bot_thickness,3,3);
        
        // Hole for motor axis
        size = 13;
        translate([motor_pos_x,bot_thickness,-motor_pos_z]) rotate([-90,30,0]) cylinder(20, size, size, $fn =6);
        
        // Holes for raspi
        for (x = [raspi_hole_pos+camera_space,raspi_w-raspi_hole_pos+camera_space]) {
            for (z = [plateau_over-raspi_hole_pos,-raspi_h+plateau_over+raspi_hole_pos]) {
                translate([x,0,z]) rotate([-90,0,0]) {
                    #cylinder(plateau_thick+bot_thickness,raspi_hole_dia/2, raspi_hole_dia/2);
                    //#cylinder(plateau_thick+bot_thickness-3,raspi_hole_nut_dia/2, raspi_hole_nut_dia/2);
                }
            }
        }
        
        // Stylish cut on the left
        rounding = 14;
        difference() {
            translate([left_end,0,0]) rotate([0,45,0]) cube([100,100,rounding], center=true);
            // Add platform again
            translate([0,bot_thickness,plateau_over]) mirror([0,0,180]) cube([raspi_w+camera_space,plateau_thick,raspi_h]);

        }
    }
}