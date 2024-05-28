bottom_h = 2;
bottom_w = 0.5;
opening_d = 34;
top_w = 4;
top_h = 1.5;
neck_h = 1.7;
bottle_neck_d = 28;
bottle_cap_d = 31.3;
bottle_cap_rise = 1;
fix = 0.01;
cut_w = 2.5;
cuts = 3;

difference () {
    rotate_extrude($fn=100) polygon([
        [bottle_cap_d/2, -top_h],
        [opening_d/2+top_w, -top_h],
        [opening_d/2+top_w, 0],
        [opening_d/2, 0],
        [opening_d/2, neck_h],
        [opening_d/2+bottom_w, neck_h],
        [opening_d/2, neck_h+bottom_h],
        [bottle_neck_d/2, neck_h+bottom_h],
        [bottle_neck_d/2, neck_h+bottom_h-bottle_cap_rise],
        [bottle_cap_d/2, neck_h+bottom_h-bottle_cap_rise]
    ]);
    
    // Air holes
    for (i = [1:cuts]) rotate([0,0,i*360/cuts]) {
        translate([0,-cut_w/2,neck_h-fix])  {
            cube([opening_d,cut_w,bottom_h+2*fix]);
        }
    }
}