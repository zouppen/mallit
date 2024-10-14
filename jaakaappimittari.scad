// A box for holding Clas Ohlson temperature and humidity
// sensor. https://www.clasohlson.com/fi/Lampotila-anturi---kosteusmittari/p/36-6726

wall = 2;
meter_width = 38.5;
meter_depth = 19.5;
extra_plate = 70;
cupsize = 30; // Depth of the cup where meter is dropped
extraction = 10; // To make RF conditions better

difference() {
    translate([0,(meter_depth+wall-extraction)/2,(cupsize+wall)/2]) {
        cube([meter_width+2*wall,meter_depth+wall+extraction,cupsize+wall], center=true);
    }
    
    translate([0,meter_depth/2,cupsize/2+wall]) {
        cube([meter_width,meter_depth,cupsize], center=true);
    }
}

translate([-extra_plate/2,-extraction,0]) {
    cube([extra_plate, wall, cupsize+wall]);
}
