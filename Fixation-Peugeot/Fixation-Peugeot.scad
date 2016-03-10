Cercle_ext_diam=12.9;
Cercle_ext_haut=1;
Cercle_int_diam=17;
Cercle_int_haut=2;
Entre_cercle_haut=3.5;
Entre_cercle_diam=4;
Support_fix_haut=4;
Support_fix_diam=7.6;
Fix_haut=12.5;
Fix_diam_bas=11;
Fix_diam_haut=1;
Fix_epaisseur=0.4;
Fix_tete=2.5;
artefact=0.05;

cylinder(h=Cercle_ext_haut,d=Cercle_ext_diam,$fn=100);  //Rondelle bas
translate([0,0,Cercle_ext_haut]) {
    cylinder(h=Entre_cercle_haut,d=Entre_cercle_diam,$fn=100);  //Séparation entre les rondelles
    translate([0,0,Entre_cercle_haut])
        cylinder(h=Cercle_int_haut,d=Cercle_int_diam,$fn=100);  //Rondelle milieu
}

translate([0,0,Cercle_ext_haut+Entre_cercle_haut+Cercle_int_haut]) {
    difference(){
        union(){  //Exterieur fix
            cylinder(h=Support_fix_haut,d1=Support_fix_diam,d2=Fix_diam_bas,$fn=100);  //Fix Bas
            translate([0,0,Support_fix_haut])
                cylinder(h=Fix_haut,d1=Fix_diam_bas,d2=Fix_diam_haut,$fn=100);  //Fix haut
        }
        union(){  //On vide la fix
            cylinder(h=Support_fix_haut,d1=Support_fix_diam-Fix_epaisseur,d2=Fix_diam_bas-Fix_epaisseur,$fn=100);  //interieur Fix Bas
            translate([0,0,Support_fix_haut])
                cylinder(h=Fix_haut-Fix_tete,d1=Fix_diam_bas-Fix_epaisseur,d2=Fix_diam_haut+Fix_epaisseur,$fn=100);  //interieur Fix haut
            translate([0,0,(Support_fix_haut+Fix_haut)/2]) {  //Encoches
                translate([Fix_diam_bas/2+Fix_tete,0,0])
                    cube([Fix_diam_bas,1,Support_fix_haut+Fix_haut],center=true);
                rotate([0,0,45]) translate([Fix_diam_bas/2+Fix_tete,0,0])
                    cube([Fix_diam_bas,1,Support_fix_haut+Fix_haut],center=true);
                translate([0,Fix_diam_bas/2+Fix_tete,0])
                    cube([1,Fix_diam_bas,Support_fix_haut+Fix_haut],center=true);
                rotate([0,0,45]) translate([0,Fix_diam_bas/2+Fix_tete,0])
                    cube([1,Fix_diam_bas,Support_fix_haut+Fix_haut],center=true);
                translate([-Fix_diam_bas/2-Fix_tete,0,0])
                    cube([Fix_diam_bas,1,Support_fix_haut+Fix_haut],center=true);
                rotate([0,0,45]) translate([-Fix_diam_bas/2-Fix_tete,0,0])
                    cube([Fix_diam_bas,1,Support_fix_haut+Fix_haut],center=true);
                translate([0,-Fix_diam_bas/2-Fix_tete,0])
                    cube([1,Fix_diam_bas,Support_fix_haut+Fix_haut],center=true);
                rotate([0,0,45]) translate([0,-Fix_diam_bas/2-Fix_tete,0])
                    cube([1,Fix_diam_bas,Support_fix_haut+Fix_haut],center=true);
            }
        }
    }
}
