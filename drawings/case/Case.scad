vertical_hole=173;
horizontal_hole=167.0;
mounting_hole_diameter=3.4;
frame_hole_diameter=20;
panel_diameter=192;
x_y_frame_offset=frame_hole_diameter/2/sqrt(2);
$fn=30;
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

MountingHoleTest();
