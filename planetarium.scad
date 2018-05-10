$fn = 32;

baseRadius = 60;
wallThickness = 4;

segmentHeight = 50;

rodRadius = 3;
ballbearingRadius = 11;
ballbearingHeight = 7;

armWidth = 20;
armThickness = 5;

//%translate([0,0, segmentHeight * 2]) rotate([0,180,0]) discSegment();
discSegment(170);
//nonPrinted();
base();

module discSegment (armRadius) {
    //Base
    difference() {
        difference() {
            difference() {
                cylinder(r = baseRadius, h = segmentHeight);
                translate([0,0, wallThickness]) cylinder(r = baseRadius - wallThickness, h = segmentHeight);
            }
            translate([0,0, -wallThickness]) cylinder(r = ballbearingRadius, h = wallThickness * 3);
        }
        translate([0,0, (segmentHeight / 2) + wallThickness])
        cube([baseRadius * 2 + 2, armWidth + 1, segmentHeight], center = true);
    }
    
    translate([0, armWidth / 2, armRadius + wallThickness + 3]) {
        rotate([90,45,0]) {
            difference() {
                difference() {
                    difference() {
                        cylinder(r = armRadius, h = armWidth);
                        translate([0,0,-1]) cylinder(r = armRadius - armThickness, h = armWidth + 2);
                    }
                    translate([-armRadius - 1, 0, -1]) cube([armRadius * 2 + 2, armRadius, armWidth + 2]);
                }
                translate([0,0, (rodRadius + 1) + (armWidth - ((rodRadius + 1) * 2)) / 2]) 
                cube([(armRadius / 3) * 5,armRadius * 3, (rodRadius + 1) * 2], center = true);
            }
        }
    }
    //https://www.ebay.com/itm/Micro-Mini-15MM-Stepper-Motor-2-Phase-4-Wire-Stepping-Motor-Copper-metal-Gear/192035808614?hash=item2cb639e566:g:cGAAAOSwRbtaLkod
    translate([0,-(armWidth/2) - 1, (wallThickness * 2) + 7.5])
    rotate([90,0,0])
    union() {
        difference() {
            difference() {
                cylinder(r = 7.5 + wallThickness, h = 11);
                translate([0,0,-1]) cylinder(r = 7.5, h = 11 + 2);
            }
            translate([0,-(8 + wallThickness),4.5]) cube([(8 + wallThickness) * 2, (8 + wallThickness) * 2, 11 + 2], center = true);
        }
        
        difference() {
            difference() {
                translate([0,0,5.5]) cube([(7.5 + wallThickness) * 2, (7.5 + wallThickness) * 2, 11], center = true);
                translate([0,0,4.5]) cube([(7.5) * 2, (7.5 + wallThickness) * 2, 11 + 2], center = true);
            }
            translate([0,(8 + wallThickness),4.5]) cube([(8 + wallThickness) * 2, (8 + wallThickness) * 2, 11 + 2], center = true);
        }
    }
}

module nonPrinted() {
    union() {
        //The main rod
        cylinder(r = rodRadius, h = 3 * segmentHeight);
        //A ball bearing
        cylinder(r = ballbearingRadius, h = ballbearingHeight);
    }
}

module base() {
    translate([0,0,segmentHeight * 2]) {
        cylinder(r = 55, h = 8);
        translate([0,0,8]) cylinder(r = 4, h = 60);
        translate([0,0,68]) sphere(r = 45);
    }
}