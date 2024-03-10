include <BOSL2/std.scad>

pipe_d = 17.5;
//pipe_outer_sep = 76.1;
//pipe_sep = pipe_outer_sep-pipe_d;
pipe_h = 20;
pipe_gap = 10;
hand_w = 4;
disc_d = 89.5;
disc_thin = 1.4;

thin_w = 3.3; // width of thinnig, ~1/8 inch
thru_deg = 17; // through-the plate
thin_deg = 46; // thin part degrees
openings_deg = 60; // degrees between openings

$fn=200;

module pipe_part() {
    d = pipe_d;
    ang_in = 6;
    ang_out = 30;
    rounding = 1;
    teardrop(d=d+2*hand_w, h=pipe_h, ang=ang_out, cap_h=d/2, chamfer=rounding) {
        tag("remove") teardrop(d=d, h=pipe_h, ang=ang_in, cap_h=d/2, chamfer=-rounding);
        children();
    }
}

module guide() {
    d_large = disc_d+1;
    align(BOTTOM, inside=true) pie_slice(h=hand_w-disc_thin, d=d_large, ang=thin_deg) {
        align(BOTTOM, inside=true) pie_slice(h=hand_w, d=d_large, ang=thru_deg, spin=thin_deg-thru_deg);
    }
}

module guides() {
    tag_scope() diff() tag("remove") cyl(h=hand_w, d=disc_d-thin_w*2) tag("rest") {
        zrot(thru_deg/2-thin_deg) for (angle=[0, openings_deg, 180, 180+openings_deg]) {
            zrot(angle) guide();
        }
    }
}

difference () {
    cyl(h = hand_w, d=disc_d, chamfer1=1) {
        tune = 2;
        tag_scope() diff() for (pos=[FRONT,BACK]) {
            move(tune*pos) xrot(180) down(hand_w) align(TOP+pos) pipe_part();
        }
    }
    guides();

}
