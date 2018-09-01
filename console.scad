$fn = 16;
wallThickness = 2;

base(wallThickness);

module logo() {
    linear_extrude(1)
    scale(40)
    translate([-0.25,0.5,0])
    rotate([0,0,-90])
    polygon([[0.0857,0], [0.4285,0], [0.6571,0.2571], [0.8285,0.0857], [1,0.0857], [0.6571,0.4285], [0.3428,0.0857], [0.0857,0.0857]]);
    linear_extrude(1.5)
    scale(40)
    translate([-0.25,0.5,0])
    rotate([0,0,-90])
    polygon([[0.0857,0], [0.3428,0.2571], [0.5714,0], [0.9142,0], [1,0.0857], [0.6571,0.0857], [0.3428,0.4285], [0,0.0857]]);
}

module base(thickness) {
    difference() {
        union() {
            difference() {
                union() {
                    translate([0,0,5+thickness/2])
                    cube([50+thickness*2,60+thickness*2,10+thickness], center = true);
                    translate([-35,5,5+thickness/2])
                    cube([20+thickness*2,50+thickness*2,10+thickness], center = true);
                }
                translate([0,0,5+thickness/2+thickness])
                cube([50,60,10+thickness], center = true);
                translate([-35+0.01-thickness/2,5,5+thickness/2+thickness])
                cube([20+thickness,50,10+thickness], center = true);
            }
            difference() {
                translate([-35-thickness,5,15])
                cube([20+thickness*2,50+thickness*2,30], center = true);
                
                translate([-34.99+thickness/2-thickness,5,15])
                cube([20+thickness,50,31], center = true);
                
                translate([-35+0.01-thickness/2,25+thickness*2,28-8])
                cube([9,thickness*10,3.5], center = true);
            }
        }
        
        translate([0,0,-5]) {
            //RFID PINS
            translate([20-1.3-1.2,30-1.3-14,0])
            cylinder(r = 1.3, h = 20);
            mirror([1,0,0])
            translate([20-1.3-1.2,30-1.3-14,0])
            cylinder(r = 1.3, h = 20);

            translate([20-1.3-6,-30+1.3+6,0])
            cylinder(r = 1.3, h = 20);
            mirror([1,0,0])
            translate([20-1.3-6,-30+1.3+6,0])
            cylinder(r = 1.3, h = 20);
        }
    }

    difference() {
        translate([0,0,0.1]) {
            difference() {
                translate([0,0,10+thickness/2+thickness])
                cube([50+thickness*2,60+thickness*2,thickness], center = true);
                translate([-26-0.01,5,11.01+thickness/2])
                cube([thickness+0.01,50.02+thickness*2,thickness*2], center = true);
            }
            translate([-35-thickness,5,30+thickness/2])
            cube([20+thickness*2,50+thickness*2,thickness], center = true);
            
            translate([-26+0.01+thickness,5,21+thickness/2])
            cube([thickness,50+thickness*2,18+thickness], center = true);
            
            translate([-46,5,28.5])
            cube([thickness,15,4], center = true);
            
            color([0,0.5,0])
            translate([4,0,13.9])
            logo();
        }
        translate([0,0,-5]) {
            //RFID PINS
            translate([20-1.3-1.2,30-1.3-14,0])
            cylinder(r = 1.3, h = 20);
            mirror([1,0,0])
            translate([20-1.3-1.2,30-1.3-14,0])
            cylinder(r = 1.3, h = 20);

            translate([20-1.3-6,-30+1.3+6,0])
            cylinder(r = 1.3, h = 20);
            mirror([1,0,0])
            translate([20-1.3-6,-30+1.3+6,0])
            cylinder(r = 1.3, h = 20);
        }
    }
}
module tube(innerRadius, outerRadius, height) {
    difference() {
        cylinder(r = outerRadius, h = height);
        translate([0,0,-1]) cylinder(r = innerRadius, h = height + 2);
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