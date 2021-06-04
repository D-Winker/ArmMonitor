// Pulse Oximeter finger-clip
// V9

// Units are mm

module prism(l, w, h){
   polyhedron(
           points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
           );
}

// _______ Finger _______
// elliptic cylinder with rounded top
module elrdcyl(
   w, // width of finger
   d, // thickness of finger
   h1,// straight height of cylinder
   h2 // height of rounded top
   ) {
   intersection(){
     union(){
       scale([w/2,d/2,1])cylinder(r=1,h=h1,$fn=36);  // cylinder
       translate([0,0,h1])scale([w/2,d/2,h2])sphere(r=1,$fn=36);  // top
     }
     scale([w/2,d/2,1])cylinder(r=1,h=h1+h2,$fn=36); // only needed if h2>h1 
   }
}

fingerHeight = 17.8;
fingerWidth = 13.8;
module drawFinger() {
    translate([0, -(26-9), 8.8]) {
        rotate([-90, 0, 0]) {
            elrdcyl(fingerHeight,fingerWidth,19,7);
        }
    }
    translate([0, -(28-9), 8.8]) {
        rotate([-90, 0, 0]) {
            elrdcyl(fingerHeight,fingerWidth,5,0);
        }
    }
}

// _______ Finger Clip _______
module drawClip(thickness) {
    // Cylindrical part
    difference () {
        translate([0, -(thickness + 26-9), 8.8]) {
            rotate([-90, 0, 0]) {
                elrdcyl(fingerHeight + thickness, fingerWidth + thickness, 19 + thickness, 7 + thickness);
            }
        }
        // Slits, for flexibility
        /*
        translate([0, -10, 8.3]) {
            cube([30, 30, 0.5], center=true);
        }
        translate([0, -20, fingerHeight]) {
            cube([0.5, 30, 15], center=true);
        }
        */
    }
    // Over the pulse oximeter part
    translate([0, 6, 3]) {
        cube([16, 16, 16], center=true);
    }
    // Make the bottom flat and add a bit to help hold the pulseox
    translate([0, 0, 2]) {
        cube([16, 26, 6], center=true);
    }
}

// _______ The Pulse Oximeter _______
module drawPulseOximeter() {
    color( c = [1.0, 0, 0, 0.75] ) {
        length = 27;
        width = 14;
        thickness = 1.8;
        // PCB
        cube([width, length, thickness], center=true);
        // Components
        // Sensor
        translate([0, 0, thickness]) {
            cube([3.2, 25+5.5, thickness], center=true);
        }
        translate([0, 0, 3]) {  // To make the sensor taller
            cube([3.2, 25+5.5, thickness], center=true);
        }
        // Connectors
        translate([0, 0, -(1.5/2+3/2)]) {
            translate([12/2 - 5/2, 0, 0]) {
                cube([5.2, 7, 3], center=true);
            }
            translate([-12/2 + 5/2, 0, 0]) {
                cube([5.2, 7, 3], center=true);
            }
        }
        // Top
        translate([0, 0, thickness/2+1.2/2]) {
            // Parts on top, notch where there aren't any
            difference() {
                cube([width, length, 1.2], center=true);
                translate([width/2-6/2, length/2-6/2, 0.1]){
                    cube([6, 6, 1.1], center=true);
                }
                /* Empty space on board near back
                translate([-width/2+9.5/2, -length/2+6.5/2]){
                    cube([9.5, 6.5, 1.2], center=true);
                }*/
            }
            // Chamfer the notch
            translate([0, length/2-5, -0.4]) {
                prism(width/2, -1, 1);
            }
        }
        // Bottom
        translate([0, 0, -1.5/2-1.2/2]) {
            difference() {
                cube([width, length, 1.2], center=true);
                translate([-width/2+8.5/2, length/2-3/2]){
                    cube([8.5, 3, 1.2], center=true);
                }
                translate([-width/2+2/2, length/2-8.5/2]){
                    cube([2, 8.5, 1.2], center=true);
                }
            }
        }
        // Wires
        translate([0, -length/2+3/2, -thickness/2 - 10/2]){
            cube([width, 3, 10], center=true);
        }
        translate([width/2 - 2.5/2, -length/2+8.5/2, -thickness/2 - 10/2]){
            cube([2.5, 8.5, 10], center=true);
        }
    }
}

// Draw all of the parts
//drawPulseOximeter();

difference() {
    drawClip(2);
    union() {
        drawFinger();
        translate([0, 0, 2]) {
            rotate([20, 0, 0]) { 
                drawPulseOximeter();
                // Clear out wasted material, make the package smaller
                translate([0, 0, -13]) {
                    cube([20, 50, 15], center=true);
                }
            }
            // Clear out wasted material, make the package smaller
            translate([0, 0, -7]) {
                cube([20, 50, 5], center=true);
            }
        }
        // Add holes for cooling (hopefully)
        rad = 1.5;
        translate([0, 0, 8.8]) {
            for ( i = [0 : 6] ){
                rotate(i * 60, [0, 1, 0]) {
                    for (j = [0 : 3] ){
                        translate([0, -6*j, 0]) {
                            cylinder(h=50, r=rad, center=true, $fn=10);
                        }
                    }
                    rotate(30, [0, 1, 0]) {
                        translate([0, 3, 0]) {
                            for (j = [0 : 2] ){
                                translate([0, -6*j, 0]) {
                                    cylinder(h=50, r=rad, center=true, $fn=10);
                                }
                            }
                        }
                    }
                }
            }
        }
        // Too long for my pointer, cut off the back part
        translate([0, -30, 0]) {
            cube([30, 30, 50], center=true);
        }
    }
}
