tete_diam_ext=15;
tete_diam_int=6;
tete_hauteur=7;

corps_diam_int=3.2;
corps_hauteur=15;
corps_epaisseur=3;

encoche_hauteur=4.0;

epaisseur=1;

artefact=0.05;
module tete() {
    difference() {
        cylinder(h=tete_hauteur,d1=tete_diam_ext,d2=corps_diam_int+2*corps_epaisseur,$fn=100);
        hauteur_interieur=tete_hauteur-epaisseur+artefact;
        translate([0,0,epaisseur+artefact])
            cylinder(h=hauteur_interieur,d=tete_diam_int,$fn=100);
    }
}

module corps(){
    corps_diam_ext=corps_diam_int+2*corps_epaisseur;
    tete_encoche=tete_diam_int;
    corps_encoche=corps_diam_int;
    difference(){
        difference(){ //corps
            cylinder(h=corps_hauteur,d=corps_diam_ext,$fn=100);
            translate([0,0,-artefact])
                cylinder(h=corps_hauteur+2*artefact,d=corps_diam_int,$fn=100);
        }
        translate([corps_encoche,0,corps_hauteur/2+artefact]) //encoche corps vis
            cube([2*corps_encoche,corps_encoche,corps_hauteur+2*artefact],center=true);
        translate([tete_encoche,0,encoche_hauteur/2]) //encoche tete vis
            cube([2*tete_encoche,tete_encoche,encoche_hauteur+2*artefact],center=true);
        translate([0,0,-artefact]) //Trou pour la tete
            cylinder(h=encoche_hauteur+artefact,d=tete_diam_int,$fn=100);
        hull() { //Chanfrein
            translate([0,0,encoche_hauteur/2+2-artefact])
                cylinder(h=2,d1=tete_diam_int,d2=corps_diam_int,$fn=100);
            diam1=2*sqrt((tete_encoche*tete_encoche)/2);
            diam2=2*sqrt((corps_diam_int*corps_diam_int)/2);
            translate([diam2,0,encoche_hauteur/2+2-artefact]) rotate([0,0,45]) 
                cylinder(h=2,d1=diam1,d2=diam2,$fn=4);
        }
    }
}

tete();

translate([0,0,tete_hauteur])
    corps();