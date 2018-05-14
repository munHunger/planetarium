include <gear.scad>;
$fn = 128;

tolerance = 1;

gearPitch = 200;

//M4x10
screwRadius = 2;
screwHeight = 10;

baseRadius = 60;
wallThickness = 4;

segmentHeight = 50;

rodRadius = 3;
ballbearingRadius = 11;
ballbearingHeight = 7;

armWidth = 20;
armThickness = 5;
gradleGrooveDepth = (wallThickness / 3) * 2;
grooveAngle = 135;
driveGearRadius = 15;

topSegmentHeight = 10;

%translate([0,0, segmentHeight]) rotate([0,0,0]) discSegment(120);
discSegment(170);
%nonPrinted();
%translate([0,0,segmentHeight * 2 + topSegmentHeight]) base();

%translate([0,0,topSegmentHeight + segmentHeight * 2]) rotate([180, 0, 0]) topStopper();

arduino();

module arduino() {
    translate([0,0,1])
    cube([43,18,2], center = true);
    translate([0,7.5,-4.5])
    cube([38, 2.5,9], center = true);
    translate([0,-7.5,-4.5])
    cube([38, 2.5,9], center = true);
    translate([43/2-2.5,0,5.5])
    cube([5,7,9], center = true);
    translate([-43/2+2.5,0,4])
    cube([9,8,4], center = true);
}

module topStopper() {
    difference() {
        cylinder(r = baseRadius, h = topSegmentHeight);
        translate([0,0,wallThickness])
            cylinder(r = baseRadius - wallThickness, h = topSegmentHeight);
    }
}

module tube(innerRadius, outerRadius, height) {
    difference() {
        cylinder(r = outerRadius, h = height);
        translate([0,0,-1]) cylinder(r = innerRadius, h = height + 2);
    }
}

module discSegment (armRadius) {
    gapWidth = rodRadius + tolerance;
    //Base
    union() {
        difference() {
            union() {
                difference() {
                    //Gap from center in arm
                    difference() {
                        difference() {
                            cylinder(r = baseRadius, h = segmentHeight);
                            translate([0,0, wallThickness]) cylinder(r = baseRadius - wallThickness, h = segmentHeight);
                        }
                        translate([0,0, -wallThickness]) cylinder(r = ballbearingRadius, h = wallThickness * 3);
                    }
                    translate([0,0, (segmentHeight / 2) / 2 + wallThickness*2.5])
                    cube([baseRadius * 2 + 2, armWidth + (tolerance * 2), segmentHeight/2], center = true);
                    
                }
            
                //Arm gradle
                translate([0,0,wallThickness]) {
                    armGradle(gapWidth, armRadius);
                    mirror([0,1,0])
                    armGradle(gapWidth, armRadius);
                    translate([0,-(armWidth/2) - 1, (wallThickness * 2) + 7.4])
                    rotate([90,0,0])
                    stepperMount();
                }
            }
            translate([0,0,-1])
            tube(baseRadius - wallThickness - ((driveGearRadius+tolerance) * 2), baseRadius - wallThickness + 0.01, wallThickness+2);
        }        
        
        translate([0,0,wallThickness])
            tube(ballbearingRadius, baseRadius - wallThickness + 0.01, wallThickness);
        internal_gear (circular_pitch = gearPitch, gear_thickness = wallThickness, outer_radius = baseRadius - wallThickness+1);

    }
    //Arm
    translate([0, armWidth / 2, armRadius + wallThickness * 2 + 3]) {
        rotate([90,45,0]) {
            difference() {
                difference() {
                    union() {
                        tube(armRadius - armThickness, armRadius, armWidth);
                        intersection() {
                            union() {
                                translate([0,0,wallThickness])
                                    internal_gear (circular_pitch = gearPitch, gear_thickness = armWidth/2-gapWidth-wallThickness-0.01, outer_radius = armRadius - armThickness);
                                translate([0,0,armWidth/2 + gapWidth + 0.01])
                                    internal_gear (circular_pitch = gearPitch, gear_thickness = armWidth/2-gapWidth-wallThickness-0.01, outer_radius = armRadius - armThickness);
                            }
                            rotate([0,0,-90-(grooveAngle/2)])
                            pieSlice(armRadius+5, 0, grooveAngle, armWidth);
                        }
                    }
                    translate([-armRadius - 1, 0, -1]) 
                    cube([armRadius * 2 + 2, armRadius, armWidth + 2]);
                }
                
                translate([0,0, -gapWidth + (rodRadius + 1) + (armWidth - (gapWidth * 2)) / 2])
                rotate([0,0,-90-(grooveAngle/2)])
                pieSlice(armRadius+1, 0, grooveAngle, gapWidth * 2);
            }
        }
    }
    
}

