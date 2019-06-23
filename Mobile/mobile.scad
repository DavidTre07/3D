use <arc.scad>

rayon1=90;
rayon2=50;
angle1=100;
angle2=100;
artefact=1.05;
epaisseur=3;
attache_taille=6;
attache_trou=3;

$fn=100;

module attache(){
    translate([0,0,epaisseur/2])difference(){
        cylinder(d=attache_taille,h=epaisseur,center=true);
        cylinder(d=attache_trou,h=(epaisseur+artefact*2),center=true);
    }
}

module mobile(angle=100,rayon=100,poids=50){
    rotate([0,0,angle/(200/poids)]) {
        3D_arc(w=epaisseur,deg=angle,h=epaisseur,r=rayon,fn=$fn);
        rotate([0,0,(angle+attache_trou)/2])translate([0,rayon,0])attache();  //Fix gauche
        rotate([0,0,(angle+attache_trou)/-2])translate([0,rayon,0])attache(); //Fix droite
    }
    translate([0,rayon+(epaisseur+attache_trou)/2,0])attache(); //Fix au dessus
    translate([0,rayon-(epaisseur+attache_trou)/2,0])attache(); //Fix au dessous
}

%translate([0,0,0])mobile(angle=angle1,rayon=rayon1,poids=0);
%translate([0,-30,0])mobile(angle=angle1,rayon=rayon1,poids=30);
translate([55,-25,0])mobile(angle=angle2,rayon=rayon2,poids=0);