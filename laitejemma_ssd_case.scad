// A box containing 2 SATA drives, 2x M.2 drive and room for cables

include <laitejemma.scad>

box = [110,50,90];

slots = [ ["size", [100 ,  7  , 69.9], "pos", [  0, -15]], // SATA drive 1
          ["size", [100 ,  7  , 69.9], "pos", [  0,  15]], // SATA drive 2
          ["size", [22  ,  4  , 80.2], "pos", [ 30,   5]], // M.2 drive 1
          ["size", [22  ,  4  , 80.2], "pos", [ 30,  -5]], // M.2 drive 2
          ["size", [50  , 12.6, 70  ], "pos", [-15,   0], "extra", false] ]; // Cable box

fingerslots = [30, -15];

render_box(box, slots, fingerslots);
