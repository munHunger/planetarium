$fn = 32;

baseRadius = 60;
wallThickness = 4;

segmentHeight = 50;

rodRadius = 3;
ballbearingRadius = 11;
ballbearingHeight = 7;

armWidth = 20;
armThickness = 5;

%translate([0,0, segmentHeight * 2]) rotate([0,180,0]) discSegment();
discSegment(170);
%nonPrinted();
%base();

module tube(innerRadius, outerRadius, height) {
    difference() {
        cylinder(r = outerRadius, h = height);
        translate([0,0,-1]) cylinder(r = innerRadius, h = height + 2);
    }
}

module discSegment (armRadius) {
    //Base
    %difference() {

    //Gap from center in arm
    gapWidth = rodRadius + 1;
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

    //Arm gradle
    difference() {
        translate([0, gapWidth + wallThickness * 2 + (armWidth/2-gapWidth), armRadius + wallThickness + 3]){
            rotate([90, 0, 0]) {
                tube(armRadius + 1, armRadius * 2, wallThickness * 2);
                tube(armRadius - (wallThickness + 2), armRadius + 1, 5);
            }
        }
        union() {
            translate([0, 0, (armRadius * 3 + segmentHeight)])
            cube([armRadius * 6, armRadius * 6, armRadius * 6], center = true);
            translate([0, 0, -(armRadius * 3)])
            cube([armRadius * 6, armRadius * 6, armRadius * 6], center = true);
            translate([(armRadius * 3 + baseRadius - 4), 0, 0])
            cube([armRadius * 6, armRadius * 6, armRadius * 6], center = true);
            translate([-(armRadius * 3 + baseRadius - 4), 0, 0])
            cube([armRadius * 6, armRadius * 6, armRadius * 6], center = true);
        }
    }
    
    //Arm
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
            }
        }
    }
    
    translate([0,-(armWidth/2) - 1, (wallThickness * 2) + 7.5])
    rotate([90,0,0])
    stepperMount();
}

//https://www.ebay.com/itm/Micro-Mini-15MM-Stepper-Motor-2-Phase-4-Wire-Stepping-Motor-Copper-metal-Gear/192035808614?hash=item2cb639e566:g:cGAAAOSwRbtaLkod
module stepperMount() {
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