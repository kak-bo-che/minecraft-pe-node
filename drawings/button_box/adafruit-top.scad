button_distance=80;
module medium_button(){
	hole_diameter=24.4;
	tab_distance=37.7;
	
	circle(d=hole_diameter);
	translate([tab_distance/2, 0]) circle(d=3.3);
	translate([-tab_distance/2, 0]) circle(d=3.3);
	%circle(d=60.8);
}
module large_button(){
	diameter=87.8;
	circle(d=diameter);
	translate([diameter/2,0]) circle(r=3);
	translate([-diameter/2,0]) circle(r=3);
	%circle(d=98.5);
}
difference(){
	square([222, 295], center=true);
	large_button();
	translate([button_distance, 0]) medium_button();
	translate([-button_distance, 0]) medium_button();
	translate([0,button_distance]) medium_button();
	translate([0,-button_distance]) medium_button();
}