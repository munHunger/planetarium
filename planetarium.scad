include <arm/arm.scad>;
include <util/util.scad>;
include <gradle/gradle.scad>;
include <bits/bits.scad>;
include <util/properties.scad>;

module disc(armRadius) {
    rotate([0,0,$t*360]) {
        translate([0,0,armRadius + gradleOffset])
        rotate([90,50 - 100 * sin($t * 180),0])
        arm(armRadius, cache = true);
        gradle(armRadius);

        translate([0,35,0]) {
            nema11StandingMount();
            nema11();
        }

        translate([0,-50,20 + wallThickness])
        rotate([0,90,90])
        union() {
            nema11LyingMount(20);
            nema11();
        }

        tube(discRadiusInner, discRadiusOuter, 3);
    }
}

module disc2(armRadius) {
    rotate([0,0,$t*360*-1]) {
        translate([0,0,armRadius + gradleOffset])
        rotate([90,50 - 100 * abs(sin($t * 180 + 45)),0])
        arm(armRadius, cache = true);
        gradle(armRadius);

        translate([0,35,0]) {
            nema11StandingMount();
            nema11();
        }

        translate([0,-50,20 + wallThickness])
        rotate([0,90,90])
        union() {
            nema11LyingMount(20);
            nema11();
        }

        tube(discRadiusInner, discRadiusOuter, 3);
    }
}

disc(170);
translate([0,0,50])
disc2(110);

translate([0,0,100])
%globe();
module globe() {
    translate([0,0,70])
    sphere(r=50);
    cylinder(r=55, h=10, center=false);
    cylinder(r=2, h= 70);
}