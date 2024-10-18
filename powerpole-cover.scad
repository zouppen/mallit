// Powerpole cover for Chunzehui F-1005

// Screw hole diameter
screwhole_d = 4.2;
// Screw hole separation (y)
screwhole_sep = 25;
// Screw support height (z)
wing_support = 2;
// Powerpole depth (y)
pp_d = 16;
// Powerpole width (x)
pp_w = 8;
// Powerpole height (z)
pp_h = 12.7;
// Powerpole position from bottom (y)
pp_y = 12.3;
// Powerpole position from left (x)
pp_x = 12.3;
// Wing width (where screws are)
wing_w = 10;
// Powerpole count
poles = 9;
// Box height (from screw wing to base)
box_h = 19.2;
// To make drawing correct, add some extra where it doesn't matter
epsilon = 0.05;
// Pole block width
all_poles_w = 136;
// Cover depth
cover_d = 63;
// Cover empty space
cover_hollowness = 9;
// Cover wall width
cover_wall = 4;
// Rounding radius
rounding_r = 2;

box_w = 2*pp_x + all_poles_w;

module pp() {
    cube([pp_w, pp_d, pp_h+epsilon]);
}

module pps() {
    pole_sep = (all_poles_w - pp_w) / (poles - 1);
    
    for(i = [0 : poles-1]) {
        translate([pole_sep*i,0,0]) pp();
    }
}

module cover() {
    r = rounding_r;
    balls = [[r,r], [box_w-r, r], [box_w-r, cover_d-r], [r, cover_d-r]];

    // Frame
    difference() {
        union() {
            // Balls
            hull() translate([0,0,pp_h-r]) for(ball_pos = balls) {
                translate(ball_pos) sphere(r, $fn = 30);
            }
            translate([0,0,-r]) linear_extrude(pp_h) hull() for(ball_pos = balls) {
                translate(ball_pos) circle(r, $fn = 30);
            }
        }
        translate([cover_wall,cover_wall,-epsilon-r]) cube([box_w - 2*cover_wall, cover_d - 2*cover_wall, pp_h-cover_wall+2*epsilon+r]);
        
        // Bottom balls
        hull() translate([0,0,-r]) for(ball_pos = balls) {
            translate(ball_pos) sphere(r, $fn = 30);
        }
    }
}

module cover_with_pps() {
    difference() {
        cover();
        translate([pp_x,pp_y,0]) pps();
    }
}

module wing() {
    wing_d = screwhole_sep + 2*screwhole_d;
    difference() {
        translate([0,0,wing_support/2]) cube([wing_w,wing_d,wing_support], center = true);
        wing_holes();
    }
    wing_slope();
}

module wing_slope() {
    extr = screwhole_sep - 2*screwhole_d;
    tot_h = box_h + pp_h - rounding_r; 
    translate([wing_w/2,-extr/2,0]) rotate([90,0,180]) linear_extrude(extr) {
        polygon([[0,wing_support], [0, tot_h], [wing_w, wing_support]]);
    }
}

module wing_holes() {
    for(y = [-screwhole_sep/2, screwhole_sep/2]) {
        translate([0,y,-epsilon]) {
            cylinder(wing_support + 2*epsilon, d=screwhole_d, $fn = 12);
        }
    }
}

module wings() {
    // Left
    translate([-wing_w/2,cover_d/2,0]) wing();
    // Right
    translate([wing_w/2 + box_w,cover_d/2,0]) mirror([1,0,0])wing();

}

module everything() {
    wings();
    translate([0,0,box_h]) cover_with_pps();
}

everything();
