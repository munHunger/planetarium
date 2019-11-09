include <../util/util.scad>;
include <../util/properties.scad>;

module gradle(armRadius) {
    translate([0,0,armRadius])
    rotate([-90,0,0]) {
        for (i=[0:1]) {
            mirror([i,0,0])
            rotate([0,0,10])
            translate([0,armRadius + ballbearingOuter,0])
            tube(ballbearingInner, ballbearingOuter, ballbearingHeight);
        }
    }
}