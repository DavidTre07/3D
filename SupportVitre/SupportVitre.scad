/* [Support] */
diam_ext_support=20; // [10:1:30]
epaisseur_sur_vitre=3; // [0:0.1:10]
encoche_percent=0.5; // [0.3:0.1:0.7]
epaisseur_sous_vitre=0; // [0:0.1:10]

/* [Screw] */
vis_diam=4; // [2:0.1:5]
vis_tete_diam=8; // [4:0.1:10]

/* [Glass] */
vitre_diam=200; // [150:1:250]
vitre_haut=3; // [2:0.1:5]

/* [Hidden] */
artefact=0.05;

module support_vitre() {
    position_encoche=diam_ext_support/6;
    difference() {
        union(){
        cylinder(h=epaisseur_sur_vitre+vitre_haut+epaisseur_sous_vitre,d=diam_ext_support,$fn=100); //Piece brute
        translate([0,0,epaisseur_sur_vitre+vitre_haut])
            cylinder(h=epaisseur_sous_vitre,d=diam_ext_support,$fn=100); //Piece dessous
        }
        translate([vitre_diam/2+position_encoche,0,epaisseur_sur_vitre])
            cylinder(h=vitre_haut+artefact,d=vitre_diam,$fn=100); //Trou Vitre

        translate([vitre_diam/2+position_encoche/encoche_percent,0,-artefact])
            cylinder(h=vitre_haut+epaisseur_sur_vitre+2*artefact,d=vitre_diam,$fn=100); //Encoche dessus vitre

        translate([-position_encoche,0,-artefact])
            cylinder(h=epaisseur_sur_vitre+vitre_haut+epaisseur_sous_vitre+2*artefact,d=vis_diam,$fn=100); //Trou vis
        
        translate([-position_encoche,0,-artefact])
            cylinder(h=epaisseur_sur_vitre+artefact,d=vis_tete_diam,$fn=100); //Trou tete vis
        }
}

module glass() {
    translate([0,0,-artefact])
        cylinder(h=vitre_haut+artefact,d=vitre_diam,$fn=100); //Vitre
}

%translate([0,0,10]) rotate([90,0,0]) text("Down view");
%color("LightCyan") translate([0,0,epaisseur_sur_vitre-artefact]) glass();
rotate([0,0,0]) translate([-vitre_diam/2-diam_ext_support/6,0,0]) support_vitre();
%color("gold") rotate([0,0,120]) translate([-vitre_diam/2-diam_ext_support/6,0,0]) support_vitre();
%color("gold") rotate([0,0,240]) translate([-vitre_diam/2-diam_ext_support/6,0,0]) support_vitre();
%translate([0,0,-10]) rotate([-90,0,0]) text("Top view");
