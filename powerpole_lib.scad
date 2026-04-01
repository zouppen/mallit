powerpole_h = 25;

module powerpole_slot(extra) {
    // Make sure the cable fits
    clearance = [20.2, 12, 50];
    module tooth() {
        cuboid([5, $parent_size[2], 0.8], chamfer=0.5, edges=[TOP+RIGHT, TOP+LEFT]);
    }
    cuboid([16.4, 8.2, powerpole_h], anchor=TOP) {
        down(0.01) align(TOP) cuboid(clearance);
        attach(LEFT) tooth();
        attach(FWD) xcopies(8.2) tooth();
        // Drill hole
        up(15) back(2.2) position(BOTTOM+BACK) ycyl(l=31, d=3, anchor=BACK, $fn=24);
        children();
    }
}
