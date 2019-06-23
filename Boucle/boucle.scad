Largeur=20;   //Largeur interieure
Hauteur=20;   //Hauteur interieure
Epaisseur=6;  //Epaisseur de la piece
Angle=6;     //Diametre cercle aux angles

//Pour corriger la visu dans la fenetre preview
epsilon=0.01;
//Pour debug (cube rouge taille demandée, cubes verts pour verif des epaisseurs)
DEBUG=0;

$fn=100;
difference(){
   minkowski(){
      cube([Largeur+Epaisseur,Hauteur+Epaisseur-Angle,Epaisseur-1],center=true);
      cylinder(d=Angle+Epaisseur,h=1,center=true);
   }
   minkowski(){
      cube([Largeur,Hauteur-Angle,Epaisseur-1],center=true);
      cylinder(d=Angle,h=1+epsilon,center=true);
   }
}

if(DEBUG==1){
   color("red")cube([Largeur,Hauteur,Epaisseur],center=true);
   translate([21,0,0])color("green")cube([Epaisseur,Epaisseur,Epaisseur],center=true);
   translate([0,8,0])color("green")cube([Epaisseur,Epaisseur,Epaisseur],center=true);
}