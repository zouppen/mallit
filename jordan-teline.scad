/*
 * Futuristic dodecahedron-shaped toothbrush holder for
 * Jordan SoftClean™ Clean.
 */

// Radius of the toothbrush bottom
brush_bottom = 17;
// Radius of the toothbrush at "height"
brush_top = 12.1;
// Distance between the top and the toothbrush platform
brush_height = 28;
// Extra thickness to add to the bottom
base_thickness = 5;
// Screw hole indentation
screw_indent = 1;
// Screw head radius
screw_top = 8;
// Screw hole radius
screw_bot = 4;
// Screw head height
screw_height = 3;
// No need to change unless you're going to do a BIG one
screw_cutmargin = 5;
// How fine are the circles
$fn = 40;

module box(size) {
    cube([2*size, 2*size, size], center = true); 
}

module dodecahedron(size, ish=false) {
      dihedral = 116.565;
      intersection(){
            box(size);
            intersection_for(i=[1:5])  {
                union() {
                    rotate([dihedral, 0, 360 / 5 * i])  box(size); 
                    if (i==5 && ish) translate([-size,0,-size]) cube([2*size,size,2*size]);
                }
           }
      }
}

module brush_side_profile() {
    polygon([[0,0],[0,brush_height],[brush_top/2,brush_height],[brush_bottom/2,0]]);
}

module brush_base() {
    rotate_extrude() {
        brush_side_profile();
    }
}

// Opening where to push the brush into its place
module opening () {
    rotate([90,0,0]) {
        linear_extrude(brush_height) {
            mirror([90,0,0]) brush_side_profile();
            brush_side_profile();
        }
    }
    // The round hole for the brush
    brush_base();
}

// Just the dodecahedron at correct height
module dode_only() {
    translate([0,0,brush_height/2-base_thickness]) {
        rotate([0,0,0]) {
            dodecahedron(brush_height+base_thickness);
        }
    }
}

// Hole for the screw.
module screwhole() {
    translate([0,0,-screw_indent]) {
        rotate_extrude() {
            polygon([[0,screw_indent],[screw_top/2,screw_indent],[screw_top/2,0],[screw_bot/2,-screw_height],[screw_bot/2,-screw_height-screw_cutmargin], [0,-screw_height-screw_cutmargin]]);
        }
    }
}

// A part which can be printed with 100% infill to make the center of gravity
// lower. In case you want to use it as such without a screw
module bottom_weight() {
    difference () {
        real_height = (brush_height+base_thickness);
        translate([0,0,brush_height/2-base_thickness]) rotate([0,0,-126]) cylinder(real_height, real_height*0.38197,0, center=true, $fn = 5);
        screwhole();
        // Cut the top of the cone
        cylinder(real_height, real_height, real_height, $fn=4);
    }
}

// All other parts of the thing excluding the bottom weight.
// Safe to print with 10% gyroid infill.
module the_rest() {
    difference() {
        dode_only();
        opening();
        // This is just a wide hole. The height has some extra margin.
        mirror([0,0,1]) cylinder(2*base_thickness, screw_top/2, screw_top/2);
    }
}

// If you want to print a uniform one, just keep both.
// In case you want to use denser infill in the bottom piece,
// export them as two STLs and import them as a group to your slicer of choice.
bottom_weight();
the_rest();
