/**
* Name: AnimatedGIFLoading
* Author: A. Drogoul
* Description:  Shows how to load animated GIF files and use them as textures or display them directly. 
* Tags: Image, Display, File
*/
model AnimatedGIFLoading

global {
	int max <- 10;
	list
	myname <- ["Daisy", "Cathy", "Matina", "Lyly", "Millie", "Melody", "Catarina", "Elisabeth", "Paul", "John", "Marc", "Helen", "Raon", "Peter", "Tommy", "Linda", "Anthony", "Phillip", "Rock","Nguyen","Kevin","Damien","Benoit"];
	geometry shape <- envelope(square(200));
	file texture <- file('../includes/table.png');

	init {
		myname<-shuffle(myname);
		list<geometry> tbl <- [];
		float xx <- 10.0;
		float yy <- 0.0;
		loop i from: 1 to: 5 {
			tbl <+ (rectangle(20, 10) at_location {xx, yy + i * 35});
			tbl <+ (rectangle(20, 10) at_location {xx + 50, yy + i * 35});
			tbl <+ (rectangle(20, 10) at_location {xx + 100, yy + i * 35});
		}

		create table from: tbl {
			create people {
				location <- {myself.location.x, myself.location.y - 10};
			}

		}

	}

}

species table {

	aspect default {
	//		draw shape color:#gray;
		draw texture size: {20, 10};
	}

}

species people skills: [moving] {
	int no <- rnd(max);

	reflex r {
		do wander amplitude: 2.0 speed: 0.1;
	}

	aspect default {
		draw gif_file("../includes/" + no + ".gif") size: {25, 25}; // rotate: heading + 45;
		draw myname[int(self) mod length(myname)] font: font(30) color: #black at: {location.x, location.y + 20}; // rotate: heading + 45;
	}

}

experiment "Millie And Melody Classroom" type: gui {
	output {
		display Ripples type: opengl synchronized: true { //camera_pos: {50.00000000000001,140.93835147797245,90.93835147797242} camera_look_pos: {50.0,50.0,0.0} camera_up_vector: {-4.3297802811774646E-17,0.7071067811865472,0.7071067811865478}{
			species people; //position: {0, 0, 0.05};
			species table;
			//			graphics world transparency: 0.4{ 
			//				draw cube(100) scaled_by {1,1,0.08}  texture:("../images/water2.gif") ;
			//			}
		}

	}

}

