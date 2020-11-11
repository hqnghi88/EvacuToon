model EvacuationInClassroom

global {
	int max <- 10;
	//DImension of the grid agent
	int nb_cols <- 20;
	int nb_rows <- 20;
	list
	myname <- ["Daisy", "Cathy", "Matina", "Lyly", "Millie", "Melody", "Catarina", "Elisabeth", "Paul", "John", "Marc", "Helen", "Raon", "Peter", "Tommy", "Linda", "Anthony", "Phillip", "Rocky", "Nguyen", "Kevin", "Damien", "Benoit"];
	geometry shape <- envelope(square(200));
	file texture <- file('../includes/table.png');

	//Time value for a cycle by default 1s/cycle
	float stepDuration <- 100000.0 #ms min: 100.0 #ms max: 600000 #ms;
	//Background of the clock
	file clock_normal const: true <- image_file("../images/clock.png");
	//Image for the big hand 
	file clock_big_hand const: true <- image_file("../images/big_hand.png");
	//Image for the small hand
	file clock_small_hand const: true <- image_file("../images/small_hand.png");
	//Image for the clock alarm
	file clock_alarm const: true <- image_file("../images/alarm_hand.png");
	//Zoom to take in consideration the zoom in the display, to better write the cycle values
	int zoom <- 2 min: 2 max: 10;
	//Postion of the clock
	float clock_x <- 150.0;
	float clock_y <- 20.0;

	//Alarm parameters
	int alarm_days <- 0 min: 0 max: 365;
	int alarm_hours <- 2 min: 0 max: 11;
	int alarm_minutes <- 0 min: 0 max: 59;
	int alarm_seconds <- 0 min: 0 max: 59;
	bool alarm_am <- true;
	//Compute the number of cycles corresponding to the time of alarm
	int alarmCycle <- int((alarm_seconds + alarm_minutes * 60 + alarm_hours * 3600 + (alarm_am ? 0 : 3600 * 12) + alarm_days * 3600 * 24) * 1000 #ms / stepDuration);

	//Time elapsed since the beginning of the experiment
	int timeElapsed <- 0 update: int(cycle * stepDuration);
	string reflexType <- "";
	string event <- "study";

	init {
		myname <- shuffle(myname);
		list<geometry> tbl <- [];
		float xx <- 20.0;
		float yy <- 70.0;
		loop i from: 1 to: 3 {
			tbl <+ (rectangle(20, 10) at_location {xx, yy + i * 35});
			tbl <+ (rectangle(20, 10) at_location {xx + 50, yy + i * 35});
			tbl <+ (rectangle(20, 10) at_location {xx + 100, yy + i * 35});
			tbl <+ (rectangle(20, 10) at_location {xx + 150, yy + i * 35});
		}

		create class from: [(rectangle(200, 135) at_location {100, 135})] {
			ask cell overlapping self {
				is_wall <- false;
			}

		}

		create exit from: [rectangle(5, 50) at_location {195, 55}] {
			ask (cell overlapping self) where not each.is_wall {
				is_exit <- true;
			}

		}

		create table from: tbl {
			ask cell overlapping self {
				is_wall <- true;
			}

			create people {
				mytable <- myself;
				location <- {mytable.location.x, mytable.location.y - 10};
				//				c <- one_of(cell where (not each.is_wall and not each.used));
				//				c.used <- true;
				//			location <- c.location;
				//Target of the people agent is one of the possible exits
				target <- one_of(cell where each.is_exit).location;
			}

		}

		create clock number: 1 {
			location <- {clock_x, clock_y};
		}

	}

}

species class {

	aspect default {
		draw shape color: #gray;
	}

}

species table {

	aspect default {
	//		draw shape color:#gray;
		draw texture size: {30, 10};
	}

}

//Species exit which represent the exit
species exit {

	aspect default {
		draw shape color: #blue;
	}

}

species people skills: [moving] parallel: true {
	int no <- rnd(max);
	table mytable;

	reflex studying when: event = "study" {
		location <- {mytable.location.x, mytable.location.y - 10};
	}

	reflex playing when: event = "playtime" {
		do wander bounds: class[0] amplitude: 90.0 speed: rnd(15.0);
	}

	cell c;
	//Evacuation point
	point target;
	rgb color <- rnd_color(255);
	list<cell> passed <- [];
	path path_followed;
	//Reflex to move the agent 
	reflex evacuate when: event = "hazard" {
	//Make the agent move only on cell without walls 
	//		do goto target: target speed: 1.0 on: (cell where (not each.is_wall and (each.p != self))) return_path: true recompute_path: true; 
		path_followed <- goto(target: target, on: (cell where ((not each.is_wall) and (not each.used))), speed: 5.0, recompute_path: true, return_path: true);
		if (path_followed != nil) {
			ask (passed) {
				used <- false;
				p <- nil;
				color <- #white;
			}

			passed <- cell overlapping path_followed.shape;
		}

		ask (passed) {
			used <- true;
			p <- myself;
			color <- myself.color;
		}

		if (current_edge = nil) {
			ask (passed) {
				used <- false;
				p <- nil;
				color <- #white;
			}

			target <- one_of(cell where each.is_exit).location;
		}
		//If the agent is close enough to the exit, it dies
		if (self distance_to target) < 5.0 {
			ask (passed) {
				used <- false;
				p <- nil;
				color <- #white;
			}

			do die;
		} }

	aspect default {
		draw gif_file("../includes/" + no + ".gif") size: {25, 25}; // rotate: heading + 45;
		draw myname[int(self) mod length(myname)] font: font(30) color: #black at: {location.x, location.y + 20}; // rotate: heading + 45;
	} }

	//Grid species to discretize space
grid cell width: nb_cols height: nb_rows neighbors: 8 parallel: true {
	bool is_wall <- true;
	bool used <- false;
	bool is_exit <- false;
	people p;
	rgb color <- #white;

	reflex ss {
	//			p <- nil;
	}

}

species hazard {
	geometry shape <- square(20);

	aspect default {
		draw gif_file("../includes/fire.gif") size: {25, 25};
	}

}
//Species that will represent the clock
species clock {
	float nb_minutes <- 0.0 update: ((timeElapsed mod 3600 #s)) / 60 #s; //Mod with 60 minutes or 1 hour, then divided by one minute value to get the number of minutes
	float nb_hours <- 0.0 update: ((timeElapsed mod 86400 #s)) / 3600 #s;
	float nb_days <- 0.0 update: ((timeElapsed mod 31536000 #s)) / 86400 #s;

	reflex update {
	//			write string(nb_hours) + " : " + nb_minutes;
		if (event != "hazard" and nb_hours mod 4 = 0) {
			event <- "playtime";
		}

		if (event != "hazard" and nb_hours mod 6 = 0) {
			event <- "study";
		}

		if (event != "hazard" and flip(0.01)) {
			event <- "hazard";
			create hazard {
				location <- any_location_in(class[0] - table);
				ask cell overlapping self {
					is_wall <- true;
				}

			}

		}
		//		if (cycle = alarmCycle) {
		//			write "Time to leave";
		//
		//			// Uncomment the following statement to play the Alarm.mp3
		//			// But firstly, you need to go to "Help -> Install New Software..." to install the "audio" feature. 
		//			// start_sound source: "../includes/Alarm.mp3" ;
		//		}

	}

	aspect default {
		draw clock_normal size: 10 * zoom;
		//		draw string(" " + cycle + " cycles") size: zoom / 2 font: "times" color: °black at: {clock_x - 5, clock_y + 5};
		draw clock_big_hand rotate: nb_minutes * (360 / 60) + 90 size: {7 * zoom, 2} at: location + {0, 0, 0.1}; //Modulo with the representation of a minute in ms and divided by 10000 to get the degree of rotation
		draw clock_small_hand rotate: nb_hours * (360 / 12) + 90 size: {5 * zoom, 2} at: location + {0, 0, 0.1};
		draw clock_alarm rotate: (alarmCycle / 12000) size: zoom / 3 at: location + {0, 0, 0.1}; // Alarm time
		//		draw string(" " + int(nb_days) + " Days") size: zoom / 2 font: "times" color: °black at: {clock_x - 5, clock_y + 8};
		//		draw string(" " + int(nb_hours) + " Hours") size: zoom / 2 font: "times" color: °black at: {clock_x - 5, clock_y + 10};
		//		draw string(" " + int(nb_minutes) + " Minutes") size: zoom / 2 font: "times" color: °black at: {clock_x - 5, clock_y + 12};
		//		draw string(" " + timeElapsed + " Seconds") size: zoom / 2 font: "times" color: °black at: {clock_x - 5, clock_y + 14};
	}

}

experiment "Millie And Melody Classroom" type: gui {
	output {
		display Ripples type: opengl synchronized: true { //camera_pos: {50.00000000000001,140.93835147797245,90.93835147797242} camera_look_pos: {50.0,50.0,0.0} camera_up_vector: {-4.3297802811774646E-17,0.7071067811865472,0.7071067811865478}{
		//			image file: "../includes/class.jpg"; //refresh: false;
			graphics class position: {0, 0, -0.01} {
				draw image_file("../includes/class.jpg"); //cube(100) scaled_by {1,1,0.08}  texture:("../includes/class.jpg") ;
			}

			species clock;
			species people; //position: {0, 0, 0.05};
			//			species class;
			//species exit;
			species table;
			species hazard;
		}

	}

}

