// Acer Acros 486 / Pentium desktop computer vertical orientation supports.
//
// The original are good but don't last 30 years of hard computing.
// Author: Joel Lehtonen

ura_h = 3.3;
ura_w = 11.85;
ura_d = 1.96;
tappi_h = 27.24;
tappi_w = 15.75;
tappi_inner_d_top = 1.7;
tappi_inner_d_bot = 1.7; //3.16;
tappi_roundness = 2;
tappi_outer_d = 1.6;
tappi_l = 40.86;
pohja_h = 4;
pohja_adj = 0.60;
jarru_dia = 12.8;
jarru_depth = 2.2;
jarru_y = 23;

module hulluus(w, h, d, scale=1) {
    mirror([0,1,0]) rotate([90,0,0]) linear_extrude(d, scale=scale) hull() {
        translate([-w/2,0,0]) square([w,0.1]);
        for(m = [0,1]) {
            mirror([m, 0, 0]) translate([w/2-tappi_roundness,h-tappi_roundness,0]) circle(r=tappi_roundness, $fn=16);
        }
    }
}

module triangle(w, h, d) {
    translate([0,0,-d/2]) linear_extrude(d) polygon([[0,0], [0,h], [w,h]]);
}

function inverse(start, end, step) =
    concat([[start,1/end]], [ for (x = [start : step : end]) [ x, 1/x] ]);

module ranni() {
    scale(1/(4-0.25)) translate([-0.25,-0.25,0]) polygon(inverse(0.25,6,0.05));
}

module leikkuuboksi() {
    intersection() {
        children();
        translate([0,0,50]) rotate([-90,0,0]) hulluus(tappi_w, tappi_inner_d_bot+ura_d+tappi_outer_d+tappi_l,100);
    }
}

// Slanted part
difference() {
    hulluus(tappi_w, tappi_h, tappi_inner_d_bot);
    rotate([90,0,90]) triangle(tappi_inner_d_bot-tappi_inner_d_top,tappi_h,tappi_w);
}

// Slot
translate([0,tappi_inner_d_bot,0]) hulluus(ura_w, tappi_h-ura_h, ura_d);

// Back part
leikkuuboksi() translate([0,tappi_inner_d_bot+ura_d,0]) {
    intersection() {
        translate([0,0,-pohja_h]) hulluus(tappi_w, tappi_h+pohja_h, tappi_l+tappi_outer_d);
        // Rounding
        union () {
            translate([0,0,50]) cube([100, 2*tappi_outer_d, 100], center=true);
            translate([0,tappi_outer_d,0]) rotate([90,0,90]) linear_extrude(tappi_w, center=true) scale(tappi_h) ranni();
        }
    }
}

// Bottom ja holetsu
leikkuuboksi() translate([0,0,-pohja_h]) difference() {
    translate([-tappi_w/2,0,0]) union() {
        cube([tappi_w,tappi_inner_d_bot+ura_d+tappi_outer_d+tappi_l,pohja_h-pohja_adj]);
        // Hotfix to fill a hole
        cube([tappi_w,tappi_inner_d_bot+ura_d+tappi_outer_d,pohja_h]);
    }        
    translate([0,jarru_y,0]) cylinder(jarru_depth, jarru_dia/2, jarru_dia/2, $fn=64);
}

