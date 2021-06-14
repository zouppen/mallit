
// Symbols on sides. Length must be equal to sides
sym = ["1","2","3","4","5","X"];

// All dimensions in mm
sides = 6;            // Hexagon
letter_z = 14.5;      // Letter base position from the tip
text_size = 10;       // Text size
font = "Ubuntu Mono"; // Font
tip_angle=45;         // Tip angle
height = 44;          // Height of the whole object
handle_height = 16.5; // Handle height (topmost part)
handle_r = 2.7;       // Handle radius
pirra_r = 11.6;       // Number part radius
text_indent=0.4;      // How deep are the letter indentations

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
