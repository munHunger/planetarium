include <./arm.scad>;
// projection() 

mirror([0,0,1])
intersection() {
    arm(170, cache = false);
    rotate([0,0,180])
    pieSlice(190, 0, 55, height);
}

// arm(170, cache = false);
// arm(110, cache = false);