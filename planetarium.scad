include <gear.scad>;
$fn = 32;

tolerance = 0.25;
//radius
wireThickness = 0.75;
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

grooveDepth = 0.5;
grooveHeight = 3;

discSegment(170);
translate([0,0,segmentHeight])
%internal_gear (circular_pitch = gearPitch, gear_thickness = wallThickness, outer_radius = baseRadius - wallThickness+1);
/*
%translate([0,0, segmentHeight]) rotate([0,0,0]) discSegment(120);
%nonPrinted();
%translate([0,0,segmentHeight * 2 + topSegmentHeight]) base();

%translate([0,0,topSegmentHeight + segmentHeight * 2]) rotate([180, 0, 0]) topStopper();
*/
module arduino() {
    //Model
    translate([0,0,11])
    rotate([0,180,0])
    union() {
        translate([0,0,1])
        cube([43,18,2], center = true);
        translate([0,7.5,-4.5])
        cube([38, 2.5,9], center = true);
        translate([0,-7.5,-4.5])
        cube([38, 2.5,9], center = true);
        translate([43/2-2.5,0,6.5])
        cube([5,7,9], center = true);
        translate([-43/2+2.5,0,4])
        cube([9,8,4], center = true);
    }
    //Holder
    union() {
        translate([0,9 + tolerance/2 + wallThickness/2,9.5])
        cube([43,wallThickness, 19], center = true);
        translate([0,-9 - tolerance/2 - wallThickness/2,9.5])
        cube([43,wallThickness, 19], center = true);
        translate([-1,0,4.5])
        cube([30, 18 + tolerance + 0.1, 9], center = true);
    }
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

// https://www.kjell.com/se/sortiment/el-verktyg/elektronik/elektromekanik/strombrytare/mikrobrytare/mikrobrytare-extra-liten-p36054
module switch() {
    translate([-3.25,-6.4,0])
    rotate([0,0,15])
    translate([0,6.4,0])
    cube([0.5, 12.8, 5.8], center = true);
    cube([6.5, 12.8, 5.8], center = true);
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
                    translate([0, (armWidth + tolerance) / 2, armRadius + wallThickness * 2 + 3]) {
                        rotate([90,0,0]) {
                            tube(armRadius - wallThickness - tolerance/2 - 8, armRadius + tolerance/2, armWidth + tolerance);
                        }
                    }
                }
            
                //Arm gradle
                translate([0,0,wallThickness]) {
                    armGradle(gapWidth, armRadius);
                    mirror([0,1,0])
                    armGradle(gapWidth, armRadius);
                    translate([0,-(armWidth/2) - 26, wallThickness + 14 + wallThickness + tolerance / 2])
                    rotate([-90,-90,0])
                    union() {
                        stepper28BYJ48();
                        translate([0,0,32])
                        rotate([180, 0, 0])
                        difference() {
                            gear (circular_pitch=gearPitch,
                                gear_thickness = wallThickness,
                                rim_thickness = wallThickness,
                                hub_thickness = 6,
                                bore_diameter = 0,
                                circles=8,
                                number_of_teeth=10);
                            
                            translate([0,0,-0.1])
                            intersection() {
                                cylinder(r = 2.5, h = 8.5);
                                translate([0,0, 4])
                                cube([3, 10, 8], center = true);
                            }
                        }
                    }
                }
            }
            translate([0,0,-1])
            tube(baseRadius - wallThickness - ((driveGearRadius+tolerance) * 2), baseRadius - wallThickness + 0.01, wallThickness+2);
        }        
        
        translate([0,0,wallThickness])
            tube(ballbearingRadius, baseRadius - wallThickness + 0.01, wallThickness);
        internal_gear (circular_pitch = gearPitch, gear_thickness = wallThickness, outer_radius = baseRadius - wallThickness+1);
        
        //Disc connector
        translate([0,0,-grooveHeight * 7])
        union() {
            difference() {
                tube(ballbearingRadius, ballbearingRadius+wallThickness, grooveHeight * 7);
                for(i = [0:2]) {
                    translate([0,0,i*grooveHeight*2+grooveHeight])
                    tube(ballbearingRadius+wallThickness-grooveDepth, ballbearingRadius+wallThickness+grooveDepth, grooveHeight);
                }
                for(i = [0:2]) {
                    rotate([0,0,i*(45/3)])
                    translate([ballbearingRadius+wallThickness-grooveDepth-wireThickness,0,i*grooveHeight*2+grooveHeight])
                    union() {
                        cylinder(r = wireThickness, h = grooveHeight * 7);
                        translate([0,0,wireThickness])
                        rotate([0,90,0])
                        cylinder(r = wireThickness, h = wireThickness*2);
                    }
                }
            }
            rotate([0,0,45])
            for(i = [0:10]) {
                rotate([0,0,i*(300/10)])
                translate([ballbearingRadius+wallThickness/2,0,grooveHeight * 7])
                sphere(r = wallThickness/3);
            }
        }
        translate([0,0,segmentHeight-grooveHeight*7])
        difference() {
            tube(rodRadius+wallThickness+tolerance, rodRadius+wallThickness*2+tolerance, grooveHeight * 7);
            for(i = [0:2]) {
                translate([rodRadius+wallThickness,0,grooveHeight/2+i*grooveHeight*2+grooveHeight])
                rotate([0,90,0])
                cylinder(r = screwRadius, h = wallThickness * 2);
                rotate([0,0,25])
                translate([rodRadius+wallThickness*2,0,grooveHeight/2+i*grooveHeight*2+grooveHeight])
                cube([wallThickness * 2, wireThickness*2, grooveHeight], center = true);
                rotate([0,0,-25])
                translate([rodRadius+wallThickness*2,0,grooveHeight/2+i*grooveHeight*2+grooveHeight])
                cube([wallThickness * 2, wireThickness*2, grooveHeight], center = true);
            }
        }
        
        rotate([0,0,45])
        translate([0,24+18+wallThickness+tolerance + armWidth/2,wallThickness*2-0.1 + 20])
        rotate([0,90,-90])
        arduino();
        
        rotate([0,0,-15])
        translate([0,35,wallThickness*2])
        rotate([0,0,-90])
        union() {
            cylinder(r = 14 + wallThickness + tolerance/2, h = 14.01);
            translate([0,0,14])
            union() {
                stepper28BYJ48();
                translate([0,0,32])
                rotate([180, 0, 7.5])
                difference() {
                    gear (circular_pitch=gearPitch,
                        gear_thickness = wallThickness,
                        rim_thickness = wallThickness,
                        hub_thickness = 6,
                        bore_diameter = 0,
                        circles=8,
                        number_of_teeth=30);
                    
                    translate([0,0,-0.1])
                    intersection() {
                        cylinder(r = 2.5, h = 8.5);
                        translate([0,0, 4])
                        cube([3, 10, 8], center = true);
                    }
                }
            }
        }
    }
    
    translate([-rodRadius-tolerance*2,0, wallThickness*2 + 13])
    rotate([-90,0,0])
    switch();
    mirror([1,0,0])
    translate([-rodRadius-tolerance*2,0, wallThickness*2 + 13])
    rotate([-90,0,0])
    switch();
    //Arm
    translate([0, armWidth / 2, armRadius + wallThickness * 2 + 3]) {
        rotate([90,63,0]) {
            parts = 3;
            section = 180/parts;
            overlap = 10;
            lower = true;
            upper = true;
            i = 0;
            !intersection() {
                arm(armRadius, gapWidth);
                union() {
                    pieSlice(armRadius, 180+section*i+overlap, 180+section*(i+1)-overlap, armWidth);
                    intersection() {
                        pieSlice(armRadius, 180+section*i-overlap, 180+section*(i+1)+overlap, armWidth);
                        if(i % 2 == 1) {
                            tube(armRadius-armThickness/2, armRadius, armWidth);
                        }
                        if(i % 2 == 0) {
                            cylinder(r = armRadius-armThickness/2, h = armWidth);
                        }
                    }
                }
                union() {
                    if(lower)
                        pieSlice(armRadius, 180+section*i-overlap, 180+section*(i+1)+overlap, armWidth/2+0.01);
                    if(upper) {
                        translate([0,0,armWidth/2])
                        pieSlice(armRadius, 180+section*i-overlap, 180+section*(i+1)+overlap, armWidth/2+0.01);
                    }
                }
            }
        }
    }
    
}

