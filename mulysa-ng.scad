include <BOSL2/std.scad>

box = 15;
cham = 1.5;
overlap = 1*cham;
face_size = 9;
face_depth = 0.5;
ring_size = 10;
ring_depth = 0.6;
ring_fn = 100;

eps = 0.01;

voxels = str("X   ",
             " XX ",
             "XX  ",
             "    ",
             " X  ",
             "  X ",
             "XXX ",
             "    ",
             "    ",
             "X X ",
             " XX ",
             " X  ",
             "    ",
             "  X ",
             "X X ",
             " XX ");

module voxelbox(nx, ny, nz) {
    for (x = [0:nx-1]) {
        for (y = [0:ny-1]) {
            for (z = [0:nz-1]) {
                $pos = [x,y,z];
                children();
            }
        }
    }
}

diff() voxelbox(4,4,4) {
    if (has_box($pos)) {
        move(box*$pos) {
            cuboid(box+overlap, chamfer=cham, anchor=BOTTOM) {
                for (side = [BACK, FWD, LEFT, RIGHT]) {
                    if (!has_box($pos+side)) {
                        // Add logos on all open vertical surfaces
                        attach(side, TOP, inside=true, overlap=eps) {
                            logo(face_size, face_depth);
                        }
                    }
                }
                if (!has_box($pos+UP)) {
                    // Add ring if there's nothing on top
                    attach(UP, TOP, inside=true, overlap=eps) {
                        ring(ring_size, ring_depth, $fn=ring_fn);
                    }
                }
            }
        }
    }
}

function bounds(a) = a >= 0 && a <= 3;

function has_box(a) =
    bounds(a[0]) &&
    bounds(a[1]) &&
    bounds(a[2]) &&
    voxels[((a[2]*4)+a[1])*4+a[0]] == "X";

module logo(s, h) {
    size = [s, s, h];
    attachable(cp=size/2, size=size) {
        minkowski() {
            scale(s/20) linear_extrude(eps) import("assets/mulysa-hahmo.svg");
            zrot(180) wedge([eps, h, h], orient=BACK, anchor=BACK);
        }
        children();
    }
}

module ring(s, h) {
    tube(od=s, id=s/2, h=h);
}
