// geometry resolution
lod = 64; // medium: 64, high: 128

// the wheel
outer_diameter = 25;
inner_diameter = 14;
height = 6.2;

// the spokes in the middle of the wheel
spoke_height = 1;
spoke_count = 48;

// the grips on the outside of the wheel
grip_divet_size = 1.6;
grip_count = 20;

// the divets on the inside of the wheel (scrolling)
inside_grip_divet_size = 2.1;
inside_grip_count = 24;

// the pin
pin_min_diameter = 1.95;
pin_max_diameter = pin_min_diameter+0.75;

// the pin's hole in the wheel
pin_sheath_width_bottom = pin_min_diameter+2;
pin_sheath_width_top = pin_max_diameter+0.5;
pin_clearance = 0.075; // increased fitting tolerance

// the pin's connection to the mouse
pin_taper_height = 0.75; // the space on each side of the wheel before touching the mouse
pin_hole_height = 0.75; // how far the pin extends into the mouse's hole
pin_height = height+(pin_hole_height*2)+(pin_taper_height*2);

difference() {
  // wheel
  cylinder(h=height,d=outer_diameter,$fn=lod*4);
  
  // hollow wheel
  translate([0, 0, spoke_height]) {
    cylinder(h=height,d=inner_diameter,$fn=lod*2);
  }
  
  // negative spoke
  for (a=[0:360/spoke_count:359]) {
    rotate([0,0,a+(360/spoke_count*0.5)]) {
      translate([2.5,0,0.5]) {
        scale([1,1,16]) {
          rotate([90,45,90]) {
            cylinder(h=4.2,r1=0.1,r2=0.333,$fn=4);
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
          cylinder(h=height*1.1,d=1,$fn=lod*0.5);
        }
      }
    }
  }

  // inside grip (indent)
  for (a=[0:360/inside_grip_count:360]) {
    rotate([0,0,a+(360/24*0.5)]) {
      translate([inner_diameter*0.5-0.25,0,spoke_height]) {
        rotate([0,0,-95]){
          rotate_extrude(190,$fn=lod) {
            square([0.5,height-spoke_height+0.001]);
          }
        }
      }
    }
  }
  
  // outside grip rounded top
  translate([0,0,height-1]){
    rotate_extrude(360,0,100,$fn=lod*4) {
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
    rotate_extrude(360,0,100,$fn=lod*4) {
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
  
  // pin-to-wheel connection
  #cylinder(h=height,d1=pin_sheath_width_bottom+pin_clearance,d2=pin_sheath_width_top+pin_clearance,$fn=lod);
}

// inside grip (outdent)
for (a=[0:360/inside_grip_count:360]) {
  rotate([0,0,a]) {
    translate([inner_diameter*0.5+0.26,0,0]) {
      rotate([0,0,90]){
        rotate_extrude(190,$fn=lod) {
          square([0.55,height]);
        }
      }
    }
  }
}

// pin sheath inside wheel
difference() {
  // pin sheath
  union() {
    cylinder(h=height,d1=pin_sheath_width_bottom+pin_clearance,d2=pin_sheath_width_top+pin_clearance,$fn=lod);
    
    *translate([0,0,height-pin_hole_height]) {
      cylinder(h=pin_hole_height*2,d1=pin_sheath_diameter,d2=pin_min_diameter,$fn=lod);
    }
  }
  
  // pin hollow
  *translate([0,0,-0.0001]) {
    cylinder(h=pin_height+0.0001,d=pin_min_diameter+pin_clearance,$fn=lod);
  }
  
  // pin-to-wheel connection
  cylinder(h=height,d2=pin_min_diameter+pin_clearance,d1=pin_max_diameter+pin_clearance,$fn=lod);
  
  // pin sheath latch
  for (a=[0]) { // add "90" for a cross latch
    rotate([0,0,a]) {
      translate([-2.5,-0.125,spoke_height]) {
        cube([5,0.25,height]);
      }
    }
  }
}

// pin outside wheel
translate([18,0,0]) {
  // pin
  difference() {
    cylinder(h=pin_height,d=pin_min_diameter,$fn=lod);
  
    // rounded pin end (top)
    *translate([0,0,pin_height-pin_min_diameter*0.5]) {
      difference() {
      translate([0,0,pin_min_diameter*0.5]) {
          cube(pin_min_diameter,center=true);
        }
        sphere(pin_min_diameter*0.5,$fn=lod);
      }
    }
    
    // rounded pin end (bottom)
    *translate([0,0,0]) {
      difference() {
        cube(pin_min_diameter,center=true);
        translate([0,0,pin_min_diameter*0.5]) {
          sphere(pin_min_diameter*0.5,$fn=lod);
        }
      }
    }
  }
  
  // pin taper (top)
  translate([0,0,pin_height-pin_hole_height-pin_taper_height]) {
      cylinder(h=pin_taper_height,d2=pin_min_diameter,d1=pin_max_diameter,$fn=lod);
  }
  
  // pin taper (bottom)
  translate([0,0,pin_hole_height]) {
      cylinder(h=pin_taper_height,d1=pin_min_diameter,d2=pin_max_diameter,$fn=lod);
  }
  
  // pin-to-wheel connection
  translate([0,0,pin_hole_height+pin_taper_height]) {
    cylinder(h=height,d1=pin_diameter,d2=pin_max_diameter,$fn=lod);
  }
}