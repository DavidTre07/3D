/***************************************************************************
// RepRapDiscount LCD box with mount for Kossel Mini
// Licence: CC BY-SA 3.0, http://creativecommons.org/licenses/by-sa/3.0/
// Author: Dominik Scholz <schlotzz@schlotzz.com> and contributors
// visit: http://www.schlotzz.com

// Updated by DavidTre07 (https://github.com/DavidTre07)
// Added a fixation on top
***************************************************************************/

// - Taille des montants - Size of extrusion
Extrusion_Size=25; //[15:1:25]

/* [Hidden] */
// - Epaisseur de la fixation - Fixation thickness
Fixation_Thickness=3;
// - Largeur de la fixation - Fixation Width
Fixation_Width=15; //Should be =< Extrusion_Size

// avoid openscad artefacts in preview
epsilon = 0.05;

// Increase this if your slicer or printer make holes too tight.
extra_radius = 0.1;

// Major diameter of metric 3mm thread.
m3_major = 2.85;
m3_radius = m3_major / 2 + extra_radius;
m3_wide_radius = m3_major / 2 + extra_radius + 0.2;


//Fixation
module fixation()
{
    difference() {
        hull() {
            cube([Fixation_Width,Extrusion_Size/2,Fixation_Thickness],center=false); //Fixation en bas (angle droit)
            translate([Fixation_Width/2,Extrusion_Size/2,0]) {
                cylinder($fs=0.01,h=Fixation_Thickness,d=Fixation_Width,center=false);
            }
            rotate([19,0,0]) { //Fixation en haut (continuité face avant)
                translate([0,0,0])
                    cube([Fixation_Width,Extrusion_Size/2,Fixation_Thickness],center=false);
                translate([Fixation_Width/2,Extrusion_Size/2,0])
                    cylinder($fs=0.01,h=Fixation_Thickness,d=Fixation_Width,center=false);
            }
        }
        translate([Fixation_Width/2,Extrusion_Size/2,-epsilon]) { //Trou
            cylinder($fs=0.01,h=20,d=3.5,center=false); //Trou normal
            translate([0,0,Fixation_Thickness])
                cylinder($fs=0.01,h=20,d=7,center=false); //Trou pour tete vis
        }
    }
}

// rounded rectangle
module roundedRectangle(size = [1, 1, 1], r = 1, center = false, $fn = 16)
{
	translate(center ? [0, 0, 0] : (size / 2))
	hull()
	{
		for (x = [-size[0] / 2 + r, size[0] / 2 - r])
			for (y = [-size[1] / 2 + r, size[1] / 2 - r])
				translate([x, y, 0])
					cylinder(r = r, h = size[2], center = true);
	}
}


// mainboard
module panel_mainboard()
{
	size = [150, 55, 1.75];
	hole_offsets= [
		[2.5, 2.5, 0],
		[size[0] - 2.5, 2.5, 0],
		[2.5, size[1] - 2.5, 0],
		[size[0] - 2.5, size[1] - 2.5, 0]
	];

	speaker_radius = 11.75 / 2;
	speaker_height = 9.5;
	speaker_offset = [136.25, 44, 0];

	encoder_size = [12.25, 12.25, 4.5];
	encoder_radius = 7 / 2;
	encoder_height = 24.5;
	encoder_offset = [138, 25.25, 0];

	stop_size = [6, 6, 4.25];
	stop_offset = [136.5, 8, 0];


	// board
	color("white")
	difference()
	{
		cube(size);

		for (a = hole_offsets)
			translate(a - [0, 0, epsilon])
				cylinder(r = m3_wide_radius, h = size[2] + 2 * epsilon);
	}

	// piezo speaker
	color("grey")
	translate(speaker_offset + [0, 0, size[2]])
		cylinder(r = speaker_radius, h = speaker_height, $fn = 32);

