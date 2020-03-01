include <../util/util.scad>;
include <../util/properties.scad>;

// https://www.amazon.com/Glarks-Threaded-Embedment-Assortment-Printing/dp/B07L96KVP3/ref=sr_1_1_sspa?keywords=m2+threaded+insert&qid=1573320468&sr=8-1-spons&psc=1&spLa=ZW5jcnlwdGVkUXVhbGlmaWVyPUEyOEpTWUVaQk5ISEM5JmVuY3J5cHRlZElkPUEwMjA3NDQxM1A0TU82MTVMWDlGRiZlbmNyeXB0ZWRBZElkPUEwMjcxNzkxMzFMV1lGM0xDN1pDOSZ3aWRnZXROYW1lPXNwX2F0ZiZhY3Rpb249Y2xpY2tSZWRpcmVjdCZkb05vdExvZ0NsaWNrPXRydWU=
module m2x4Insert(alfa = false) {
    if(alfa) {
        translate([0,0,-0.1])
        cylinder(r = 3.5/2, h = 4.2);
    }
    else {
        tube(1, 3.5/2, 4);
    }
}

module switch(open = 0, alfa = false) {
    width = 12.8;
    heigth = 5.8;
    depth = 5.8;
    module screwAlfa() {
        distance = 6.5;
        translate([-1,width/2 - distance/2,heigth-5.1])
        rotate([0,90,0])
        union() {
            cylinder(r = 1, h = depth + 2);
            translate([0,distance,0])
            cylinder(r = 1, h = depth + 2);
        }
    }

    if(alfa) {
        screwAlfa();
    }
    else {
        difference() {
            cube([depth,width,heigth]);
            screwAlfa();
        }

        pinDistance = 5.15;
        translate([depth/2,width / 2 - pinDistance,-2.5])
        for(i = [0:2]) {
            translate([0,pinDistance * i,0])
            cube([0.6,0.6,5], center = true);
        }

        translate([depth / 2 - 3.05 / 2, 1, heigth])
        rotate([5 + open * 5,0,0])
        cube([3.05, 13.5, 0.1]);
    }
}

module stepper() {
    rotate([0,0,180])
    translate([0,0,wallThickness + 0.1])
    union() {
        cylinder(r = 14, h = 19);
        translate([-8,0,19])
        cylinder(r = 4.5, h = 1.5);
        translate([0,0,20.5])
        
        translate([-8,0,0])
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

// https://www.amazon.com/Motor-1-8deg-Bipolar-35x35x26mm-4-wire/dp/B00PNEPQ8E/ref=sr_1_1?crid=1V94EJOTKYCLG&keywords=nema14+stepper&qid=1582572173&sprefix=nema14%2Caps%2C241&sr=8-1
module nema14(alfa = false) {
    height = 26;
    module screws() {
        for(i=[0:3]) {
            rotate([0,0,90*i])
            translate([13,13, height])
            cylinder(r = 1.5, h = 5, center = true); //m3 screw
        }
    }
    if(alfa) {
        screws();
    }
    else {
        difference() {
            union() {
                translate([0,0,height / 2])
                cube([35.2, 35.2, height], center = true);
                translate([0,0,height])
                cylinder(r = 2.5, h = 19.8);
            }
            screws();
        }
    }
}

module nema11(alfa = false) {
    height = 32;
    module screws() {
        for(i=[0:3]) {
            rotate([0,0,90*i])
            translate([11.55,11.55, height])
            cylinder(r = 1.25, h = 5, center = true); //m2.5 screw
        }
    }
    if(alfa) {
        screws();
    }
    else {
        difference() {
            union() {
                translate([0,0,height / 2])
                cube([28.2, 28.2, height], center = true);
                translate([0,0,height])
                cylinder(r = 2.5, h = 19.8);
            }
            screws();
        }
    }
}

module nema11StandingMount() {
    difference() {
        union() {
            translate([0,0,32 + wallThickness / 2])
            cube([28.2 + wallThickness * 2, 28.2, wallThickness], center = true);
            for(i=[0:1]) {
                mirror([i,0,0]) {
                    translate([28.2 / 2,-28.2 / 2,0])
                    cube([wallThickness, 28.2,32]);
                    translate([28.2 / 2,-28.2 / 2,0])
                    cube([10,28.2,wallThickness]);
                }
            }
        }
        nema11(alfa = true);
        translate([0,0,20])
        cylinder(r = 13, h = wallThickness + 20);
    }
}

module nema11LyingMount(height = 15) {
    difference() {
        union() {
            translate([-15,-28.2/2,32])
            cube([15+height + wallThickness, 28.2, wallThickness], center = false);
            translate([height,-28.2 / 2,0])
            cube([wallThickness, 28.2,32]);
        }
        nema11(alfa = true);
        translate([0,0,20])
        cylinder(r = 13, h = wallThickness + 20);
    }
}

module nema14StandingMount() {
    difference() {
        union() {
            translate([0,0,32 + wallThickness / 2])
            cube([35.2 + wallThickness * 2, 35.2, wallThickness], center = true);
            for(i=[0:1]) {
                mirror([i,0,0]) {
                    translate([35.2 / 2,-35.2 / 2,0])
                    cube([wallThickness, 35.2,32]);
                    translate([35.2 / 2,-35.2 / 2,0])
                    cube([10,35.2,wallThickness]);
                }
            }
        }
        nema11(alfa = true);
        translate([0,0,20])
        cylinder(r = 13, h = wallThickness + 20);
    }
}

module nema14LyingMount(height = 15) {
    difference() {
        union() {
            translate([-15,-35.2/2,32])
            cube([15+height + wallThickness, 35.2, wallThickness], center = false);
            translate([height,-35.2 / 2,0])
            cube([wallThickness, 35.2,32]);
        }
        nema11(alfa = true);
        translate([0,0,20])
        cylinder(r = 13, h = wallThickness + 20);
    }
}

module spring(alfa = false) {
    if(!alfa)
        tube(0.75, 1.5, 10);
    else
        translate([0,0,-0.1])
        cylinder(r = 0.75, h = 10.2);
}