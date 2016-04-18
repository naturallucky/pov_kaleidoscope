#include "colors.inc"
#include "textures.inc"
#include "glass.inc"
#include "metals.inc"
#include "golds.inc"
#include "stones.inc"
#include "woods.inc"
#include "shapes.inc"
#include "shapes2.inc"
#include "functions.inc"
#include "math.inc"
#include "transforms.inc"

#version 3.7;

plane { y, -1
	pigment {color rgb <.7,.7,1> }
}

plane { y, 100
	pigment {color rgb <.9,.7,.3> }
}

global_settings { max_trace_level 7 }

#declare mirror =
/*union{
object{ // Wire_Box(A, B, WireRadius, UseMerge)
        Wire_Box(<-1.2,2,.1> <1.2,-.1,0>, 0.10   , 0)  
       
         texture{ DMFDarkOak
                normal { wood 0.5 scale 0.3 turbulence 0.1}
                finish { phong 1 } 
                rotate<60,0,45> scale 0.25
              } // end of texture 

               
        scale<1,1,1>  rotate<0, 0,0> translate<0,0.1,0>
      } // --------------------------------------------- 
*/
box{<-1,6,.1> <1,0,0>
	finish{reflection 1}
}


//}
;

#declare bai = 6;
#declare hen = 6*sqrt(3)/2-.3;

camera {
	//location <0, 40, -hen*.8>
	location <0, 21+sin(-.6+clock*2*3.14)*16, -hen*1.2>
	look_at <0, 4, -hen>
	angle 90
	rotate <0,cos(clock*2*3.14)*15,0>
}

light_source { <-0, 50, -hen> color rgb 1.6 }


object{mirror
	scale bai
	}
object{mirror
	scale bai
	rotate y*120
	translate <bai/2,0-.2,-hen>
	}
object{mirror
	scale bai
	rotate y*-120
	translate <-bai/2,0+.24,-hen>
	}

#declare Sd=seed(777);


#ifndef (MANGEKYO)
	#declare MANGEKYO=1;
	#declare MNum = 8*4;
	#declare Num = MNum;
	#declare Prm = array[Num][9];
	#declare Num = Num - 1;

	#while ( Num >= 0)
		#declare Prm[Num][0] = rand(Sd)*bai*2-bai;
		#declare Prm[Num][1] = -rand(Sd)*hen*2;
		#declare Prm[Num][7] = rand(Sd)*bai*6*.3+1;
		
		#declare Prm[Num][2] = rand(Sd)*.92 +.08;
		#declare Prm[Num][3] = rand(Sd)*.92 +.08;
		#declare Prm[Num][4] = rand(Sd)*.92 +.08;
		#if (Prm[Num][2]+Prm[Num][3]+Prm[Num][4] > 2.1 & rand(Sd) > .7)
			#declare id =2+int(rand(Sd)*3.0001);
			#declare Prm[Num][id] = Prm[Num][id] *.05; 
			#declare id =mod(id-2+int(rand(Sd)*1.999),3)+2;
			#declare Prm[Num][id] = rand(Sd)*.08+.092 ; 
		#end
		
		#declare Prm[Num][5] = (rand(Sd)*2-1)*bai*2.4;
		#declare Prm[Num][6] = (rand(Sd)*2-1)*bai*2.8;
		#declare Prm[Num][8] = int(rand(Sd)*4);
		#declare Num = Num - 1;
	#end
	
#end

#declare Num = MNum;
#declare Num = Num - 1;



