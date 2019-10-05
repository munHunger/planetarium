include <../util/gear.scad>;
include <../util/util.scad>;
wireThickness = 0.75;
tolerance = 0.5;
gearPitch = 200;

armThickness = 5;
armWidth = 20;
gradleGrooveDepth = 7;

amr2(170);
module amr2(armRadius, cache = true) {
    //https://www.slojd-detaljer.se/sortiment/tra-metallslojd/plat-folie-gjutmetall/massing/massingplat-2716
    module brass() {
        brassThickness = 1.5;
        grooveAngle = 135;
        intersection() {
            internal_gear (circular_pitch = gearPitch, gear_thickness = brassThickness, outer_radius = armRadius - armThickness + 2);
            rotate([0,0,-90-(grooveAngle/2)])
            pieSlice(armRadius+5, 0, grooveAngle, brassThickness);
        }
        intersection() {
            tube(armRadius - armThickness, armRadius, brassThickness);
            rotate([0,0,180])
            pieSlice(armRadius+5, 0, 180, brassThickness);
        }
    }
    //https://www.slojd-detaljer.se/sortiment/tra-metallslojd/plast-gummi/akrylplastskivor/akrylplastskiva-frostad-3090
    module plexiglas() {
        thickness = 3;
        intersection() {
            tube(armRadius - armThickness, armRadius, thickness);
            rotate([0,0,180])
            pieSlice(armRadius+5, 0, 180, thickness);
        }
    }
    module part() {
        brass();
        translate([0,0,1.5])
        plexiglas();
    }

    if(cache) {
        import("arm170.stl");
    }
    else {
        $fn = 256;
        part();
        translate([0,0,4.5*2 + gradleGrooveDepth])
        mirror([0,0,1])
        part();
    }
}

// %arm(170, 4);
module arm(armRadius, gapWidth) {
    armWidth = 20;
    armThickness = 5;
    gradleGrooveDepth = (wallThickness / 3) * 2;
    grooveAngle = 135;
    grooveDepth = 0.5;
    grooveHeight = 3;

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