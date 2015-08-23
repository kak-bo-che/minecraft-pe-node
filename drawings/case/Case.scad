vertical_hole=173;
horizontal_hole=167.0;
panel_diameter=192;
panel_width=3;
mounting_hole_diameter=3.4;
frame_hole_diameter=20;
x_y_frame_offset=frame_hole_diameter/2/sqrt(2);
mounting_slot_length=16;
$fn=30;

module MountingSlot(){
	square([mounting_slot_length, 3], center=true);
}
module SideSlotsHalf(){
	offset_to_outside_slot_center = panel_diameter/2 + x_y_frame_offset - 1.5*frame_hole_diameter;
	center_offset= offset_to_outside_slot_center/4;
	translate([offset_to_outside_slot_center, 0]) MountingSlot();
	translate([1.5*center_offset,0,0]) MountingSlot();
}
module SideSlot(){
	SideSlotsHalf();
	mirror([1,0,0]) SideSlotsHalf();
}

module SideSlots(){
	translate([panel_diameter/2 + x_y_frame_offset, 0]) rotate(90) SideSlot();
	translate([-(panel_diameter/2 + x_y_frame_offset), 0]) rotate(90) SideSlot();
	translate([0, panel_diameter/2 + x_y_frame_offset]) SideSlot();
	translate([0, -(	panel_diameter/2 + x_y_frame_offset)]) rotate(180) SideSlot();
}

module SidePanel(){
	inside_box_height=66;
	offset_to_outside_slot_center = panel_diameter/2 + x_y_frame_offset - 1.5*frame_hole_diameter;
	square([2*(offset_to_outside_slot_center)+mounting_slot_length, inside_box_height], center=true);
	translate([0, (inside_box_height+panel_width)/2]) SideSlot();
	translate([0, -(inside_box_height+panel_width)/2 + 0.001]) SideSlot();
}

module sub_mini_slide_switch(center=false){
	length=23.3;
	width=7.5;
	hole_separation=19;
	hole_size=2.1;

	difference(){
		%square([23.3, 7.5]);
		union(){
			translate([(length - 9)/2, (width -4)/2]) square([9,4]);
			translate([(length - hole_separation)/2, width/2]){
				circle(d=hole_size);
				translate([hole_separation, 0]) circle(d=hole_size);
			}
		}
	}
}

module UsbSidePanel(){
	usb_connector_width=10;
	inside_box_height=66;
	//hole_width = usb_connector_width;
	hole_width = 18;
	hole_height = 10;
	hole_height_old = 15;
	hole_y_offset_old = inside_box_height/2 - 18 - hole_height_old;
	hole_y_offset = inside_box_height/2 - 21 - hole_height;

	offset_to_outside_slot_center = panel_diameter/2 + x_y_frame_offset - 1.5*frame_hole_diameter;
	distance_to_edge = (2*(offset_to_outside_slot_center)+mounting_slot_length)/2;
	difference(){
		SidePanel();
		// 17 is ?
		half_old_hole_width = (hole_width - usb_connector_width)/2;
		%translate([distance_to_edge - hole_width -17, hole_y_offset_old]) square([18, hole_height_old]);
		translate([distance_to_edge - hole_width -17 + half_old_hole_width, hole_y_offset]) square([usb_connector_width, hole_height]);
		switch_length=23.3;
		translate([distance_to_edge - hole_width + (hole_width - switch_length)/2  -17 , hole_y_offset -20]) sub_mini_slide_switch();
	}
}

module CornerPanelBracket(){
	difference(){
      hull(){
      	translate([frame_hole_diameter, 0]) circle(d=frame_hole_diameter);
				translate([0, frame_hole_diameter]) circle(d=frame_hole_diameter);
				circle(d=frame_hole_diameter);
			}
		//translate([frame_hole_diameter + frame_hole_diameter/2, 0])
		translate([frame_hole_diameter + frame_hole_diameter/2, 0]) MountingSlot();
		translate([0, frame_hole_diameter + frame_hole_diameter/2])  rotate(a=-90) MountingSlot();
		circle(d=mounting_hole_diameter);
		circle(d=5.45, $fn=6);
	}
}

module CornerSpacer(){
		difference(){
			circle(d=frame_hole_diameter);
		//translate([frame_hole_diameter + frame_hole_diameter/2, 0])
			circle(d=mounting_hole_diameter);
		}
}


module CornerPanelBrackets(){
	translate([panel_diameter/2 + x_y_frame_offset, panel_diameter/2 + x_y_frame_offset]) rotate(180) CornerPanelBracket();
	translate([panel_diameter/2 + x_y_frame_offset, -panel_diameter/2 - x_y_frame_offset]) rotate(90) CornerPanelBracket();
	translate([-panel_diameter/2 - x_y_frame_offset, -panel_diameter/2 - x_y_frame_offset]) CornerPanelBracket();
	translate([-panel_diameter/2 - x_y_frame_offset, panel_diameter/2 + x_y_frame_offset]) rotate(-90) CornerPanelBracket();
}

module CoverPanelHoles(hole_diameter){
	translate([panel_diameter/2 + x_y_frame_offset, panel_diameter/2 + x_y_frame_offset]) circle(d=hole_diameter);
	translate([panel_diameter/2 + x_y_frame_offset, -panel_diameter/2 - x_y_frame_offset]) circle(d=hole_diameter);

	translate([-panel_diameter/2 - x_y_frame_offset, -panel_diameter/2 - x_y_frame_offset]) circle(d=hole_diameter);
	translate([-panel_diameter/2 - x_y_frame_offset, panel_diameter/2 + x_y_frame_offset]) circle(d=hole_diameter);
}

module LedPanel(){
	square(panel_diameter+ 2*x_y_frame_offset - panel_width, center=true);
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

module CoverFrame(){
	difference(){
		hull(){
			CoverPanelHoles(frame_hole_diameter);
		}
		CoverPanelHoles(mounting_hole_diameter);
	}
}

module CoverFrameWithoutLED(){
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
	}
}

module MountingHoleTest(){
	difference(){
		LedPanel();
		CoverPanelHoles(mounting_hole_diameter);
		LedPanelHoles();
		LedPanelConnectors();
	}
}
UsbSidePanel();
//CornerPanelBracket();
//CornerSpacer();
//SideSlots();
//MountingHoleTest();
