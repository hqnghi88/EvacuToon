/**
* Name: AnimatedGIFLoading
* Author: A. Drogoul
* Description:  Shows how to load animated GIF files and use them as textures or display them directly. 
* Tags: Image, Display, File
*/
model AnimatedGIFLoading

global {
	int max<-17;
	list myname<-["daisy","cathy","matina","lyly","millie","melody","catarina","elisabeth","paul","john","marc","helen","raon","peter","tommy","linda","anthony","phillip","rock"];
	init {
		create people number:20;
	}

}

species people skills: [moving] {
	int no<-rnd(max); 
	reflex r {
		do wander amplitude: 2.0 speed: 0.1;
	}

	aspect default {
		draw gif_file("../includes/"+no+".gif") size: {10, 10} rotate: heading + 45;
		draw myname[no] color:#black at:{location.x,location.y+5} rotate: heading + 45;
	}

}

experiment "Ripples and Fishes" type: gui {
	output {
		display Ripples synchronized: true  { //camera_pos: {50.00000000000001,140.93835147797245,90.93835147797242} camera_look_pos: {50.0,50.0,0.0} camera_up_vector: {-4.3297802811774646E-17,0.7071067811865472,0.7071067811865478}{
			species people position: {0, 0, 0.05};
			//			graphics world transparency: 0.4{ 
			//				draw cube(100) scaled_by {1,1,0.08}  texture:("../images/water2.gif") ;
			//			}
		}

	}

}

