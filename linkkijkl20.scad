include <BOSL2/std.scad>

// 30min rapid nightly 3D design for the 20th anniversary of my
// student club.

diff() {
    spheroid(d=100, style="icosa", circum=true, $fn=18) {
        attach(BOTTOM,TOP) yscale(0.94) zcyl(d2=18.6, d1=50, h=50, $fn=6) {
            position(BOTTOM) zcyl(h=30, d2=0, d1=100, $fn=6, anchor=BOTTOM);
            for (side=[0:5]) {
                up(5) zrot(side*60) xrot(35) fwd(46) text3d(substr("LINKKI", side, 1), h=2, size=20, anchor=CENTER, font="Liberation Mono");
            }
            position(BOTTOM) zcyl(h=10, d=100, $fn=6, anchor=TOP) {
                tag("remove") position(BOTTOM) xrot(180) {
                    text_h = 0.7;
                    fwd(-10) text3d("Onnea 20-vuotias", h=text_h, size=5, anchor=TOP, font="Liberation Mono");
                    text3d("Linkki Jyväskylä ry", h=text_h, size=5, anchor=TOP, font="Liberation Mono");
                    fwd(10) text3d("toivottaa Zouppen", h=text_h, size=5, anchor=TOP, font="Liberation Mono");
                }
            }
        }
    }
    tag("remove") scale([1,1.6,1]) pie_slice(d=110, ang=90, l=110, anchor=CENTER, orient=LEFT, spin=45);
}
