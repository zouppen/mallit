module hattu() {
    import("assets/bdhat.3mf");
}

hattu();
translate([0,0,-2]) hull() hattu();
