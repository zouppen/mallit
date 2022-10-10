/* Pirra, a traditional log drivers' amusement object
 * from Finland. All dimensions are in millimetres.
 *
 * Dimensions are similar to the original historical object
 * but this object is not historically accurate.
 *
 * Made by Joel Lehtonen.
 */

/* [Geometry] */
// Symbols on sides. Length determines the geometry, e.g. 6 elements generate a hexagon.
sym = ["1","2","3","4","5","X"];
// Tip angle
tip_angle=43;         
// Height of the whole object
height = 44;
// Handle height (topmost part)
handle_height = 16.5;
// Handle radius
handle_r = 2.7;
// Number part radius
pirra_r = 11.6;

/* [Text rendering] */
// Font
font = "Chilanka";
// Font size
text_size = 10;
// How deep are the letter indentations
text_indent=0.4;
// Letter base position from the tip
letter_z = 14.5;

/* [Hidden] */
sides = len(sym);
epsilon = 0.1; // To avoid overlapping triangles in rendering

intersection() {
    difference() {
        union() {
            // Pirra surface
            cylinder(height - handle_height, pirra_r, pirra_r, $fn=sides);
            // Pirra handle
            cylinder(height, handle_r, handle_r, $fn=6);
        }
        
        // Letter positioning
        letter_depth = pirra_r * cos(180/sides)-text_indent;
        for (reuna = [0:sides-1]) {
            rotate([90,0,(360/sides)*(reuna+0.5)]) {
                translate([letter_depth,letter_z,0]) {
                    rotate([0,90,0]) {
                        linear_extrude(text_indent+epsilon) {
                            text(sym[reuna], size=text_size, font=font, halign="center");
                        }
                    }
                }
            }
        }
    }
    // Tip
    cylinder(height, 0, height*tan(tip_angle), $fn=100);
}
