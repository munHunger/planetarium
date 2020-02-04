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
                rotate([0,0,15])
                translate([0,armRadius + ballbearingOuter + wallThickness + 2 * tolerance,0])
                union() {
                    if(!alfa) {
                        // tube(ballbearingInner, ballbearingOuter, ballbearingHeight);
                    }
                    translate([0,0,ballbearingHeight])
                    m2x4Insert(alfa = alfa);
                    translate([0,0,2])
                    mirror([0,0,1])
                    tension();
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


    for (i=[0:1]) {
        mirror([i,0,0])
        translate([35,0.5,0])
        union() {
            translate([-2.5,-2.5,0])
            cube(size=[5, 5, thickness/2], center=false);
            translate([0,0,thickness/2]) {
                intersection() {
                    spring(alfa = true);
                    translate([-2.5,-2.5,0])
                    cube(size=[5, 5, 2], center=false);
                }
                // %spring(alfa = false);
            }
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

module tension() {
    tube(ballbearingOuter, ballbearingOuter + wallThickness, ballbearingHeight);

    difference() {
        hull() {
            cylinder(r = ballbearingOuter + wallThickness, h = ballbearingHeight);
            rotate([0,0,-25])
            translate([10,0,0])
            cylinder(r = ballbearingInner, h = ballbearingHeight);
        }
        translate([0,0,-1])
        cylinder(r = ballbearingOuter, h = ballbearingHeight + 2);
    }

    hull() {
        rotate([0,0,-25])
        translate([10,0,0])
        cylinder(r = ballbearingInner, h = ballbearingHeight);
        rotate([0,0,-11.5])
        translate([20,0,0])
        cylinder(r = ballbearingInner, h = ballbearingHeight);
    }

    rotate([0,0,-11.5])
    translate([20,0,0])
    union() {
        cylinder(r = ballbearingInner, h = ballbearingHeight * 2);
        // translate([0,0,ballbearingHeight])
        // %tube(ballbearingInner, ballbearingOuter, ballbearingHeight);
    }

    rotate([0,0,-25])
    translate([10,0,1.5])
    rotate([-90,0,0])
    intersection() {
        spring(alfa = true);
        translate([-2.5,-2.5,0])
        cube([5,5,3]);
    }
}

module testRig() {
    intersection() {
        part(170);
        translate([23,-1,0])
        cube(size=[40, 10, 20], center=false);
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