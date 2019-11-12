include <../util/gear.scad>;
include <../util/util.scad>;
include <../util/properties.scad>;

module arm(armRadius, cache = true) {
    //https://www.slojd-detaljer.se/sortiment/tra-metallslojd/plat-folie-gjutmetall/massing/massingplat-2716
    module brass() {
        brassThickness = 1.5;
        grooveAngle = 135;
        difference() {
            union() {
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
            translate([0,0,-1])
            for (x=[0:1]) {
                mirror([x,0,0])
                for (i=[0:1]) {
                    rotate([0,0,-2-i*5])
                    translate([armRadius - armThickness / 2,0,0])
                    cylinder(r=1, h=brassThickness + 2); //m2 screw
                }
            }
        }
    }
    //https://www.slojd-detaljer.se/sortiment/tra-metallslojd/plast-gummi/akrylplastskivor/akrylplastskiva-frostad-3090
    module plexiglas() {
        thickness = 3;
        difference() {
            union() {
                // base
                intersection() {
                    tube(armRadius - armThickness, armRadius, thickness);
                    rotate([0,0,180])
                    pieSlice(armRadius+5, 0, 180, thickness);
                }
                // Enforce end
                union() {
                    for (i=[0:1]) {
                        mirror([i,0,0])
                        rotate([0,0,180]) {
                            filetSection(armRadius - armThickness - thickness - 0.5, armRadius - armThickness, thickness, 15, inner = true);
                            filetSection(armRadius - 0.5, armRadius + thickness, thickness, 15, inner = false);
                        }
                    }
                }
            }

            translate([0,0,-1])
            for (x=[0:1]) {
                mirror([x,0,0])
                for (i=[0:1]) {
                    rotate([0,0,-2-i*5])
                    translate([armRadius - armThickness / 2,0,0])
                    cylinder(r=2, h=thickness + 2); //4mm threaded insert for m2 screw
                }
            }
        }
    }
    module part() {
        brass();
        translate([0,0,1.5])
        plexiglas();
    }

    if(cache) {
        if(armRadius == 170)
            import("arm/arm170.stl");
        if(armRadius == 110)
            import("arm/arm110.stl");
    }
    else {
        $fn = 256;
        $fn = 64;

        translate([0,0,-(4.5*2 + gradleGrooveDepth) / 2]) {
            part();
            translate([0,0,4.5*2 + gradleGrooveDepth])
            mirror([0,0,1])
            part();
        }
    }
}
