use<../case/Case.scad>;
button_distance=80;
mounting_hole_diameter=3.4;
frame_hole_diameter=20;
x_y_frame_offset=frame_hole_diameter/2/sqrt(2);
$fn=30;
module medium_button(){
	hole_diameter=24.4;
	tab_distance=37.7;
	tab_diameter=3.5;
	
	circle(d=hole_diameter);
	translate([tab_distance/2, 0]) circle(d=tab_diameter);
	translate([-tab_distance/2, 0]) circle(d=tab_diameter);
	%circle(d=60.8);
}
module large_button(){
	diameter=87.8;
	circle(d=diameter);
	translate([diameter/2,0]) circle(r=3);
	translate([-diameter/2,0]) circle(r=3);
	%circle(d=98.5);
}
module button_group(){
	large_button();
	translate([button_distance, 0]) medium_button();
	translate([-button_distance, 0]) medium_button();
	translate([0,button_distance]) medium_button();
	translate([0,-button_distance]) medium_button();
}

difference(){
//	square([222, 295], center=true);
    CoverFrame();
	button_group();
}