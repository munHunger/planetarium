include <gear.scad>;
$fn = 256;

tolerance = 0.5;
//radius
wireThickness = 0.75;
gearPitch = 200;

//M4x10
screwRadius = 2;
screwHeight = 10;

m2Radius = 1.1;
m2Height = 21;
m2HeadHeight = 1.5;
m2HeadRadius = 2;
m2NutRadius = 2.4;
m2NutHeight = 2;

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
/*
%translate([0,0, segmentHeight]) rotate([0,0,0]) discSegment(120);
%nonPrinted();
%translate([0,0,segmentHeight * 2 + topSegmentHeight]) base();

%translate([0,0,topSegmentHeight + segmentHeight * 2]) rotate([180, 0, 0]) topStopper();
*/

//clamp(170);
module clamp(armRadius) {
    gapWidth = rodRadius + tolerance;
    rotate([0,0,90])
    translate([0,0,wallThickness])
    arm(armRadius, gapWidth);
    intersection() {
        union() {
            tube(armRadius, armRadius+wallThickness, armWidth+wallThickness*2);
            translate([0,0,(armWidth-grooveDepth)/2+wallThickness])
            tube(armRadius-wallThickness, armRadius, grooveDepth);
        }
        pieSlice(armRadius+wallThickness, 0,45, armWidth+wallThickness*2);
    }
}

module ledHolder(armRadius, printSprings = true) {
    springRadius = 15;
    springHeight = 3;
    intersection() {
        union() {
            difference() { //Base
                tube(armRadius-armThickness-wallThickness-tolerance, armRadius-armThickness-tolerance, armWidth);
                translate([0,0,armWidth/2])
                rotate([0,90,10])
                cylinder(r=1.75, h = armRadius*2); //LED hole
                rotate([0,0,10])
                translate([armRadius-armThickness-wallThickness-tolerance + wallThickness/2,0,armWidth/2])
                rotate([0,90,0])
                cylinder(r=2.5, h = 15); //LED hole
            }
            union() { //Prongs
                springAngle = 10;
                if(printSprings) {
                    rotate([0,0,springAngle])
                    translate([armRadius+tolerance+springHeight/2,0,0])
                    spring(springRadius, springHeight, mirror = true);
                    rotate([0,0,springAngle])
                    translate([armRadius+tolerance+springHeight/2,0,armWidth-wallThickness])
                    spring(springRadius, springHeight, mirror = false);
                }
                difference() {
                    translate([0,0,armWidth/2-(m2NutHeight*2+wallThickness*2)/2])
                    tube(armRadius+tolerance+springHeight/2, armRadius+tolerance+springHeight+m2NutRadius+wallThickness, m2NutHeight*2+wallThickness*2);
                    rotate([0,0,springAngle])
                    translate([springHeight + wallThickness / 2 - wallThickness / 3 + armRadius+tolerance+springHeight/2,0,0])
                    cylinder(r = m2Radius, h = 50);
                    translate([0,0,(armWidth / 2) - ((m2NutHeight * 3) / 2)]) {
                        hull() {
                            rotate([0,0,springAngle])
                            translate([springHeight + wallThickness / 2 - wallThickness / 3 + armRadius+tolerance+springHeight/2,0,0])
                            cylinder(r = m2NutRadius, h = m2NutHeight * 3, $fn = 6);
                            rotate([0,0,springAngle])
                            translate([springHeight + wallThickness / 2 - wallThickness / 3 + armRadius+tolerance+springHeight/2 + 10,0,0])
                            cylinder(r = m2NutRadius, h = m2NutHeight * 3, $fn = 6);
                        }
                    }
                }
            }
        }
        pieSlice(armRadius+tolerance+wallThickness+springHeight+m2NutRadius+0.1, 0, 15, armWidth);
    }
    intersection() { //prong connector
        tube(armRadius-armThickness-tolerance-0.1, armRadius+tolerance+wallThickness+0.1, armWidth);
        pieSlice(armRadius+tolerance+wallThickness+0.2, 0, 5, armWidth);
    }
}