module arm(armRadius, gapWidth) {
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
            translate([0,0,1])
            tube(armRadius-grooveDepth, armRadius+grooveDepth, grooveHeight);
            translate([0,0,armWidth-1-grooveHeight])
            tube(armRadius-grooveDepth, armRadius+grooveDepth, grooveHeight);
        }
        
        translate([0,0, -gapWidth + (rodRadius + 1) + (armWidth - (gapWidth * 2)) / 2])
        rotate([0,0,-90-(grooveAngle/2)])
        pieSlice(armRadius+1, 0, grooveAngle, gapWidth * 2);
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

module stepper28BYJ48() {
    translate([0,0,wallThickness + 0.1])
    union() {
        cylinder(r = 14, h = 19);
        translate([0,0,19])
        cylinder(r = 4.5, h = 1.5);
        translate([0,0,20.5])
        
        intersection() {
            cylinder(r = 2.5, h = 8.5);
            union() {
                translate([0,0, 3 + 1.49])
                cube([3, 10, 6], center = true);
                cylinder(r = 3, h = 1.5);
            }
        }
        
        difference() {
            translate([0,0,17])
            hull() {
                translate([0,17.5,0])
                cylinder(r = 3.5, h = 2);
                translate([0,-17.5,0])
                cylinder(r = 3.5, h = 2);
            }

            translate([0,17.5,0])
            cylinder(r = 2.1, h = 20);
            translate([0,-17.5,0])
            cylinder(r = 2.1, h = 20);
        }
        translate([8.5,0,9.5])
        cube([17,14.6,19], center = true);
    }
    
    translate([0,0,wallThickness])
    difference() {
        union() {
            difference() {
                translate([0,0,8.5])
                cube([28 + tolerance + wallThickness*2, 28 + tolerance + wallThickness*2, 17], center = true);
                translate([0,-20,-0.1])
                cube([40, 40, 19]);
            }
            translate([0,0,15])
            hull() {
                translate([0,17.5,0])
                cylinder(r = 3.5, h = 2);
                translate([0,-17.5,0])
                cylinder(r = 3.5, h = 2);
            }
        }
        translate([0,0,-0.1])
        cylinder(r = 14 + tolerance/2, h = 19);

        translate([0,17.5,-0.01])
        cylinder(r = 2.1, h = 20);
        translate([0,-17.5,-0.01])
        cylinder(r = 2.1, h = 20);
    }
    cylinder(r = 14 + wallThickness + tolerance/2, h = wallThickness + 0.01);
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