#while ( Num >= 0)
	#if (clock <.5)
		#declare tx = Prm[Num][0]+Prm[Num][5]*clock;
		#declare tz = Prm[Num][1]+Prm[Num][6]*clock;
	#else
		#declare tx = Prm[Num][0]-Prm[Num][5]*(clock-1);
		#declare tz = Prm[Num][1]-Prm[Num][6]*(clock-1);
	#end
	sphere{<tx,Prm[Num][7],tz> , 1
		#switch (Prm[Num][8])
			#case (0)
				pigment {color rgb <Prm[Num][2],Prm[Num][3],Prm[Num][4]>}
				finish{diffuse 0.95}
				finish{reflection .9}
			#break
			#case (1)
				texture{
					pigment {color Clear}
					finish { F_Glass1 }
				}
				interior {I_Glass1 fade_color color rgb <Prm[Num][2],Prm[Num][3],Prm[Num][4]>}
			#break
			#default
				pigment {color rgb <Prm[Num][2],Prm[Num][3],Prm[Num][4]>}
			#break
		#end
	}

	#declare Num = Num - 1;
	#if (Num < MNum/2)
		#declare tx = Prm[Num][0]+Prm[Num][5]*cos(clock*2*3.14);
		#declare tz = Prm[Num][1]+Prm[Num][6]*sin(clock*2*3.14);;
	#else
		#if (clock <.5)
			#declare tx = Prm[Num][0]+Prm[Num][5]*clock;
			#declare tz = Prm[Num][1]+Prm[Num][6]*clock;
		#else
			#declare tx = Prm[Num][0]-Prm[Num][5]*(clock-1);
			#declare tz = Prm[Num][1]-Prm[Num][6]*(clock-1);
		#end
	#end
	cylinder{<tx,Prm[Num][7]-1,tz> <tx,Prm[Num][7]+1,tz>, 1
//		pigment {color rgb <Prm[Num][2],Prm[Num][3],Prm[Num][4]>}
				texture{
					pigment {color Clear}
					finish { F_Glass2 }
				}
				interior {I_Glass2 fade_color color rgb <Prm[Num][2],Prm[Num][3],Prm[Num][4]>}
		#if (mod(int(Num/4),3) = 0)
			rotate <0,0,90>
		#else
			#if (mod(int(Num/4),3) = 1)
				rotate <90,0,0>
			#end
		#end 
	}

	#declare Num = Num - 1;
	#if (clock <.5)
		#declare tx = Prm[Num][0]+Prm[Num][5]*clock;
		#declare tz = Prm[Num][1]+Prm[Num][6]*clock;
	#else
		#declare tx = Prm[Num][0]-Prm[Num][5]*(clock-1);
		#declare tz = Prm[Num][1]-Prm[Num][6]*(clock-1);
	#end
	superellipsoid{ <0.25,0.25> 
     //texture{ pigment {color rgb <Prm[Num][2],Prm[Num][3],Prm[Num][4]>}
     //              finish { phong 1 }
     //       } // end of texture
	texture{
		pigment {color Clear}
		finish { F_Glass3 }
	}
	interior {I_Glass3 fade_color color rgb <Prm[Num][2],Prm[Num][3],Prm[Num][4]>}
     scale <1,1,1> 
     rotate<0,0,0> 
     translate<tx,Prm[Num][7],tz>
   } // -------------- end superellipsoid


	#declare Num = Num - 1;
	#if (clock <.5)
		#declare tx = Prm[Num][0]+Prm[Num][5]*clock;
		#declare tz = Prm[Num][1]+Prm[Num][6]*clock;
	#else
		#declare tx = Prm[Num][0]-Prm[Num][5]*(clock-1);
		#declare tz = Prm[Num][1]-Prm[Num][6]*(clock-1);
	#end
	object{ Dodecahedron  
        scale <1,1,1>
				texture{
					pigment {color Clear}//rgbf <Prm[Num][2],Prm[Num][3],Prm[Num][4],.2>}
					finish { F_Glass4 }
				}
				interior {I_Glass4 fade_color color rgb <Prm[Num][2],Prm[Num][3],Prm[Num][4]>}
/*        texture { pigment {color rgb <Prm[Num][2],Prm[Num][3],Prm[Num][4]>}
                  normal { crackle 1.75 scale 0.25 turbulence 0.2 }
                  finish { phong 0.3 reflection{ 0.35 metallic 0.5 } }
                }
 */        scale <1,1,1>*1  rotate<0,0,0> translate<tx,Prm[Num][7],tz>
       } // end of object

	#declare Num = Num - 1;
#end

/*
box{<-bai,0,0><bai,0.1,-hen*2>
	pigment {color rgb <1,1,1>}
}*/
