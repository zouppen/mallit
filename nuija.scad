
module box(size) {
    cube([2*size, 2*size, size], center = true); 
}

module dodecahedron(size, ish=false) {
      dihedral = 116.565;
      intersection(){
            box(size);
            intersection_for(i=[1:5])  {
                union() {
                    rotate([dihedral, 0, 360 / 5 * i])  box(size); 
                    if (i==5 && ish) translate([-size,0,-size]) cube([2*size,size,2*size]);
                }
           }
      }
}

handle_l=58;

scale(4) difference() {
    union() {
        rotate([0,180,0]) dodecahedron(20);
        hull() rotate([90,180,0]) rotate([0,0,90]) {
            linear_extrude(handle_l-1.5) rotate([0,26,0]) circle(2.636, $fn=5);
            linear_extrude(handle_l) rotate([0,26,0]) circle(1.5, $fn=5);
        }
    }
    
    translate([-4.5,0.9,9.7]) linear_extrude(1) scale(0.04) import("/home/joell/vektori/hacklab-logo-ng-mv.svg");

    translate([1,-handle_l+2,1.5]) linear_extrude(5) rotate([0,0,90]) text("Hacklab Jyväskylä ry.", size=1.9, font="Hack:style=Bold");
    translate([0,0,-15+0.3]) linear_extrude(5) rotate([0,180,0]) text("λ", halign="center", valign="center", size=6, font="Liberation Sans:style:Bold");

}
