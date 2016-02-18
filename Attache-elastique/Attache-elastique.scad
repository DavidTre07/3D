Largeur=10;
Longueur=20;
Epaisseur=5;
Hauteur=4;
Ouverture=3;

Artefact=0.05;

difference() {
    //Contour exterieur
    hull() {
        cylinder($fs=0.01,h=Hauteur,d=Largeur,center=false);
        translate([Longueur-2*Epaisseur,0,0])
            cylinder($fs=0.01,h=Hauteur,d=Largeur,center=false);
     }
    //Intérieur
    hull() {
        translate([0,0,-Artefact])
            cylinder($fs=0.01,h=Hauteur+2*Artefact,d=Largeur-Epaisseur,center=false);
        translate([0,0,-Artefact]) translate([Longueur-2*Epaisseur,0,0])
            cylinder($fs=0.01,h=Hauteur+2*Artefact,d=Largeur-Epaisseur,center=false);
    }
    //Ouverture
    translate([(Largeur-Ouverture)/2,0,0])
        translate([0,0,-Artefact]) cube([Ouverture,Epaisseur,Hauteur+2*Artefact]);
}
