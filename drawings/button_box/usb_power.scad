$fn=30;
hole_size=3.2;
usb_power_length=22.3;
usb_power_width=19;

usb_power_width_lip=17;

mounting_offset=8;
holder_length=usb_power_length + mounting_offset;
holder_width=usb_power_width + 2*mounting_offset;

module usb_power_holes(){
  hole_width=6;
  translate([mounting_offset/2, mounting_offset/2]) circle(d=hole_size);
  translate([mounting_offset/2, usb_power_width + 3*mounting_offset/2]) circle(d=hole_size);
  translate([holder_length-mounting_offset/2, mounting_offset/2]) circle(d=hole_size);
  translate([holder_length-mounting_offset/2, usb_power_width + 3*mounting_offset/2]) circle(d=hole_size);
  translate([usb_power_length - hole_width, mounting_offset]) square([hole_width, usb_power_width]);
}

module usb_power_holder(inside=true){

  difference(){
    square([holder_length, holder_width]);
    if(inside == true){
      translate([0, holder_width/2 - usb_power_width/2]) square([usb_power_length,usb_power_width]);
    } else {
      translate([0, holder_width/2 - usb_power_width_lip/2]) square([usb_power_length,usb_power_width_lip]);
    }
  }
}

module usb_power(inside=false, only_holes=false){
  difference(){
    if (only_holes == true){
      % usb_power_holder(inside);
    } else {
      usb_power_holder(inside);
    }
    usb_power_holes();
  }
}
usb_power(true, true);
translate([holder_length + 5, 0]) usb_power(false);