module pieSlice(r, start_angle, end_angle, height=10) {
    R = r * sqrt(2) + 1;
    a0 = (4 * start_angle + 0 * end_angle) / 4;
    a1 = (3 * start_angle + 1 * end_angle) / 4;
    a2 = (2 * start_angle + 2 * end_angle) / 4;
    a3 = (1 * start_angle + 3 * end_angle) / 4;
    a4 = (0 * start_angle + 4 * end_angle) / 4;
    if(end_angle > start_angle)
        linear_extrude(height) {
            intersection() {
            circle(r);
            polygon([
                [0,0],
                [R * cos(a0), R * sin(a0)],
                [R * cos(a1), R * sin(a1)],
                [R * cos(a2), R * sin(a2)],
                [R * cos(a3), R * sin(a3)],
                [R * cos(a4), R * sin(a4)],
                [0,0]
           ]);
          }
    }
}

module armGradle(gapWidth, armRadius) {
    difference() {
        intersection() {
            translate([0, gapWidth + (armWidth/2-gapWidth) + wallThickness + tolerance, armRadius + wallThickness + 3]){
                rotate([90, 0, 0]) {
                    union() {
                        tube(armRadius + tolerance, armRadius * 2, wallThickness + gradleGrooveDepth + tolerance);
                        tube(armRadius - (wallThickness + tolerance * 2), armRadius + tolerance, wallThickness);
                        tube(armRadius - (wallThickness + tolerance * 2) - wallThickness, armRadius - (wallThickness + 2), wallThickness + gradleGrooveDepth + tolerance);
                    }
                }
            }
            cylinder(r = baseRadius, h = segmentHeight);
        }
        cube([baseRadius,baseRadius,segmentHeight], center = true);
    }
}

//https://www.ebay.com/itm/Micro-Mini-15MM-Stepper-Motor-2-Phase-4-Wire-Stepping-Motor-Copper-metal-Gear/192035808614?hash=item2cb639e566:g:cGAAAOSwRbtaLkod
module stepperMount() {
    difference() {
        union() {
            //Upper
            difference() {
                tube(7.5, 7.5 + wallThickness, 11);
                translate([0,-(8 + wallThickness)-1,4.6]) cube([(8 + wallThickness) * 2, (8 + wallThickness) * 2 +1, 11 + 2], center = true);
            }

            //Straights
            difference() {
                difference() {
                    translate([0,0,5.5]) 
                    cube([(7.5 + wallThickness) * 2, (7.5 + wallThickness) * 2, 11], center = true);
                    translate([0,-1,4.6]) 
                    cube([(7.5) * 2, (7.5 + wallThickness) * 2, 11 + 2], center = true);
                }
                translate([0,(8 + wallThickness),4.6]) 
                cube([(8 + wallThickness) * 2, (8 + wallThickness) * 2, 11 + 2], center = true);
            }
            
            //Feet
            translate([7.5+wallThickness, -(7.5 + wallThickness), 0])
            cube([6,wallThickness,11]);
            mirror([1,0,0]) {
                translate([7.5+wallThickness, -(7.5 + wallThickness), 0])
                cube([6,wallThickness,11]);
            }
        }
        
        //Screwhole
        translate([0, 5, 5.5])
        rotate([-90, 0, 0]) 
        cylinder(r = screwRadius, h = screwHeight);
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
    cylinder(r = 55, h = 8);
    translate([0,0,8]) cylinder(r = 4, h = 60);
    translate([0,0,68]) sphere(r = 45);
}