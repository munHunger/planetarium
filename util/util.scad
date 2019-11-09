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

module filet(r = 10, h = 1, alfa = false) {
    if(!alfa) {
        intersection() {
            difference() {
                translate([0,0,h/2])
                cube([r*2, r*2, h], center = true);

                translate([0,0,-1])
                cylinder(r = r,h + 2);
            }
            cube([r,r,h]);
        }
    }
    else {
        cube([r,r,h]);
    }
}

module filetSection(innerRadius, outerRadius, height, angle, inner = true) {
    intersection() {
        tube(innerRadius, outerRadius, height);
        pieSlice(outerRadius,0,angle,height);
    }
    size = outerRadius - innerRadius;
    if(inner) {
        rotate([0,0,angle])
        translate([innerRadius,size,0])
        rotate([0,0,-90])
        filet(size, height);
    }
    else {
        rotate([0,0,angle])
        translate([outerRadius,size,0])
        rotate([0,0,180])
        filet(size, height);
    }
}