//Global Variables
$fn=255;
diam_ext_tube=27.3;
epaisseur_tube=2;
diam_ext=55;
epaisseur=1;
longueur=20;
delta=0.01;

module bouchon() {
    //Variables
    diam_int_max=diam_ext_tube-epaisseur_tube*1.9;
    diam_int_min=(diam_ext_tube-epaisseur_tube*2)*0.9;
    difference(){
        union(){
            //Lèvre intérieure
            translate([0,0,longueur/4]) cylinder(h=longueur*3/4,d1=diam_int_max,d2=diam_int_min);
            difference(){
                //Extérieur
                cylinder(h=longueur/2,d=diam_ext);
                //On créé une rainure
                translate([0,0,longueur/4+delta]) cylinder(h=longueur/4,d=diam_ext_tube+epaisseur_tube/4);
            }
        }
        //On vide l'intérieur
        translate([0,0,-delta])cylinder(h=longueur+delta*2,d=diam_int_min-epaisseur*2);
        //On fait un plat de chaque côté
        translate([diam_ext-diam_ext/12,0,0])cube([diam_ext,diam_ext,longueur+delta],center=true);
        translate([-diam_ext+diam_ext/12,0,0])cube([diam_ext,diam_ext,longueur+delta],center=true);
    }
}

translate([0,0,0]) rotate([0,0,0])
    bouchon();