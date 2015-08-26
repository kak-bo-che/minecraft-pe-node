$fn=20;
vertical_hole=172.5;
horizontal_hole=165.0;
mounting_hole_diameter=3.5;
frame_hole_diameter=20;
panel_diameter=192;
x_y_frame_offset=frame_hole_diameter/2/sqrt(2);

case_length=192 + 2*x_y_frame_offset + frame_hole_diameter;
case_width=case_length;

min_height=40;
panel_thickness=2.78; //3.1, 1.55, 5.7 ?

corner_pieces = floor(min_height/panel_thickness);
case_height=corner_pieces*panel_thickness;
corner_radius=10;
length_slots=7;
width_slots=7;
hole_size=3.2;
part_separation=10;
include <../sturdy_box/sturdy_box.scad>

module CoverPanelHoles(hole_diameter){
	translate([panel_diameter/2 + x_y_frame_offset, panel_diameter/2 + x_y_frame_offset]) circle(d=hole_diameter);
	translate([panel_diameter/2 + x_y_frame_offset, -panel_diameter/2 - x_y_frame_offset]) circle(d=hole_diameter);

	translate([-panel_diameter/2 - x_y_frame_offset, -panel_diameter/2 - x_y_frame_offset]) circle(d=hole_diameter);
	translate([-panel_diameter/2 - x_y_frame_offset, panel_diameter/2 + x_y_frame_offset]) circle(d=hole_diameter);
}
module LedPanel(){
	square([panel_diameter, panel_diameter], center=true);
}
module LedPanelHoles(){
	translate([horizontal_hole/2, vertical_hole/2]) circle(d=mounting_hole_diameter);
	translate([0, vertical_hole/2]) circle(d=mounting_hole_diameter);
	translate([horizontal_hole/2, -vertical_hole/2]) circle(d=mounting_hole_diameter);

	translate([-horizontal_hole/2, vertical_hole/2]) circle(d=mounting_hole_diameter);
	translate([0, -vertical_hole/2]) circle(d=mounting_hole_diameter);
	translate([-horizontal_hole/2, -vertical_hole/2]) circle(d=mounting_hole_diameter);

	// Odd holes
	translate([vertical_hole/2, 0]) circle(d=mounting_hole_diameter);
	translate([-vertical_hole/2, 0]) circle(d=mounting_hole_diameter);

	// Nubs
	translate([-(panel_diameter/2 - 8), panel_diameter/2 - 18]) circle(d=mounting_hole_diameter);
	translate([(panel_diameter/2 - 8), -(panel_diameter/2 - 18)]) circle(d=mounting_hole_diameter);
}

module RibbonConnector(){
	square([10,30], center=true);
}
module LedPanelConnectors(){
	x_offset=142/2;
	y_offset=45;
	translate([x_offset, y_offset]) RibbonConnector();
	translate([-x_offset, y_offset]) RibbonConnector();

	translate([22, -25]) square([20,15]);
}
module RaspberryPi2MountingHoles(){
	rp_hole=2.75;
	translate([3.5, 3.5]) circle(d=rp_hole);
	translate([3.5, 52.5]) circle(d=rp_hole);
	translate([61.5, 3.5]) circle(d=rp_hole);
	translate([61.5, 52.5]) circle(d=rp_hole);
}

raspberrypi_length=85;
raspberrypi_width=56;
module RaspberryPi2(){
	rp_radius=3;
	difference(){
//		square([85, 56]);
		%hull(){
			translate([rp_radius, rp_radius]) circle(r=rp_radius);
			translate([rp_radius, 56 - rp_radius]) circle(r=rp_radius);
			translate([85 - rp_radius, rp_radius]) circle(r=rp_radius);
			translate([85 - rp_radius, 56 - rp_radius]) circle(r=rp_radius);
		}
		RaspberryPi2MountingHoles();
	}
}

module pi_side(){
  usb_height=16;
  usb_width=16;

  ethernet_width=16.3;
  ethernet_height=14.3;
  first_usb_center=56-47;
  second_usb_center=56-29;
  ethernet_center=56-10.25;
  %square([raspberrypi_width, usb_height]);
  translate([first_usb_center, usb_height/2]) square([usb_width, usb_height], center=true);
  translate([second_usb_center, usb_height/2]) square([usb_width, usb_height], center=true);
  translate([ethernet_center, ethernet_height/2]) square([ethernet_width, ethernet_height], center=true);

}
//70x140x20
anker_battery_width=67;
anker_battery_length=137;
anker_battery_height=20;
module anker_battery(){
	square([anker_battery_length, anker_battery_width]);
}

module CoverFrame(){
	difference(){
		hull(){
			CoverPanelHoles(frame_hole_diameter);
		}
		CoverPanelHoles(mounting_hole_diameter);
		LedPanel();

	}
}

