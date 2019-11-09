include <arm/arm.scad>;
include <util/util.scad>;
include <gradle/gradle.scad>;

translate([0,0,170])
rotate([90,0,0])
arm(170, cache = true);
gradle(170);

tube(55, 60, 3);