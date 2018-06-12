$fn=124;
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
gapWidth = rodRadius + tolerance;

rotate([0,0,90])
translate([0,0,wallThickness])
%arm(170, gapWidth);
clamp(170, gapWidth);

module clamp(armRadius, gapWidth) {
    gearThickness = 6;
    intersection() {
        difference() {
            union() {
                difference() {
                    //Base
                    tube(armRadius-armThickness-wallThickness-gearThickness, armRadius-armThickness/2,armWidth+wallThickness*2);
                    //Width
                    translate([0,0,wallThickness+(armWidth-(tolerance+armWidth))/2])
                    tube(armRadius-armThickness, armRadius+1, tolerance+armWidth);
                    //Inner guide
                    translate([0,0,wallThickness+(armWidth-(tolerance+armWidth-wallThickness*2))/2])
                    tube(armRadius-armThickness-gearThickness, armRadius+1, tolerance+armWidth-wallThickness*2);
                }
                //Guide rail
                translate([0,0,wallThickness+(armWidth-gapWidth*2)/2])
                tube(armRadius-armThickness-wallThickness-gearThickness, armRadius-armThickness/2, gapWidth*2);
            }
            //ScrewHole
            rotate([0,0,10])
            translate([armRadius-armThickness*4,0,(wallThickness*2+armWidth)/2])
            rotate([0,90,0])
            cylinder(r = screwRadius, h = armThickness*5);
        }
        pieSlice(armRadius,0,20,armWidth+wallThickness*2);
    }

    intersection() {
        difference() {
            //Base
            tube(armRadius-(armThickness/4), armRadius+wallThickness*2,armWidth+wallThickness*2);
            //Width
            translate([0,0,wallThickness+(armWidth-(tolerance+armWidth))/2])
            tube(armRadius-armThickness, armRadius+1, tolerance+armWidth);
            //Nut
            rotate([0,0,10])
            translate([armRadius+wallThickness,0,(wallThickness*2+armWidth)/2])
            rotate([0,90,0])
            cylinder($fn = 6, r = 10, h = 50);
            //ScrewHole
            rotate([0,0,10])
            translate([armRadius-armThickness*4,0,(wallThickness*2+armWidth)/2])
            rotate([0,90,0])
            cylinder(r = screwRadius, h = armThickness*5);
        }
        pieSlice(armRadius+wallThickness*3,0,20,armWidth+wallThickness*2);
    }
}

module arm(armRadius, gapWidth) {
    difference() {
        difference() {
            tube(armRadius - armThickness, armRadius, armWidth);
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
module tube(innerRadius, outerRadius, height) {
    difference() {
        cylinder(r = outerRadius, h = height);
        translate([0,0,-1]) cylinder(r = innerRadius, h = height + 2);
    }
}