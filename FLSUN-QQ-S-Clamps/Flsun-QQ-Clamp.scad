//#rotate([0,180,0])translate([-47.2,-6.6,0]) import("clamp_QQ.STL");

$fn=255;

module QQ_clamp() {
    //Variables
    clamp_diam=104.2;
    clamp_large=32;
    clamp_thickness=3;
    clamp_height=10;
    lips_length=5;
    lips_tickness=2.5;
    lips_position=46.5;
        linear_extrude(height=clamp_height) {
            //Circle
            difference(){
                circle(d=clamp_diam);
                circle(d=clamp_diam-clamp_thickness*2);
                translate([0,-clamp_large+clamp_thickness/2,0])
                    square([clamp_diam,clamp_diam],center=true);
            }
            //lips left
            //translate([-clamp_diam/2-clamp_thickness/2,clamp_diam/2-clamp_large,0]) {
            translate([-lips_position,clamp_diam/2-clamp_large,0]) {
                translate([lips_length/2,lips_tickness/2,0])square([lips_length,lips_tickness],center=true);
                translate([0,lips_tickness/2,0])circle(d=lips_tickness);
                translate([lips_length,lips_tickness/2,0])circle(d=lips_tickness);
            }
            //lips right
            translate([lips_position,clamp_diam/2-clamp_large,0]) {
                translate([-lips_length/2,lips_tickness/2,0])square([lips_length,lips_tickness],center=true);
                translate([0,lips_tickness/2])circle(d=lips_tickness);
                translate([-lips_length,lips_tickness/2])circle(d=lips_tickness);
            }
        }
}

module glue_holder(){
    glue_large=30;
    glue_tickness=2;
    glue_height=40;
    difference(){
        cylinder(d=glue_large+glue_tickness*2,h=glue_height);
        translate([0,0,-0.1])cylinder(d=glue_large,h=glue_height-glue_tickness);
    }
}

module spatula_holder(){
    spatula_height=5;
    spatula_tickness=3;
    spatula_hole_large=65;
    spatula_hole_tickness=5;
    linear_extrude(height=spatula_height) {
        difference(){
            square([spatula_hole_large+spatula_tickness*2,spatula_hole_tickness+spatula_tickness*2],center=true);
            square([spatula_hole_large,spatula_hole_tickness],center=true);
        }
    }
}

module cable_clamp(){
    c_clamp_height=5;
    c_clamp_diam=13.5;
    c_clamp_tickness=1.5;
    c_clamp_cut=11;
    linear_extrude(height=c_clamp_height) {
        difference(){
            circle(d=c_clamp_diam);
            circle(d=c_clamp_diam-c_clamp_tickness*2);
            translate([-1*c_clamp_cut,0,0]) square([c_clamp_diam,c_clamp_diam],center=true);
        }
        translate([1*c_clamp_diam/2+c_clamp_tickness,0,0])square([3*c_clamp_tickness,c_clamp_tickness*1.6],center=true);
    }
}

translate([0,-21.3,0])
    QQ_clamp();

translate([31.3,38.1,0]) rotate([0,0,0])
    glue_holder();

translate([-18,30.6,0]) rotate([0,0,25])
    spatula_holder();

translate([-55,0,0]) rotate([0,0,0])
    cable_clamp();