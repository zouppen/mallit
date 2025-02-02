include <BOSL2/std.scad>

box = 15;
cham = 1.5;
letter_size = 10;
letter_rot = 90;
letter_h = 0.5;

drop = [[2,1,2],
        [2,1,1],
        [1,1,2],
        [2,2,2]];

letters = [[2,0, "M"],
           [1,0, "U"],
           [0,0, "L"],
           [0,1, "Y"],
           [0,2, "S"],
           [1,2, "A"]];

text_fix = [0.3,0.0,0];

module formation() {
    for (x = [0,1,2]) {
        for (y = [0,1,2]) {
            for (z = [0,1,2]) {
                pos = [x, y, z];
                if (!in_list(pos, drop)) {
                    move(box*pos) {
                        $pers = y==2;
                        //$outo
                        children();
                    }
                }
            }
        }
    }
}

diff() formation() {
    cuboid(box, chamfer=cham, anchor=BOTTOM) {
        if ($pers) {
            tag("remove") fwd(0.3) attach(BACK) logo(10, 1);
        }
    }
}

for (el = letters) {
    pos = [el[0]+text_fix[0], el[1]+text_fix[1], 3+text_fix[2]];
    move(box*pos) {
        size = [letter_size, letter_size, letter_h];
        attachable(cp=[0,0], size=size) {
            linear_extrude(letter_h)
                text(el[2], letter_size, "Source Code Pro:style=Bold", spin=letter_rot, halign="center", valign="baseline");
            children();
        }
    }
}

module logo(s, h) {
    size = [20, 20, h];
    scale([s/20,s/20, 1]) attachable(cp=size/2, size=size) {
        linear_extrude(h) import("assets/mulysa-hahmo.svg");
        children();
    }
}
