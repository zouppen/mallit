
sym = ["1","2","3","4","5","X"];

letter_depth = 9.4;
sides = 6;
letter_z = 14.5;
text_size = 10;
font = "Ubuntu Mono";

difference() {
    rotate_extrude($fn=sides) import("pirra.svg");
    #for (reuna = [0:sides-1]) {
        rotate([90,0,(360/sides)*(reuna+0.5)]) {
            translate([letter_depth,letter_z,0]) {
                rotate([0,90,0]) {
                    linear_extrude(5) {
                        text(sym[reuna], size=text_size, font=font, halign="center");
                    }
                }
            }
        }
    }
}
