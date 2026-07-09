include <BOSL2/std.scad>
include <powerpole_lib.scad>

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa=1;
$fs=0.2;
$align_msg = false;

board = [160, 70, 3];
board_round = 18;
screwhole_d = 7;
screw_pos = [110, 56];
eps = 0.1;
pp_grid = [25, 17];
pp_constellation = [3,2];
pp_offset = 20;
conex_d = 28;
conex_flat = 1;
conex_off = -44;
pp_tower_base = [80,38];
pp_tower_top = [70,30];

diff() {
    cuboid(board, edges="Z", rounding=board_round) {
        tag("remove") grid_copies(screw_pos) zcyl(h=$parent_size[2]+eps, d=screwhole_d);
        tag("remove") left(pp_offset) attach(BOTTOM) grid_copies(pp_grid, n=pp_constellation) {
            powerpole_slot($tap_side = ($row==1));
        }

        tag("remove") left(conex_off) {
            zcyl(h=$parent_size[2]+eps, d=conex_d) {
                tag("keep") position(FWD) cuboid([$parent_size[0], conex_flat, board[2]], anchor=FWD);
            }
        }

        // Tower
        left(pp_offset) position(TOP) prismoid(pp_tower_base, pp_tower_top, h=powerpole_h-board[2], $anchor=BOTTOM);
    }
}
