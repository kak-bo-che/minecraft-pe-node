$fn=30;
corner_radius=10;
length_slots=7;
width_slots=7;
panel_thickness=2.9;
hole_size=3.2;

module corner_stack(hex_hole=false){
  hex_hole_size=5.4;
  radius = corner_radius;
  difference() {
    circle(r=radius);
    translate([radius, 0]) square([radius, panel_thickness], center=true);
    rotate(90) translate([radius, 0]) square([radius, panel_thickness], center=true);
    if (hex_hole){
      circle(d=hex_hole_size, $fn=6);
    } else {
      circle(d=hole_size);
    }
  }
}

module corner_no_slit(hex_hole=false){
  hex_hole_size=5.4;
  radius = corner_radius;
  difference() {
    circle(r=radius);
    if (hex_hole){
      circle(d=hex_hole_size, $fn=6);
    } else {
      circle(d=hole_size);
    }
  }
}

corner_no_slit();
translate([2*corner_radius + 3, 0]) corner_stack();