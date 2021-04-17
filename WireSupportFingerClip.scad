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
            elrdcyl(fingerHeight,fingerWidth,29,7);
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
        translate([0, -(thickness + 10), 8.8]) {
            rotate([-90, 0, 0]) {
                elrdcyl(fingerHeight + thickness, fingerWidth + thickness, 19 + thickness, 7 + thickness);
            }
        }
    }
}

union() {
    // Draw all of the parts
    translate([0, 6, 0]) {
        difference() {
            drawClip(2);
            union() {
                drawFinger();
                translate([0, 10, 10]) {
                    cube([20, 20, 20], center=true);
                }
                // Slot
                translate([0, -6, 2]) {
                    cube([1, 13, 8], center=true);
                }
            }
        }
    }

    // The wire clip
    difference() {
        translate([0, 0, 4]) {
            rotate([90, 0, 0]) {
                difference() {
                    cylinder(h=12, r1=9, r2=9, center=true);
                    cylinder(h=12, r1=8, r2=8, center=true);
                }
            }
        }
        union() {
            drawFinger();
            // Gap
            translate([9, 0, 3]) {
                cube([2.2, 13, 2], center=true);
            }
        }
    }
    // Strengthening
    translate([-7.7, 0, 3.5]) {
        cube([2, 12, 1.5], center=true);
    }
}
