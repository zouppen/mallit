include <BOSL2/std.scad>

inner_d = 51;
hole_sep = 41;
hole_h = 10;
hole_guide = 0.8;
hole_d = 2.5;
cover_h = 27.8;
keepout_w = 20;
wall = 2;
top_wall = 4.5;
flat_cable_w = 7;
flat_cable_h = 2.4;
flat_cable_clearout = 5;
stop_screw_h = 7;
stop_screw_sep = 12.6;
chamfer = 5;
rect_edge = 2.2;
tol = 0.2;

tripolar_d = 6.6;
center_screw_d = 3;
center_screw_indent = 2;
center_screw_outer_d = 5.9;
guide_w = 2.2;
guide_l = 9;
guide_d = 3;
guide_adj = 8;

jussi = [55, 87.4, 14];
jussi_round = 8;
jussi_groove_w = 2;
jussi_groove_pos = 6.2;
jussi_print_aid = 1.8;

$fn=6;
inner_h = flat_cable_h+flat_cable_clearout;

module screw_holes() {
    xcopies(hole_sep) cyl(h=hole_h, d=hole_d) children();
}

module keepout() {
    cube([keepout_w, 2*keepout_w, inner_h]) children();
}

module tripolar() {
    for (ang = [-40,40,180]) {
        rotate(ang) back(0.3*25.4) cyl(d=tripolar_d, h=top_wall+0.01, $fn=60);
    }
}

module jussi() {
    tag_diff("jussi") back_half(y=-4) cuboid(jussi, rounding=jussi_round, edges=["Z"], $fn=100) {
        align(BOTTOM, inside=true) tag("remove") up(jussi_groove_pos) rect_tube(h=jussi_groove_w+jussi_print_aid, size=[jussi[0], jussi[1]], wall=jussi_groove_w, irounding=jussi_round+2) {
            tag("keep") back_half(y=-10.3)align(TOP, inside=true) prismoid(size1=[jussi[0]-2*jussi_groove_w,jussi[1]-2*jussi_groove_w], size2=[jussi[0],jussi[1]], h=jussi_print_aid, rounding=jussi_round+2, rounding2=jussi_round);
        }
    }
}

tag_diff("bottom") cuboid([inner_d + wall, inner_d + wall, inner_h+stop_screw_h+wall-jussi[2]], chamfer=chamfer, edges=["Z"]) tag("remove") {
    back(1) down(jussi[2]) align(BOTTOM+BACK, inside=true) jussi();
    align(TOP, inside=true) {
        keepout() {
            back(hole_d) position(FRONT) align(BOTTOM) xcopies(stop_screw_sep) cyl(h=stop_screw_h, d=hole_d);
        }
        screw_holes();
        rect_tube(h=rect_edge+tol, size=[inner_d+wall,inner_d+wall], wall=rect_edge+tol/2, chamfer=chamfer);
    }
    align(TOP+FRONT, inside=true) cube([flat_cable_w, 10, inner_h]);
}

up(40) tag_diff("top") cuboid([inner_d + wall, inner_d + wall, cover_h], chamfer=chamfer, edges=[TOP,"Z"]) {
    tag("remove") {
        down(10) align(BOTTOM, inside=true) cyl(h=cover_h-top_wall+10, d=inner_d-1, $fn=200) // inside
            left(guide_adj) align(TOP) cube([guide_l, guide_w, guide_d]); // guide
        align(TOP, inside=true) tripolar();
        align(TOP, inside=true) cyl(h=center_screw_indent, d=center_screw_outer_d, $fn=60)
            align(BOTTOM) cyl(h=top_wall, d=center_screw_d);// center screw hole

    };
    align(BOTTOM) rect_tube(h=rect_edge, size=[inner_d+wall,inner_d+wall], wall=rect_edge, chamfer=chamfer);
    align(BOTTOM+FRONT) cube([flat_cable_w-tol,wall,flat_cable_clearout]);
}
