//
// simple carriage for a linear motion
// using recirculating balls as a bearing
//
// original by Johann C. Rocholl
// https://github.com/jcrocholl/recirculating
//
// redone for 6mm balls (airsoft ABS balls)
// and adjusted for printing on PP3DP UP! 2 (Afinia Up!) with ABS+ plastic
// by Adam Lukomski (2016)
// 

use <aluminium_2020.scad>;

length = 60;
thickness = 11;
channel_radius = 3.5; // 3.6 is quite loose for the balls (sic!)
track_radius = 6;
outside_radius = channel_radius + track_radius + 1.5;
slot = 2.5;

inner_quality = 8; // original 6
angle_quality = 36; // original 24



plate_outside_radius = 13;
plate_separation = 4+29;
plate_spacing = 25+9;


// only slightly modified
module track(h) {
  union() {
    translate([0, outside_radius-length/2, 0]) intersection() {
      rotate_extrude($fn=angle_quality) translate([track_radius, 0, 0])
        circle(r=channel_radius, $fn=inner_quality);
      translate([0, -20, 0]) cube([40, 40, 40], center=true);
    }
    translate([0, length/2-outside_radius, 0]) intersection() {
      rotate_extrude($fn=angle_quality) translate([track_radius, 0, 0])
        circle(r=channel_radius, $fn=inner_quality);
      translate([0, 20, 0]) cube([40, 40, 40], center=true);
    }
    for (s = [-1, 1]) {
      scale([s, 1, 1])
        translate([track_radius, 0, 0]) rotate([90, 0, 0]) {
          cylinder(r=channel_radius,
                   h=length-2*outside_radius+0.1,
                   center=true, $fn=inner_quality);
      }
    }
  }
}

module half() {
  difference() {
    translate([0, 0, slot/2-thickness+1.3-5])
    linear_extrude(height=30, convexity=2) {
      difference() {
        translate([-0.5, 0, 0]) minkowski() {
          square([0.1, 0.1+length-2*outside_radius], center=true);
          circle(r=outside_radius-0.05, $fn=36);
        }
        // screw holes
        for (y = [2+outside_radius-length/2,
                  length/2-outside_radius-2]) {
          translate([0, y])
            circle(r=1.5, $fn=12);
        }
      }
    }
    track();
    
//    // FIRST OPTION:
//    // cut the top into a flat shape
//    translate([-10.5, 0, 12.5])
//      cube([100, 100, 20], center=true);
    
//    // SECOND OPTION:
    // cut the top into a mount-like shape
    translate([-10.5, 0, 12.5]) difference() {
      cube([100, 100, 20], center=true);
      difference() {
        translate([0, 0, -10.5]) rotate([90, 0, 0]) rotate([0, 90, 0])
          cylinder(r=15, h=30, center=true, $fn=8);
        translate([-18, 0, 0]) rotate([0, 30, 0])
          cube([40, 40, 40], center=true);
      }
    }
    // screw and nut for the mount-like shape
    translate([0, 0, 13]) rotate([0, -90, 0]) {
      rotate([0, 0, 0]) cylinder(r=3.2, h=50, $fn=6); // hex nut
////       rotate([0, 0, 90]) nut_m3(); // just checking
      cylinder(r=1.7, h=50, center=true, $fn=12); // screw
    }
    
    
    // cut lower part of aluminium profile
    translate([10+track_radius, 0, -10-slot/2])
      cube([20, length, 20], center=true);
    translate([10+track_radius, 0, 10+slot/2])
      cube([20, length, 20], center=true);
  }
}


module plate() {
    h = 6;
    
  difference() {
    linear_extrude(height=h) difference() {
    minkowski() {
      square([0.1+plate_separation, 0.1+plate_spacing], center=true);
      circle(r=plate_outside_radius-0.05, $fn=36);
    }
    for (x = [-plate_separation/2, plate_separation/2]) {
      for (y = [-plate_spacing/2, plate_spacing/2]) {
        translate([x, y])
          circle(r=1.5, $fn=12);
      }
    }
    
    } //diff
    
    // holes
    for (y = [-16/2, 16/2]) {
      for (x = [-21/2, 21/2]) {
        translate([x, y, -1])
          cylinder(r=1.5,h=10, $fn=12);
      }
    } //for
    
    // hex nuts
    for (y = [-16/2, 16/2]) {
      for (x = [-21/2, 21/2]) {
          translate([x, y, 2])
        cylinder(r=3.3, h=15, $fn=6); // with 3.2 hole I had to hammer the nuts into them
      }
    } //for
  } //diff
} //module


translate([-33/2,0,-13.5]) {
    translate( [0,0,-(slot/2-thickness+1.3-5)] ) {
        // the ball:
        translate( [outside_radius/2+0.3,0,0] ) sphere(r=3,$fn=36);
        // first half:
        half(1.5);
        // second half:
        translate([33,0,0]) rotate( [0,0,180] ) half(1.5);
    }
    // bottom plate:
    translate([33/2, 0, -6]) plate();
}
// and the aluminium profile:
rotate([90,0,0]) translate( [0,0,-15] ) profile2020(30);