module BackFrame(){
	difference(){
		hull(){
			CoverPanelHoles(frame_hole_diameter);
		}
		CoverPanelHoles(mounting_hole_diameter);
		LedPanelHoles();
		LedPanelConnectors();
		translate([11,20]) RaspberryPi2MountingHoles();
	}
}

module Back(){
	difference(){
		hull(){
			CoverPanelHoles(frame_hole_diameter);
		}
		CoverPanelHoles(mounting_hole_diameter);
	}
}

vertical_distance_to_holes=(vertical_hole/2 - anker_battery_width)/2;
//	width=anker_battery_width+4*vertical_distance_to_holes;
offset_to_battery = (case_width - vertical_hole)/2 + vertical_distance_to_holes;
offset_to_start_of_holder=panel_thickness/2 + corner_radius;
battery_holder_base_width=anker_battery_width + 2*(offset_to_battery - offset_to_start_of_holder);

//	offset_to_vert_start_of_holder=(case_width - vertical_hole)/2 - vertical_distance_to_holes;
offset_to_vert_start_of_holder=offset_to_start_of_holder;

module battery_holder_base(){
	echo(vertical_distance_to_holes);
	difference(){
		translate([offset_to_start_of_holder, offset_to_vert_start_of_holder]){
			square([anker_battery_length -13, battery_holder_base_width ]);
		}
		translate([anker_battery_length/3, offset_to_battery -15]) square([panel_thickness, 15]);
		translate([2*anker_battery_length/3, offset_to_battery -15]) square([panel_thickness, 15]);
		translate([anker_battery_length/3, offset_to_battery + anker_battery_width]) square([panel_thickness, 15]);
		translate([2*anker_battery_length/3, offset_to_battery + anker_battery_width]) square([panel_thickness, 15]);

		%translate([0, offset_to_battery]) anker_battery();
		translate([corner_radius, corner_radius]) circle(r=corner_radius);
		translate([case_length/2, case_width/2]){
			LedPanelHoles();
			LedPanelConnectors();
		}
	}
}
module battery_holder(){
	difference(){
		union(){
			translate([panel_thickness, offset_to_start_of_holder]) square([case_height-panel_thickness, battery_holder_base_width]);
			translate([0, offset_to_battery -15]) square([panel_thickness, 15]);
			translate([0, offset_to_battery + anker_battery_width]) square([panel_thickness, 15]);
		}
		translate([0, offset_to_battery]) square([20, anker_battery_width]);
	}
}

// module battery_holder_base(){
// 	vertical_distance_to_holes=(vertical_hole/2 - anker_battery_width)/2;
// 	width=anker_battery_width+4*vertical_distance_to_holes;
// 	offset_to_start_of_holder=panel_thickness+x_y_frame_offset;
// 	offset_to_first_hole=(case_length - horizontal_hole)/2;
// 	translate([horizontal_hole/2, vertical_hole/2]) circle(d=mounting_hole_diameter);
// 	difference(){
// 		translate([offset_to_start_of_holder, 0]) square([anker_battery_length, width ]);
// 		#translate([0, (width - anker_battery_width)/2]) anker_battery();
// 		translate([offset_to_first_hole, vertical_distance_to_holes])	circle(d=hole_size);
// 		translate([offset_to_first_hole, 2*vertical_distance_to_holes + anker_battery_width])	circle(d=hole_size);

// 	}
// }

module MountingHoleTest(){
	difference(){
		LedPanel();
		CoverPanelHoles(mounting_hole_diameter);
		LedPanelHoles();
		LedPanelConnectors();
	}
}
module battery_side(){
	difference(){
		translate([case_height, 0]) rotate(90) length_side();
		translate([panel_thickness, (battery_holder_base_width - anker_battery_width)/2 -corner_radius/3 ]) square([20, anker_battery_width]);
		translate([case_height/2, case_length/2 + 10]) circle(d=7.8);
	}
}

translate([case_length + 44, 1.5*corner_radius]) rotate(90) length_side(){
		translate([(case_length - 3*corner_radius)/2 + raspberrypi_width +20, case_height - 6 ])  rotate(180) pi_side();
}
// translate([-50, 1.5*corner_radius]) battery_side();
// base(){
// 	translate([case_length/2, case_length/2]){
// 			LedPanelHoles();
// 			LedPanelConnectors();
// 			//translate([11,20])
// 			translate([case_length/2 - (raspberrypi_length + corner_radius + panel_thickness/2), 20]) RaspberryPi2();
// 			%translate([-case_length/2 , -(anker_battery_width  +vertical_hole/2)/2]) anker_battery();
// 		}
// }
translate([-140, 0]) battery_holder_base();
//translate([-200, 0]) battery_holder();
//translate([0, -50]) length_side();
//translate([0, -100]) length_side();

//translate([case_length/2 , case_length/2]) BackFrame();
