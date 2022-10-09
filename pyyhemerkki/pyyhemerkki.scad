// Platform height
h = 16;
// Platform width
w = 57;
// Platform rounding
rounding = 4;
// Platform thickness
plat_thick = 1;
// Flexible strip thickness
flex_thick = 0.4;
// Tap height from platform level
tap_height = 5;
// Tap diameter
tap_d = 3.9;
// Tap offset from zero X
tap_x_off = 1;
// Text thickness
text_thick = 0.4;
// Text offset from zero X
text_x_off = 6;

// Flex part
translate([-2,-5,0]) mirror([1,0,0]) linear_extrude(flex_thick) import("aukotus.svg");

// Platform with rounded corners
hull() for(point = [[0,h/2], [0,-h/2], [w,h/2], [w,-h/2]]) {
    translate(point) cylinder(plat_thick, rounding/2, rounding/2, $fn=12);
}

// Text
for(line = [[1, 0, "MERKKAA"], [-7, 0, "TAI VIE POIS"],[-11, 0, ""]]) {
    translate([text_x_off+line[1],line[0],plat_thick]) linear_extrude(text_thick) text(line[2], 6, font="Liberation Sans:style=Bold");
}

// Tap
translate([tap_x_off, 0, 0]) cylinder(tap_height, tap_d/2, tap_d/2, $fn = 32);
