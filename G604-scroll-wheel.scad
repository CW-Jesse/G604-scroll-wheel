lod = 64;

outer_diameter = 25;
inner_diameter = 14;
height = 6.2;

spoke_height = 1;
spoke_count = 48;

small_pin_diameter = 2;
small_pin_height = 10;
small_pin_clearance = 0.1;
big_pin_diameter = 3;
big_pin_height = height;

grip_divet_size = 1.6;
grip_count = 20;

inside_grip_divet_size = 2.1;
inside_grip_count = 24;

difference() {
  // wheel
  cylinder(h=height,d=outer_diameter,$fn=256);
  
  // hollow wheel
  translate([0, 0, spoke_height]) {
    cylinder(h=height,d=inner_diameter,$fn=lod*2);
  }
  
  // negative spoke
  for (a=[0:360/spoke_count:359]) {
    rotate([0,0,a+(360/spoke_count*0.5)]) {
      translate([2,0,0.5]) {
        scale([1,1,16]) {
          rotate([90,45,90]) {
            cylinder(h=4.7,r1=0.1,r2=0.333,$fn=4);
          }
        }
      }
    }
  }
  
  // outside grip
  for (a=[0:360/grip_count:359]) {
    rotate([0,0,a]) {
      translate([outer_diameter*0.5,0,-0.05]) {
        scale([1,grip_divet_size,1]) {
          cylinder(h=height*1.1,d=1,$fn=32);
        }
      }
    }
  }
  
  // small pin hollow
  translate([0,0,-0.05]) {
    cylinder(h=small_pin_height*1.1,d=small_pin_diameter+small_pin_clearance,$fn=lod);
  }

  // inside grip (wave)
  for (a=[0:360/inside_grip_count:360]) {
    rotate([0,0,a+(360/24*0.5)]) {
      translate([inner_diameter*0.5-0.2,0,spoke_height]) {
        rotate([0,0,-95]){
          rotate_extrude(190,$fn=lod) {
            square([0.55,height-spoke_height+0.001]);
          }
        }
      }
    }
  }
  
  // outside grip rounded top
  translate([0,0,height-1]){
    rotate_extrude(360,0,100,$fn=256) {
      translate([outer_diameter*0.5-1,0,0]) {
        difference() {    
          square(2);
          circle(1,$fn=lod);
        }
      }
    }
  }
  
  // outside grip rounded bottom
  translate([0,0,-1]){
    rotate_extrude(360,0,100,$fn=256) {
      translate([outer_diameter*0.5-1,0,0]) {
        difference() {    
          square(2);
          translate([0,2,0]) {
            circle(1,$fn=lod);
          }
        }
      }
    }
  }
}

// inside grip (wave)
for (a=[0:360/inside_grip_count:360]) {
  rotate([0,0,a]) {
    translate([inner_diameter*0.5+0.2,0,0]) {
      rotate([0,0,90]){
        rotate_extrude(190,$fn=lod) {
          square([0.45,height]);
        }
      }
    }
  }
}

  // small pin
translate([25,0,0]) {
  cylinder(h=small_pin_height,d=small_pin_diameter,center=false,$fn=lod);
}

difference() {
  // big pin (small pin sheath)
  cylinder(h=big_pin_height,d=big_pin_diameter,$fn=lod);
  
  // small pin
  translate([0,0,-0.05]) {
    cylinder(h=small_pin_height*1.1,d=small_pin_diameter+small_pin_clearance,$fn=lod);
  }
}