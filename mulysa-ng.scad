include <BOSL2/std.scad>

box = 15;
cham = 1.5;
voxels = " X    X XXX         X X  XX  X        X X X  XX      X    XX XX ";

diff() up(4*box+2*cham) xrot(180) {
    for (x = [0:3]) {
        for (y = [0:3]) {
            for (z = [0:3]) {
                pos = [x,y,z];
                if (is_box(pos)) {
                    move(box*pos) {
                        cuboid(box+cham*2, chamfer=cham, anchor=BOTTOM) {
                            tag("remove") {
                                for (side = [BACK, FWD, LEFT, RIGHT]) {
                                    echo(pos, pos+side);
                                    if (!is_box(pos+side)) {
                                        attach(side) logo(10, 1);
                                    }
                                }
                                if (!is_box(pos+DOWN)) {
                                    attach(BOTTOM) sirkkeli(10, 1);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

function bounds(a) = a >= 0 && a <= 3;

function is_box(a) = bounds(a[0]) && bounds(a[1]) && bounds(a[2]) && voxels[((a[2]*4)+a[1])*4+a[0]] == "X";

module logo(s, h) {
    size = [20, 20, h];
    xrot(180) scale([s/20,s/20, 1]) attachable(cp=size/2, size=size) {
        linear_extrude(h) import("assets/mulysa-hahmo.svg");
        children();
    }
}

module sirkkeli(s, h) {
    tube(od=s, id=s/2, h=1, $fn=100);
}