module arduino() {
    //Model
    /*
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
    */
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
//stepperMotorDriverMount();
module stepperMotorDriverMount() {
    difference() {
        translate([0,0,1.5])
        cube([37,34,3], center = true);
        translate([0,0,2.01])
        cube([35,32,2],center=true);
    }
    translate([0,0,1]) {
        translate([15,13,0])
        cylinder(r = 1, h = 2);
        translate([-15,13,0])
        cylinder(r = 1, h = 2);
        translate([15,-13,0])
        cylinder(r = 1, h = 2);
        translate([-15,-13,0])
        cylinder(r = 1, h = 2);
    }
}

//https://www.mouser.se/images/microsites/Kycondimen.png
module microUSB(height) {
    hull() {
        translate([0,1.23/2,0])
        cube([6.9, 1.23, height], center = true);
        translate([0,-0.65,0])
        cube([5.4, 0.1, height], center = true);
    }
}

module discSegment (armRadius, printGradle = true, printArduino = false, printTopStepper = false , printSwitches = false, printArm = false) {
    gapWidth = rodRadius + tolerance;
    //Base
    union() {
        color([0.9,0.9,0.9])
        difference() {
            union() {
                difference() {
                    //Gap from center in arm
                    difference() {
                        difference() {
                            cylinder(r = baseRadius, h = segmentHeight);
                            translate([0,0, wallThickness*2-0.01]) cylinder(r = baseRadius - wallThickness, h = segmentHeight);
                        }
                        translate([0,0, -wallThickness]) cylinder(r = ballbearingRadius, h = wallThickness * 3);
                    }
                    translate([0, (armWidth + tolerance) / 2, armRadius + wallThickness * 2 + 3]) {
                        rotate([90,0,0]) {
                            tube(armRadius - wallThickness - tolerance/2 - 8, armRadius + tolerance/2, armWidth + tolerance);
                        }
                    }
                    translate([0,0,-0.01])
                    tube(ballbearingRadius+wallThickness, baseRadius-wallThickness, wallThickness);
                }
                internal_gear (circular_pitch = gearPitch, gear_thickness = wallThickness, outer_radius = baseRadius - wallThickness+1);
            
                //Arm gradle
                if(printGradle) {
                    translate([0,0,wallThickness*2]) {
                        translate([baseRadius/2 + m2NutRadius + wallThickness*2+m2NutRadius*4, 0,wallThickness+m2NutHeight+0.1]) {
                            nutHole(m2NutRadius, m2NutHeight, m2Radius);
                            translate([2,0,wallThickness+m2NutHeight+6])
                            rotate([0,0,-90])
                            switch();
                            translate([5,0,wallThickness+m2NutHeight+1])
                            cube([wallThickness/2, wallThickness, 14], center = true);
                        }
                        armGradle(gapWidth, armRadius, inner = true);
                        mirror([0,1,0])
                        !armGradle(gapWidth, armRadius, inner = false);
                        translate([0,-(armWidth/2) - 26, wallThickness + 16 + wallThickness + tolerance / 2])
                        rotate([-90,-90,0])
                        union() {
                            stepper28BYJ48(vertical = false);
                            //Stepper gear
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
            }
            //Charger
            rotate([0,0,30])
            translate([0, baseRadius, segmentHeight/2])
            rotate([90,-90,0])
            microUSB(20);

            //Screws
            //Gradle
            union() {
                for(i = [0:1:1]) {
                    mirror([i,0,0]) {
                        translate([22,-22,0]) {
                            screw(m2Radius, m2Height, m2HeadRadius, m2HeadHeight);
                            cylinder(r = m2HeadRadius, h = wallThickness + m2HeadHeight);
                        }
                        translate([baseRadius/2 + m2NutRadius - wallThickness,0,-0.01]) {
                            screw(m2Radius, m2Height, m2HeadRadius, m2HeadHeight);
                            cylinder(r = m2HeadRadius, h = wallThickness + m2HeadHeight);
                        }
                        translate([baseRadius/2 + m2NutRadius + (wallThickness+m2NutRadius*4),0,-0.01]) {
                            screw(m2Radius, m2Height, m2HeadRadius, m2HeadHeight);
                            cylinder(r = m2HeadRadius, h = wallThickness + m2HeadHeight);
                        }
                    }
                }
            }
            //topStepper
            union() {
                for(i = [0:1:1]) {
                    rotate([0,0,-15])
                    translate([0,35,0])
                    rotate([0,0,-90])
                    mirror([0,i,0]) {
                        translate([0,22,wallThickness-0.02])
                        screw(m2Radius, m2Height, m2HeadRadius, m2HeadHeight);
                    }
                }
            }
        }        
        
        //Arduino
        if(printArduino) {
            color([0.6,0.1,0.3])
            rotate([0,0,45])
            translate([0,24+18+wallThickness+tolerance + armWidth/2,wallThickness*2-0.1 + 20])
            rotate([0,90,-90])
            arduino();
        }
        
        //Top stepper motor
        if(printTopStepper) {
            color([0.3,0.9,0.7])
            rotate([0,0,-15])
            translate([0,35,wallThickness*2])
            rotate([0,0,-90])
            union() {
                cylinder(r = 14 + wallThickness + tolerance/2, h = 14.01);
                translate([0,0,14])
                union() {
                    stepper28BYJ48(vertical = true, verticalOffset = -14);
                    /*
                    //Stepper gear
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
                    */
                }
            }
        }
        
    }
    
    //Limit switches
    if(printSwitches) {
        color([1.0, 0.1, 0.7])
        union() {
            translate([-rodRadius-tolerance*2,0, wallThickness*2 + 13])
            rotate([-90,0,0])
            switch();
            mirror([1,0,0])
            translate([-rodRadius-tolerance*2,0, wallThickness*2 + 13])
            rotate([-90,0,0])
            switch();
        }
    }
    
    //Arm
    //3 SECTION
    if(printArm) {
        translate([0,0,wallThickness])
        union() {
            color([0.4,0.4,0.4])
            translate([0, armWidth / 2, armRadius + wallThickness * 2 + 3]) {
                rotate([90,63,0]) {
                    armPart(4, true, false, 1, armRadius, gapWidth);
                    armPart(4, false, true, 1, armRadius, gapWidth);
                }
            }
            translate([0, armWidth / 2, armRadius + wallThickness * 2 + 3]) {
                rotate([90,63,0]) {
                    armPart(4, true, false, 2, armRadius, gapWidth);
                    armPart(4, false, true, 2, armRadius, gapWidth);
                }
            }
            color([0.6,0.6,0.6])
            translate([0, armWidth / 2, armRadius + wallThickness * 2 + 3]) {
                rotate([90,63,0]) {
                    armPart(4, true, true, 0, armRadius, gapWidth);
                    armPart(4, true, true, 3, armRadius, gapWidth);
                }
            }
            translate([0, armWidth / 2, armRadius + wallThickness * 2 + 3]) 
            rotate([90,63,0])
            rotate([0,0,180]) 
            ledHolder(armRadius);
        }
    }
}

module armPart(parts, showUpper, showLower, i, armRadius, gapWidth) {
    section = 180/parts;
    overlap = 5;
    intersection() {
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
            if(showLower)
                pieSlice(armRadius, 180+section*i-overlap, 180+section*(i+1)+overlap, armWidth/2+0.01);
            if(showUpper) {
                translate([0,0,armWidth/2])
                pieSlice(armRadius, 180+section*i-overlap, 180+section*(i+1)+overlap, armWidth/2+0.01);
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
        
        translate([0,0, (armWidth - (gapWidth * 2)) / 2])
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

//testArmGradleConnector();
module testArmGradleConnector() {
    gapWidth = rodRadius + tolerance;
    armRadius = 170;
    difference() {
        translate([0,0,wallThickness/2]) {
            cube([110,wallThickness*2, wallThickness], center = true);
            translate([0,-22,0]) {
                cube([(22+m2NutRadius+wallThickness)*2,wallThickness*2,wallThickness], center = true);
                translate([0,0,wallThickness])
                cube([30,wallThickness*2,wallThickness], center = true);
            }
            translate([0,-11,0])
            cube([wallThickness,22,wallThickness],center = true);
        }
        translate([22,-22,0])
        screw(m2Radius, m2Height, m2HeadRadius, m2HeadHeight);
        translate([baseRadius/2 + m2NutRadius,0,-0.01])
        screw(m2Radius, m2Height, m2HeadRadius, m2HeadHeight);
        translate([baseRadius/2 + m2NutRadius + (wallThickness*2+m2NutRadius*4),0,-0.01])
        screw(m2Radius, m2Height, m2HeadRadius, m2HeadHeight);
        mirror([1,0,0]) {
            translate([22,-22,0])
            screw(m2Radius, m2Height, m2HeadRadius, m2HeadHeight);
            translate([baseRadius/2 + m2NutRadius,0,-0.01])
            screw(m2Radius, m2Height, m2HeadRadius, m2HeadHeight);
            translate([baseRadius/2 + m2NutRadius + (wallThickness*2+m2NutRadius*4),0,-0.01])
            screw(m2Radius, m2Height, m2HeadRadius, m2HeadHeight);
        }
    }
}

module screw(radius, height, headRadius, headHeight) {
    cylinder(r = headRadius, h = headHeight);
    translate([0,0,headHeight-0.01])
    cylinder(r = radius, h = height);
}

module spring(springRadius, springHeight, mirror = false) {
    if(!mirror) {
        springHelper(springRadius, springHeight);
    }
    if(mirror) {
        translate([0,0,wallThickness])
        mirror([0,0,1])
        springHelper(springRadius, springHeight);
    }
}
module springHelper(springRadius, springHeight) {
    union() { //Spring
        intersection() {
            translate([springRadius-springHeight/2,0,0])
            tube(springRadius, springRadius + wallThickness / 3, (wallThickness / 3) * 2);
            translate([-springRadius,-springRadius,0])
            cube([springRadius, springRadius*2, wallThickness]);
        }
        intersection() {
            translate([-springRadius+springHeight/2,0,0])
            tube(springRadius, springRadius + wallThickness / 3, (wallThickness / 3) * 2);
            translate([0,-springRadius,0])
            cube([springRadius, springRadius*2, wallThickness]);
        }
        translate([springHeight + wallThickness / 2 - wallThickness / 3,0,wallThickness])
        rotate([180,0,0])
        difference() {
            translate([0,0,0])
            cylinder(r = m2Radius + wallThickness / 2, h = wallThickness);
            translate([0,0,-0.01])
            screw(m2Radius, m2Height, m2HeadRadius, m2HeadHeight);
        }
    }
}

module armGradle(gapWidth, armRadius, inner, printSprings = false) {
    springRadius = 30;
    springHeight = 5;
    union() {
        difference() {
            intersection() {
                union() {
                    difference() {
                        translate([0, gapWidth + (armWidth/2-gapWidth) + wallThickness + tolerance, armRadius + wallThickness + 3]){
                            rotate([90, 0, 0]) {
                                union() {
                                    tube(armRadius - (wallThickness + tolerance*4), armRadius * 2, wallThickness);
                                    tube(armRadius - (wallThickness + tolerance * 5) - wallThickness, armRadius - (wallThickness + tolerance*4)+0.01, wallThickness + gradleGrooveDepth + tolerance);
                                }
                            }
                        }
                        //nut holes
                        for(i = [0:1:1]){
                            mirror([i,0,0]) {
                                translate([0, gapWidth + (armWidth/2-gapWidth) + wallThickness + tolerance, armRadius + wallThickness + 3])
                                rotate([90,0,0])
                                rotate([0,0,-13])
                                translate([0,-armRadius-springHeight/2-(springHeight + wallThickness / 2 - wallThickness / 3),screwHeight / 2])
                                rotate([180,0,0])
                                cylinder(r = m2ScrewRadius, h = screwHeight);
                            }
                        }
                        //nut holders
                        for(i = [0:1:1]) {
                            mirror([i,0,0]) {
                                translate([0, gapWidth + (armWidth/2-gapWidth) + wallThickness + tolerance, armRadius + wallThickness + 3])
                                rotate([90,0,0])
                                rotate([0,0,-13])
                                translate([0, -armRadius-springHeight/2-(springHeight + wallThickness / 2 - wallThickness / 3), m2NutHeight-0.01])
                                rotate([180,0,0])
                                cylinder(r=m2NutRadius, h=m2NutHeight, $fn = 6);
                            }
                        }
                    }
                }
                cylinder(r = baseRadius - wallThickness - tolerance, h = segmentHeight);
            }
            cube([armWidth,baseRadius,segmentHeight], center = true);
        }
        if(printSprings) {
            translate([0, gapWidth + (armWidth/2-gapWidth) + wallThickness + tolerance, armRadius + wallThickness + 3]){
                rotate([90, 0, 0]) {
                    for(i = [0:1:1]) {
                        mirror([i,0,0]) {
                            rotate([0,0,13])
                            translate([0,-armRadius-springHeight/2,wallThickness + tolerance])
                            rotate([0,0,-90])
                            spring(springRadius, springHeight);
                        }
                    }
                }
            }
        }

        //Support bar
        translate([0, gapWidth + (armWidth/2-gapWidth) + wallThickness + tolerance - wallThickness / 2,wallThickness/2])
        cube([baseRadius, wallThickness, wallThickness],center = true);
        
        if(inner) {
            nutOffset = 0;
            for(i = [0:1:1]) {
                mirror([i,0,0]) {
                    translate([baseRadius/2 + m2NutRadius + nutOffset - wallThickness, 0,0]) {
                        nutHole(m2NutRadius, m2NutHeight, m2Radius);
                        translate([-wallThickness/2,m2Radius,0])
                        cube([wallThickness,gapWidth + (armWidth/2-gapWidth) + wallThickness + tolerance - m2Radius ,wallThickness]);
                    }
                }
            }
        }
        else {
            nutOffset = wallThickness*2+m2NutRadius*4;
            for(i = [0:1:1]) {
                mirror([i,0,0]) {
                    translate([baseRadius/2 + m2NutRadius + nutOffset - wallThickness, 0,0]) {
                        nutHole(m2NutRadius, m2NutHeight, m2Radius);
                        translate([-wallThickness/2,m2Radius,0])
                        cube([wallThickness,gapWidth + (armWidth/2-gapWidth) + wallThickness + tolerance - m2Radius ,wallThickness]);
                    }
                }
            }
        }
    }
}

module nutHole(nutRadius, height, screwRadius) {
    difference() {
        cylinder(r = nutRadius + wallThickness, h = height + wallThickness);
        translate([0,0,wallThickness+0.01])
        cylinder(r = nutRadius, h = height, $fn = 6);
        translate([0,0,-0.01])
        cylinder(r = screwRadius, h = height + wallThickness);
    }
}

module switch() {
    translate([-2,-4.5,3])
    cube([2,2,6], center = true);
    translate([2,-4.5,3])
    cube([2,2,6], center = true);
    translate([0,4.5,3])
    cube([6,1,2], center = true);
    translate([0,0,1])
    cube([6,10,2], center = true);
}

module stepper28BYJ48(printMotor = false, vertical = false, verticalOffset) {
    if(printMotor) {
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
    }
    translate([0,0,wallThickness])
    difference() {
        union() {
            difference() {
                translate([0,0,8.5])
                cube([28 + tolerance + wallThickness*2+12, 28 + tolerance + wallThickness*2, 17], center = true);
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
        translate([0,0,-0.1]) {
            cylinder(r = 14 + tolerance, h = 19);
            if(vertical) {
                tube(20, 35, 19);
            }
        }

        translate([0,17.5,-0.01])
        cylinder(r = 2.1, h = 20);
        translate([0,-17.5,-0.01])
        cylinder(r = 2.1, h = 20);
    }
    cylinder(r = 14 + wallThickness + tolerance/2, h = wallThickness + 0.01);
    for(i = [0:1:1]) {
        mirror([0,i,0]) {
            if(!vertical) {
                translate([-24.25,0,14])
                rotate([0,90,0])
                translate([0,22,0])
                nutHole(m2NutRadius, m2NutHeight, m2Radius);
            }
            else {
                translate([0,22,verticalOffset])
                nutHole(m2NutRadius, m2NutHeight, m2Radius);
            }
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
    cylinder(r = 55, h = 8);
    translate([0,0,8]) cylinder(r = 4, h = 60);
    translate([0,0,68]) sphere(r = 45);
}