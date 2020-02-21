include <../util/util.scad>;
include <../util/properties.scad>;
include <../bits/bits.scad>;

thickness = 3;
height = 15;
gradleOffset = height / 2;

module part(armRadius, printTension = true, printInsert = true, printRail = true) {
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
                    if(!printInsert && alfa)
                        m2x4Insert(alfa = alfa);
                    translate([0,0,2])
                    mirror([0,0,1])
                    if(printTension)
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

    module pattern() {
        translate([0,7,0])
        for(n = [0:1])
        mirror([n,0,0])
        rotate([90,0,0]) {
            for(x = [0:1:2]) {
                translate([-11*x,0,0])
                union() {
                    if(x != 1)
                        cylinder(r = 3, h = thickness + 2, $fn = 6);
                    for(i = [0:1:1]) {
                        rotate([0,0,(360/6)*(i+1)])
                        translate([0,6,0])
                        cylinder(r = 3, h = thickness + 2, $fn = 6);
                    }
                }
            }
        }
    }

    module m2Slot() {
        for(i = [-1:2:1]) {
            translate([i*11,gradleGrooveDepth,0])
            rotate([90,0,0]) {
                hull() {
                    gap = (height-thickness-2)/2;
                    translate([0,gap,0])
                    union() {
                        translate([0,0,2.8])
                        mirror([0,0,1])
                        cone(1,2,1.5);
                        cylinder(r = 1, h = thickness + 2);
                    }
                    translate([0,-gap,0])
                    union() {
                        translate([0,0,2.8])
                        mirror([0,0,1])
                        cone(1,2,1.5);
                        cylinder(r = 1, h = thickness + 2);
                    }
                }
            }
        }
    }

    translate([0,0,gradleOffset]) {
        if(printRail)
            for(i = [0:1])
                mirror([i,0,0])
                translate([11,2,-4])
                rotate([90,0,0])
                rail();

        bearing();
        if(printInsert)
            connector();

        difference() {
            translate([0,thickness / 2 + ballbearingHeight,0])
            rotate([90,0,0])
            cube([discRadiusInner * 2, height, thickness], center = true);
            pattern();
            bearing(alfa = true);
            connector(alfa = true);
            m2Slot();
        }
    }
}

module rail() {
    difference() {
        cylinder(r = 3, h = 4);
        m2x4Insert(alfa = true);
    }

    translate([-5,2,0]) {
        cube([10,4,1]);
        translate([0,0,2.75])
        cube([10,4,1]);
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
        part(170, printTension = false, printInsert = false);
        translate([23,-1,0])
        cube(size=[40, 10, 20], center=false);
    }
}

module gradle(armRadius, printTension = true, printInsert = true, printRail = true) {
    for(i=[0:0]) {
        mirror([0,i,0])
        translate([0,gradleGrooveDepth,0])
        intersection() {
            part(armRadius, printTension, printInsert, printRail);
            cylinder(r = discRadiusInner, h = height);
        }
    }
}