	// rotary encoder
	color("grey")
	translate(encoder_offset + [0, 0, size[2] + encoder_size[2] / 2])
		cube(encoder_size, center = true);
	color("lightgrey")
	translate(encoder_offset + [0, 0, size[2]])
		cylinder(r = encoder_radius, h = encoder_height, $fn = 32);

	// emergency stop button
	color("grey")
	translate(stop_offset + [0, 0, size[2] + stop_size[2] / 2])
		cube(stop_size, center = true);

	// lcd board
	translate([14, -8, size[2] + 4.25])
	panel_lcdboard();

	// sd card slot
	translate([0, 8.5, -2.75])
	panel_sdcard();
}


// lcd board
module panel_lcdboard()
{
	size = [98, 60, 1.5];
	
	lcd_size = [97.5, 40, 9.5];
	lcd_offset = [0, 10, 0];

	// board
	color("green")
	cube(size);

	// lcd module
	color("black")
	translate(lcd_offset + [0, 0, size[2]])
		cube(lcd_size);

	color([.1, .2, 1, 0.7])
	translate(lcd_offset + [10, 6, size[2] + epsilon])
		cube(lcd_size - [20, 12, 0]);
}


// sd card slot
module panel_sdcard()
{
	size = [25.75, 26.75, 2.75];
	
	card_size = [32, 24, 2.25];
	card_offset = [-10.5, 1.375, 0.25];

	// slot
	color("lightgrey")
	cube(size);

	// sd card
	color("blue")
	translate(card_offset)
		cube(card_size);
}


// stop button
module panel_button(r = 4, delta = 4)
{
	cylinder(r = r + 1, h = 1, $fn = 32);
	translate([0, 0, 1])
		cylinder(r = r - 0.35, h = 7.5, $fn = 32);
	translate([0, 0, 8.5])
		cylinder(r1 = r - 0.35, r2 = r - 1, h = .5, $fn = 32);

	for (a = [[-r - delta, 0, 0], [r + delta, 0, 0]])
		translate(a)
			difference()
			{
				cylinder(r = 2.5, h = 1, $fn = 16);
				cylinder(r = 1.5, h = 10, $fn = 16, center = true);
			}
	
	translate([0, 0, 0.5])
		cube([1.5, 2 * (r + 2), 1], center = true);

	translate([-r - delta, -r / 2 - 2, 0.5])
		cube([1.5, r, 1], center = true);

	translate([r + delta, r / 2 + 2, 0.5])
		cube([1.5, r, 1], center = true);

	translate([-0.75, r + 1.5, 0])
		cube([2 * r + 1.5, 1.5, 1]);

	translate([-0.75 - 2 * r, -r - 3, 0])
		cube([2 * r + 1.5, 1.5, 1]);
	
}

// lcd box
module panel_lcd_box()
{
	inner_size = [150, 73, 20];
	padding = [1, 3, 0];
	borders = [3, 3, 3]; // was [2, 2, 2]
	border_radius = 3;

	lcd_offset = [13.5, 9.5, 0];
	lcd_size = [98.5, 41, 30];

	speaker_radius = .75;
	speaker_offset = [138, 51.75, 0];
	speaker_delta = [
		[-3, 0, 0],
		[ 0, 0, 0],
		[ 3, 0, 0]
	];

	encoder_radius = 7 / 2 + 1;
	encoder_offset = [138, 33.25, 0];

	stop_radius = 4;
	stop_offset = [138, 16.25, 0];

	mounting_offsets = [
		[2.5, 2.5, 0],
		[147.5, 2.5, 0],
		[2.5, 52.5, 0],
		[147.5, 52.5, 0]
	];

	// display panel
	%translate([0, 8, 7])
		panel_mainboard();

