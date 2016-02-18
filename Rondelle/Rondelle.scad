Diam_exterieur=10;
Diam_interieur=3.5;
Hauteur=5;
Artefact=0.05;

difference() {
    cylinder($fs=0.01,h=Hauteur,d=Diam_exterieur,center=false);
    translate([0,0,-Artefact])
        cylinder($fs=0.01,h=Hauteur+2*Artefact,d=Diam_interieur,center=false);
}