include <../case/Case.scad>;
use<usb_power.scad>;

button_distance=80;
mounting_hole_diameter=3.4;
frame_hole_diameter=20;
x_y_frame_offset=frame_hole_diameter/2/sqrt(2);
$fn=30;

mount_width=30;
battery_length = 68;
battery_diameter = 19;

module medium_button(locking=true){
	hole_diameter=24.4;
	tab_distance=37.7;
	tab_diameter=3.5;
	if (locking == true){
		translate([tab_distance/2, 0]) circle(d=tab_diameter);
		translate([-tab_distance/2, 0]) circle(d=tab_diameter);
	}
	circle(d=hole_diameter);
	// circle(d=3.2);
	%circle(d=60.8);
}

module large_button(locking=true){
	diameter=87.8;
	nub_radius=4;
	if(locking == true){
		circle(d=diameter);
		translate([diameter/2,0]) circle(r=nub_radius);
		translate([-diameter/2,0]) circle(r=nub_radius);
	} else {
		circle(d=24.4);
	}
	%circle(d=98.5);
}

module button_group(locking = true){
	large_button(locking);
	translate([button_distance, 0])  medium_button(locking);
	translate([-button_distance, 0]) medium_button(locking);
	translate([0,button_distance])   medium_button(locking);
	translate([0,-button_distance])  medium_button(locking);
}

module blue_fruit(){
	height=39.37;
	width=22.86;
	hole_height=35.56;
	hole_width=19.05;
	rotate(90) difference(){
		%square([width, height], center=true);
		union(){
			translate([hole_width/2, hole_height/2]) circle(d=2.2);
			translate([hole_width/2, -hole_height/2]) circle(d=2.2);
			translate([-hole_width/2, hole_height/2]) circle(d=2.2);
			translate([-hole_width/2, -hole_height/2]) circle(d=2.2);
		}
	}
}

module battery_holder_leg(){
	rotate([90,0,90]) linear_extrude(panel_width, center=true){
		difference(){
			union(){
				square([mount_width, mount_width], center=true);
				translate([0, -mount_width/2 - panel_width/2]) square([10, panel_width], center=true);
			}
			square([5, 24], center=true);
		}
	}
}

module battery_holder(){
	translate([0, 0, panel_width + mount_width/2]){
		difference(){
			union(){
				translate([-battery_length/3, 0 ,0]) battery_holder_leg();
				translate([battery_length/3, 0 ,0]) battery_holder_leg();
			}
		#rotate([0,90,0]) cylinder(battery_length,d=battery_diameter, center=true);
		}
	}
}

module tie_holes(){
	translate([-4, -6]) circle(d=3.2);
	translate([-4, 6]) circle(d=3.2);
	translate([4, -6]) circle(d=3.2);
	translate([4, 6]) circle(d=3.2);

}

module electronics_panel(){
	panel_edge = (panel_diameter+ 2*x_y_frame_offset - panel_width)/2;
	difference(){
	  LedPanel();
		button_group(false);
		CornerPanelBrackets();
	  SideSlots();
	  translate([-panel_edge, -panel_edge + 1.5*frame_hole_diameter - panel_width/2]) usb_power(true, true);
		projection(cut=true) translate([0, mount_width]) battery_holder();
		translate([0, -mount_width]) blue_fruit();
		translate([50, 50]) tie_holes();
		translate([50, -50]) tie_holes();
		translate([-50, 50]) tie_holes();
		translate([-50, -50]) tie_holes();
	}

}

module top_panel(){
	difference(){
	  CoverFrame();
		button_group(true);
		%CornerPanelBrackets();
	  SideSlots();
	}
}

%top_panel();
electronics_panel();
translate([-panel_diameter/2, -panel_diameter/2 -60]) usb_power(true, false);
translate([35, 0]) for(i=[0:3]){translate([-panel_diameter/2 + i*37, -panel_diameter/2 -60]) usb_power(false, false);}

projection(cut=true) translate([-panel_diameter/2, -panel_diameter/2 -90, battery_length/3]) rotate([0,90,0]) battery_holder();
projection(cut=true) translate([-panel_diameter/2 + 40, -panel_diameter/2 -90, battery_length/3]) rotate([0,90,0]) battery_holder();

