/////////////// Paramètres - Parameters
// - Epaisseur bords extérieurs - External border width
External_borders_width=1.3;//[0.4:0.1:5.0]
// - Longeur interne - Internal lengh
Internal_Length=70;
// - Largeur interne - Internal Width
Internal_Width=55;
// - Hauteur interne - Internal Height
Internal_Height=60;
// - Fermeture a vis ou mecanique - Screw closing or mecanical
Closing_Type="Mecanical";// [Screw:Screw closing,Mecanical:Mecanical closing]
// - Largeur de la fixation - Fixation width
Fix_Width=10;//[3:0.1:10]
// - Longeur de la fixation - Fixation length
Fix_Length=10;//[5:0.1:20]
// - Longueur de tete de fixation - Head fixation length
Fix_Head_Length=3;//[2:0.1:5]
// - Longueur de vis - Screw Length
Screw_Length=15;
// - Epaisseur de vis (change aussi les angles de la boite) - Screw Width (this will also change the corners of the box)
Screw_width=3;//[1:0.1:5]
// - Chanfrein - Screw head hole
Screw_head_hole=1;// [0:No, 1:Yes]
// - Hauteur tete vis - Screw head height
Screw_head_height=1;
// - Largeur de tete vis - Screw head width
Screw_head_width=6;//[2:0.1:7]
// - Trous aération - Holes for air ventilation
Holes=1;// [0:No, 1:Yes]
// - Diametre des trous d'aération - Holes size
Holes_size=1;//[1:0.1:5]
// - Nombre de trous d'aeration - Number of holes
Holes_number=25;//[4,9,16,25]
// - Espace entre les trous - Space between holes
Holes_space=2;//[1:0.1:5]
// - Which part do you want to print
part = "both";// [box:Box Only,cover:Cover Only,both:Box and Cover]
/////////////// Paramètres FIN - Parameters END

/* [Hidden] */
// - Epaisseur des bords internes - Internal borders width
Internal_borders_width=1;//[1:0.1:5]
// - Hauteur des cloisons - Internal borders Height
Internal_borders_Height=15;
//Taille intérieure - Internal size
Interieur = [Internal_Length,Internal_Width,Internal_Height];
//Valeur pour supprimer les artefacts - value for removing artefacts
artefact=0.05;
//Space between pieces
Espace_entre_pieces=5;

// rounded rectangle
module roundedRectangle(size = [1, 1, 1], diam = 2, center = true)
{
	translate(center ? [0, 0, 0] : (size/2))
	hull()
	{
		for (x = [-size[0]/2+(diam/2), size[0]/2-diam/2],
			 y = [-size[1]/2+(diam/2), size[1]/2-diam/2])
				translate([x, y, 0])
					cylinder($fs=0.01,d=diam, h = size[2], center = true);
	}
}

//Support des vis - Screw support
module support_vis(size=[1, 1, 1],diam=1,haut=1,bords=1,center=false)
{
    difference() {
        translate(center ? [0, 0, 0] : ([size[0]/2,size[1]/2,0])) //On se mets au centre de la boite
            for (x = [-size[0]/2+diam/2+bords, size[0]/2-diam/2+bords],
                 y = [-size[1]/2+bords+diam/2, size[1]/2+bords-diam/2])
                    translate([x, y, size[2]-haut+bords])
                        hull(){
                            cylinder($fs=0.01,d=diam+2*bords,h=haut,center=false);
                            //fond cylindre pour eviter support
                            posx = x<0 ? -diam/2+Screw_width/4 : diam/2-Screw_width/4;
                            posy = y<0 ? -diam/2+Screw_width/4 : diam/2-Screw_width/4;
                            translate([posx,posy,-3])
                                sphere($fs=0.01,d=Screw_width/4);
                        }
        Screw_hole(size,diam,haut,bords);
    }
}

//Trou des vis - Screw holes
module Screw_hole(size=[1, 1, 1],diam_vis=1,haut_vis=1,bords=1,center=false)
{
    translate(center ? [0, 0, 0] : ([size[0]/2,size[1]/2,0])) //On se mets au centre de la boite
        for (x = [-size[0]/2+diam_vis/2+bords, size[0]/2-diam_vis/2+bords],
             y = [-size[1]/2+bords+diam_vis/2, size[1]/2+bords-diam_vis/2])
                translate([x, y, size[2]-haut_vis+bords]) {
                    translate([0,0,-artefact]) //Suppression des artefacts
                        cylinder($fs=0.01,d=diam_vis,h=(haut_vis+2*artefact),center=false);
                }
 }

