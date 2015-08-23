$fn=30;
hole_size=3.2;

old_usb_power_length=22.3;
old_usb_power_width=19;

usb_power_length=27;
usb_power_width=17;

usb_power_width_lip=17;

mounting_offset=8;
holder_length=usb_power_length + mounting_offset;


module usb_power_holes(usb_power_length, usb_power_width){
  hole_width=6;
  holder_length=usb_power_length + mounting_offset;
  translate([mounting_offset/2, mounting_offset/2]) circle(d=hole_size);
  translate([mounting_offset/2, usb_power_width + 3*mounting_offset/2]) circle(d=hole_size);
  translate([holder_length-mounting_offset/2, mounting_offset/2]) circle(d=hole_size);
  translate([holder_length-mounting_offset/2, usb_power_width + 3*mounting_offset/2]) circle(d=hole_size);
//  translate([usb_power_length - hole_width, mounting_offset]) square([hole_width, usb_power_width]);
}

module usb_power_holder(){
  holder_width=old_usb_power_width + 2*mounting_offset;
  difference(){
    square([holder_length, holder_width]);
    translate([0, holder_width/2 - usb_power_width_lip/2]) square([usb_power_length,usb_power_width_lip]);
  }
}

module usb_power_holder_top(){
  holder_width=old_usb_power_width + 2*mounting_offset;
  difference(){
    square([holder_length, holder_width]);
    usb_power_holes(old_usb_power_length, old_usb_power_width);
  }
}

module usb_power_holder_bottom(){
  holder_width=old_usb_power_width + 2*mounting_offset;
  offset_to_hole=23;
  difference(){
    square([holder_length, holder_width]);
    usb_power_holes(old_usb_power_length, old_usb_power_width);
    translate([23, holder_width/2 - usb_power_width_lip/2]) square([usb_power_length-offset_to_hole, usb_power_width]);
  }
}

module usb_power(only_holes=false){
  difference(){
    if (only_holes == true){
      % usb_power_holder();
    } else {
      usb_power_holder();
    }
    usb_power_holes(old_usb_power_length, old_usb_power_width);
  }
}
usb_power(false);
translate([holder_length + 5, 0]) usb_power(false);
translate([2*(holder_length + 5), 0]) usb_power_holder_bottom();

translate([3*(holder_length + 5), 0]) usb_power_holder_bottom();