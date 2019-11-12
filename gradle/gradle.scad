include <../util/util.scad>;
include <../util/properties.scad>;
include <../bits/bits.scad>;

thickness = 3;
height = 15;
gradleOffset = height / 2;

module part(armRadius) {
    module bearing(alfa = false) {
        translate([0,0,armRadius])
        rotate([-90,0,0]) {
            for (i=[0:1]) {
                mirror([i,0,0])
                rotate([0,0,10])
                translate([0,armRadius + ballbearingOuter,0])
                union() {
                    if(!alfa) {
                        tube(ballbearingInner, ballbearingOuter, ballbearingHeight);
                    }
                    translate([0,0,ballbearingHeight])
                    m2x4Insert(alfa = alfa);
                }
            }
        }
    }

    module connector(alfa = false){
        for (i=[0:1]) {
            mirror([i,0,0])
            translate([discRadiusInner - 5, ballbearingHeight + thickness, 0])
            rotate([90,0,0])
            m2x4Insert(alfa = alfa);
        }
    }

    translate([0,0,gradleOffset]) {
        bearing();
        connector();

        difference() {
            translate([0,thickness / 2 + ballbearingHeight,0])
            rotate([90,0,0])
            cube([discRadiusInner * 2, height, thickness], center = true);
            bearing(alfa = true);
            connector(alfa = true);
        }
    }
}

module gradle(armRadius) {
    for(i=[0:1]) {
        mirror([0,i,0])
        translate([0,gradleGrooveDepth,0])
        intersection() {
            part(armRadius);
            cylinder(r = discRadiusInner, h = height);
        }
    }
}