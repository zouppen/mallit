include <pathbuilder/pathbuilder.scad>
include <BOSL2/std.scad>

function svg_region(str) = apply(conv, make_region(svgPoints(str)));

conv = move([-295,405]) * scale(0.264583) * yflip(); //scale(1/40) * yflip() * zrot(-90) * left(10);

hand_h = 20.7;
hand_deg = 175.5;
hand_tol = 0.2;
hand_wall = 2;
hand_roof = 2;
hole = [4,2];
hand_final_adj = fwd(3.7) * right(11.06) * zrot(-90); // Sorry, you need to adjust after walls etc.

hands_sep = 69;

ext_len = 80;
ext_hand_h = 18;
ext_hand_w = 3;
ext_hand_x = 19;
ext_hand_y = 2.6;

catcher_w = 200;
catcher_d = 2;
catcher_y = 80;

fire_pit = [9,10];
fire_pit_wall = [2, 2];

maski_o = svg_region("
m 1068.951,1493.7771
h 95.1927
v 82.0649
h -95.1927
z
");

ripustus_o = svg_region("
m 1120.05,1595.6
c -10,-16.37 -15,-27.37 -16.73,-38.43 -4.65,-29.67 -3.93,-33.19 -13.14,-96.9
l 35.21,-2.32
c 1.05,9.44 2.56,32.09 5.67,49.86 3.11,17.73 3.07,18.99 8.78,45.69 0.65,3.03 3.83,8.93 6.76,11.48 9.27,8.06 15.93,11.31 24.98,18.45 -21.48,0.05 -38.96,4.18 -51.53,12.17
z
");

$align_msg=false;

inside_part = offset(ripustus_o, delta = hand_tol/2);
outside_part = intersection(offset(ripustus_o, r = hand_wall), maski_o);

module hand() {
    safe = 30;
    rot = (180-hand_deg)/2;

    tag_diff("hand") {
        multmatrix(hand_final_adj) bottom_half(z=hand_h+hand_roof) xrot(-rot) {
            linear_sweep(outside_part, h=hand_h+safe);
            tag("remove") down(1) linear_sweep(inside_part, h=hand_h+1);
            tag("remove") up(hand_wall-hand_tol) cuboid([safe, hole[0]+hand_tol, hole[1]+hand_tol], anchor=BOTTOM) {
                for (side = [FWD, BACK]) {
                    tag("remove") position(TOP+side) cuboid(safe, anchor=TOP-side, edges=TOP-side, chamfer=hole[1]+hand_tol+hand_wall);
                }
            }
        }
    }
}

base_level = hand_h+hand_roof;

module front_part() {
    form = apply(back(base_level), rect([ext_hand_w,ext_hand_h], anchor=TOP, chamfer=[0, 0, ext_hand_w/2, ext_hand_w/2]));
    p = [[hands_sep/2+ext_hand_x, ext_hand_y], [0, ext_len], [-hands_sep/2-ext_hand_x, ext_hand_y]];
    path_sweep(form, p);
}

module catcher() {
    // The catcher (thread guide)
    fine_tune_y = 2;
    form = rect(catcher_d, anchor=TOP, chamfer=[0, catcher_d/3, catcher_d/3, 0]);
    form_diag = circle(d=catcher_d*0.955, $fn=6, spin=23.3);
    p = [[catcher_w/2, catcher_y], [0,0], [-catcher_w/2, catcher_y]];
    bar_rel_pos = 0.15;
    bar_z_adj= -0.9;
    bar_bottom_adj = [0, 0, 0];
    p_diag = [[catcher_w/2*bar_rel_pos, catcher_y*bar_rel_pos, bar_z_adj], [0,0, -hand_h]+bar_bottom_adj, [-catcher_w/2*bar_rel_pos, catcher_y*bar_rel_pos, bar_z_adj]];
    move([0, ext_len+fine_tune_y, base_level]) path_sweep(form, p);
    move([0, ext_len+fine_tune_y, base_level]) path_sweep(form_diag, p_diag);

}

module fire_pit() {
    frontcut = 2;
    pitpos = 1;
    move([0,ext_len,base_level]) cuboid([fire_pit[0], fire_pit[1], ext_hand_h], anchor=TOP) {
        align(BACK, inside=true, shiftout=frontcut) cube([$parent_size[0]-2*fire_pit_wall[0], $parent_size[1]-fire_pit_wall[1]+frontcut, $parent_size[2]+1]);
        // Take out the residual from diagonal bar
        tag("remove") align(BOTTOM) cube(10);
    }
}

// Hands
diff() {
    xflip_copy(offset=hands_sep/2) hand();
    front_part();
    catcher();
    fire_pit();
}