	difference()
	{

        translate(-borders - padding - [0, 0, 25])
        roundedRectangle(inner_size + 2 * padding + 2 * borders + [0, 0, 25], r = border_radius, center = false);
		// inner space
		translate(-padding - [0, 0, 25 + epsilon])
			roundedRectangle(inner_size + 2 * padding + [0, 0, 25], r = border_radius, center = false);

		// lcd hole
		translate(lcd_offset)
			cube(lcd_size);

		// speaker holes
		for (a = speaker_delta)
			translate(speaker_offset + a)
				cylinder(r = speaker_radius, h = 30, $fn = 16);

		// encoder hole
		translate(encoder_offset)
			cylinder(r = encoder_radius, h = 30, $fn = 16);

		// stop hole
		translate(stop_offset + [0, 0, inner_size[2] - 2 * epsilon])
			cylinder(r = stop_radius, h = borders[2] + 4 * epsilon, $fn = 32);
		translate(stop_offset + [0, 0, inner_size[2] + borders[2] - 2 - 2 * epsilon])
			cylinder(r1 = stop_radius, r2 = stop_radius + 1.5, h = 2 + 4 * epsilon, $fn = 32);

		// sd card
		translate([-10, 17.25, 4]) // was 1
			difference()
			{
				cube([30, 25.25, 3.25]);
				for (a = [0, 5, 10, 15, 20, 25])
				translate([0, a - 2.25, 0])
					cube([20, .5, 6]);
			}
	}

	// mounting cylinders
	for (a = mounting_offsets)
		translate(a + [0, 8, 8.75]) // was 6.75
			difference()
			{
				cylinder(r = 3.75, h = 11.25, $fn = 16); // was 13.25
				translate([0, 0, -epsilon])
					cylinder(r = m3_radius, h = 10, $fn = 16);
			}

	// stop button
	translate(stop_offset + [0, 0, 14.5]) // was 12.5
		difference()
		{
			union()
			{
				cylinder(r = stop_radius + 1.5, h = 5.5, $fn = 32); // was 7.5
				translate([-stop_radius - 4.2, 0, 0])
					cylinder(r = 2.5, h = 5.5, $fn = 32);
				translate([stop_radius + 4.2, 0, 0])
					cylinder(r = 2.5, h = 5.5, $fn = 32);
			}
			translate([0, 0, -epsilon])
				cylinder(r = stop_radius, h = 5.5 + 2 * epsilon, $fn = 32);
			translate([-stop_radius - 4, 0, -epsilon])
				cylinder(r = .75, h = 5.5, $fn = 32);
			translate([stop_radius + 4, 0, -epsilon])
				cylinder(r = .75, h = 5.5, $fn = 32);


		}

	%color("red")
	translate(stop_offset + [0, 0, 13.5])
		panel_button();
}


// kossel mounted box
module kossel_lcd_box()
{

	size = [158, 3, 43.75];
	holes = [
		[20, 0, 7.5],
		[20, 0, size[2] - 7.5],
		[size[0] - 20, 0, 7.5],
		[size[0] - 20, 0, size[2] - 7.5],
	];
	radius = 71;

	//Adding the fixation
    translate([0,size[1],43.5-Fixation_Thickness/2])
        fixation();
    translate([size[0]-15,size[1],43.5-Fixation_Thickness/2])
        fixation();
    difference()
	{
		union()
		{
			cube(size);
		
			translate([4, -60, -1])
				rotate([19, 0, 0])
					panel_lcd_box();
		}

		// cut off top
		translate([-10, -10, 45])
			cube([size[0] + 20, 20, 20]);

		// cut off bottom
		translate([-50, -200, -200 + epsilon])
			cube([300, 300, 200]);

		// cut off back
		translate([-10, 3, 0])
			cube([180, 50, 50]);

		// hole for data cables
		translate([30, -epsilon, 0])
			cube([size[0] - 60, 10, size[2] - 15]);

		// mounting holes				
		for (a = holes)
			translate(a)
				rotate([90, 0, 0])
					cylinder(r = m3_wide_radius, h = 10, center = true, $fn = 16);
	}
}

rotate([180-19, 0, 0])
	kossel_lcd_box();
//panel_lcd_box();

//panel_button();