//Chanfrein des vis - Screw head holes
 module chanfrein(size=[1,1,1],diam_vis=1,diam_tete=1,haut_tete=1,bords=1,center=false)
 {
    translate(center ? [0, 0, 0] : ([size[0]/2,size[1]/2,0])) //On se mets au centre de la boite
        for (x = [-size[0]/2+diam_vis/2+bords, size[0]/2-diam_vis/2+bords],
             y = [-size[1]/2+bords+diam_vis/2, size[1]/2+bords-diam_vis/2])
                translate([x, y, size[2]])
                    translate([0,0,artefact])
                        if(diam_tete>(diam_vis+2*bords)){ //On chanfreine pas au max si la tete est trop large
                            cylinder($fs=0.01,d1=diam_vis,d2=diam_vis+bords,h=haut_tete,center=false);
                        } else {
                            cylinder($fs=0.01,d1=diam_vis,d2=diam_tete,h=haut_tete,center=false);
                        }
 }
 
 //Trous pour l'aération - Ventilation holes
 module trous_aeration(size=[1,1,1],diam=1,nombre=9,espace=2,haut=1,center=false)
 {
     translate(center ? [0, 0, 0] : ([size[0]/2,size[1]/2,0]))
        for (x=[-((((sqrt(nombre)-1)*espace)+sqrt(nombre)*diam)/2):espace+diam:((((sqrt(nombre)-1)*espace)+sqrt(nombre)*diam)/2)],
             y=[-((((sqrt(nombre)-1)*espace)+sqrt(nombre)*diam)/2):espace+diam:((((sqrt(nombre)-1)*espace)+sqrt(nombre)*diam)/2)]) {
             translate([x,y,-artefact]) {
                 cylinder($fs=0.01,d=diam,h=haut,center=false);
             }
        }
 }
 
 //Pates de fixation
 module fixation(size=[1, 1, 1],largeur=1,hauteur=1,tete=1,epaisseur=1,arrondi=2,center=false)
 {
    translate(center ? [0, 0, 0] : ([size[0]/2,size[1]/2,0])) //On se mets au centre de la boite
        for (x = [-size[0]/2+arrondi/2+epaisseur, size[0]/2-largeur-arrondi/2-epaisseur],
             y = [-size[1]/2+epaisseur, size[1]/2-2*epaisseur]) {
            posy = y<0 ? epaisseur/2 : epaisseur*-1/2;
            translate([x, y, epaisseur]) {
                union(){
                    cube([largeur,epaisseur,hauteur],center=false);
                    translate([0,-2*posy,hauteur-tete])
                    polyhedron
                        (points=[[0,0,0],[largeur,0,0],[0,epaisseur,0],[largeur,epaisseur,0],
                                     [0,epaisseur/2+posy,tete],[largeur,epaisseur/2+posy,tete]],
                         faces =[[0,1,2],[1,2,3],[0,1,4],[1,5,4],[2,3,4],[3,4,5],[0,2,4],[1,3,5]]
                        );
                }
            }
        }
 }
 
 //Trous pour les pates de fixation
 module trou_fixation(size=[1, 1, 1],largeur=1,hauteur=1,tete=1,epaisseur=1,arrondi=2,center=false)
 {
     translate(center ? [0, 0, 0] : ([size[0]/2,size[1]/2,0])) //On se mets au centre de la boite
        for (x = [-size[0]/2+arrondi/2+epaisseur, size[0]/2-largeur-arrondi/2-epaisseur],
             y = [-size[1]/2+epaisseur, size[1]/2-2*epaisseur]) {
             posy = y<0 ? epaisseur : epaisseur*-1+2*artefact;
             translate([x, y-posy, size[2]-hauteur])
                 cube([largeur,epaisseur+2*artefact,tete],center=false);
        }
 }
 
//Boitier - Box
module box()
{
    union() {
        difference() {
            roundedRectangle(Interieur+[2*External_borders_width,2*External_borders_width,External_borders_width],Screw_width,center=false);
            translate([External_borders_width,External_borders_width,External_borders_width])
                roundedRectangle(Interieur+[0,0,artefact],Screw_width,center=false);
            if(Holes)
                trous_aeration([Interieur[0]+2*External_borders_width,Interieur[1]+2*External_borders_width,External_borders_width],Holes_size,Holes_number,Holes_space,External_borders_width+2*artefact);
            if(Closing_Type!="Screw")
                trou_fixation(Interieur+[2*External_borders_width,2*External_borders_width,External_borders_width],Fix_Width,Fix_Length,Fix_Head_Length,External_borders_width,Screw_width);
        }
        if(Closing_Type=="Screw")
            support_vis(Interieur,Screw_width,Screw_Length,External_borders_width);
        //translate([0,0,20]) //A supprimer
         //   trou_fixation(Interieur+[2*External_borders_width,2*External_borders_width,External_borders_width],Fix_Width,Fix_Length,Fix_Head_Length,External_borders_width,Screw_width); //A supprimer
    }
}

//Couvercle - Box top
module couvercle()
{
    if(Closing_Type=="Screw") {
        difference() {
            roundedRectangle([Interieur[0]+2*External_borders_width,Interieur[1]+2*External_borders_width,External_borders_width+Screw_head_height],Screw_width,center=false);
            if(Holes)
                trous_aeration([Interieur[0]+2*External_borders_width,Interieur[1]+2*External_borders_width,External_borders_width+Screw_head_height],Holes_size,Holes_number,Holes_space,External_borders_width+Screw_head_height+2*artefact);
            Screw_hole([Interieur[0],Interieur[1],External_borders_width],Screw_width,2*External_borders_width+Screw_head_height,External_borders_width);
            if(Screw_head_hole)
                chanfrein([Interieur[0],Interieur[1],External_borders_width],Screw_width,Screw_head_width,Screw_head_height,External_borders_width);
        }
    } else {
        union(){
            difference(){
            roundedRectangle([Interieur[0]+2*External_borders_width,Interieur[1]+2*External_borders_width,External_borders_width],Screw_width,center=false);
            if(Holes)
                trous_aeration([Interieur[0]+2*External_borders_width,Interieur[1]+2*External_borders_width,External_borders_width],Holes_size,Holes_number,Holes_space,External_borders_width+2*artefact);
            }
            fixation([Interieur[0]+2*External_borders_width,Interieur[1]+2*External_borders_width,External_borders_width],Fix_Width,Fix_Length,Fix_Head_Length,External_borders_width,Screw_width);
        }
    }
}

//Select which part to print
if(part=="box") {
    box(); //Dessin Boite
} else if(part=="cover") {
    couvercle(); //Dessin Couvercle
} else {
    box(); //Dessin Boite
    translate([-Espace_entre_pieces,0,0])  //on met un espace entre les pieces
        translate([-Interieur[0]-2*External_borders_width,0,0])  //on se deplace de la taille de la boite
            couvercle(); //Dessin Couvercle
}