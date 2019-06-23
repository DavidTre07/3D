base_diameter=39;
base_height=6;
base_large=24;
bar_shift=16;
bar_height=35;
bar_tickness=1.5;
bar_border=8;
bar_center=7;
bar_tickness2=6;
tube_height=20;
tube_tickeness=2;
tube_large=2;

$fn=100;

//Base
linear_extrude(height=base_height) {
    difference(){
        circle(d=base_diameter);
        translate([base_diameter/2+base_large/2,0,0])square(base_diameter,center=true);
        translate([-base_diameter/2-base_large/2,0,0])square(base_diameter,center=true);
    }
}

//Bar
linear_extrude(height=bar_height) {
    translate([0,-base_diameter/2+bar_shift,0]){
        difference(){
            square([base_large,bar_tickness2],center=true);
            translate([base_large/2-(bar_border-bar_tickness)/2,bar_tickness/2,0])
                square([bar_border,bar_tickness2-bar_tickness],center=true);
            translate([-base_large/2+(bar_border-bar_tickness)/2,bar_tickness/2,0])
                square([bar_border,bar_tickness2-bar_tickness],center=true);
            translate([0,-bar_tickness,0])
                square([bar_center,bar_tickness2],center=true);
        }
    }
}

//Tubes
translate([0,-base_diameter/2+bar_shift-tube_tickeness*1.5,0]){
    linear_extrude(height=tube_height) {
        translate([bar_center/2+tube_large/2,0,0])
            scale([1,tube_tickeness/tube_large,1])circle(d=tube_large);
        translate([-bar_center/2-tube_large/2,0,0])
            scale([1,tube_tickeness/tube_large,1])circle(d=tube_large);
    }
    translate([0,0,tube_height]){
        translate([-bar_center/2-tube_large/2,0,0])
            sphere(d=tube_large);
        translate([bar_center/2+tube_large/2,0,0])
            sphere(d=tube_large);
    }
}
