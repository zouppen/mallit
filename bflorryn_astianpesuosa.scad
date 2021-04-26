nail_len = 7;
nail_h = 1.5;
nail_w = 1;
nail_split = 0.5; // how long is the sloped part of the whole nail

// Ring outer diameter and width
ring_d = 25;
ring_w = 5;
ring_h = 2;
// Inner wall
inner_w = 1;
inner_h = 6;

$fn = 128;

// Laskennalliset
inner_r = ring_d/2-ring_w;

holcyl(inner_r+ring_w, inner_r, ring_h);
holcyl(inner_r+ring_w, inner_r, ring_h);
holcyl(inner_r+inner_w, inner_r, inner_h);

intersection() {
    union () {
        translate([0,0,inner_h-nail_h*nail_split]) holcyl(inner_r+inner_w+nail_w, inner_r+inner_w, nail_h*nail_split, nail_w);
        translate([0,0,inner_h-nail_h]) holcyl(inner_r+inner_w+nail_w, inner_r+inner_w, ((1-nail_split)*nail_h));

    }
    union () {
        cube([nail_len,50,50], center=true);
        cube([50,nail_len,50], center=true);
    }
}


module holcyl(radius_out, radius_in, height, slope=0) {
    translate([0,0,height/2]) difference() {
        cylinder(height,radius_out,radius_out-slope, center = true);
        cylinder(2*height,radius_in,radius_in, center = true);
    }    
}