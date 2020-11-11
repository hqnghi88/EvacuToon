/**
* Name: Circle 
* Author: 
* Description: This model shows the movement of cells trying to do a circle shape with themselves 
* 	considering the other cells. The second experiment shows a bigger circle using more cell agents. 
* Tags: skill
*/
model circle_model

global {
//Number of agents to create
	int number_of_agents <- 150;
	//Radius of the circle that the cells will make
	float radius_of_circle <- 5.0;
	//Repulsion strength of one cell to the others
	int repulsion_strength min: 1 <- 10;
	//Size of the environment
	//	int width_and_height_of_environment min: 10 <- 10000;
	//Range of the agents
	int range_of_agents min: 1 <- 25;
	//Speed of the agents
	float speed_of_agents min: 0.1 <- 0.1;
	//Size of the agents
	int nb_cols <- 20;
	int nb_rows <- 20;
	//	int size_of_agents <- 100;
	//Center of the considered circle created by the cells
	point center1 <- {world.shape.width / 2, world.shape.height / 2};
	shape_file idecaf_shp <- shape_file("../includes/ground.shp");
	shape_file stand_shp <- shape_file("../includes/stands.shp");
	shape_file gates_shp <- shape_file("../includes/gates.shp");
	list<point> cc <- [center1];
	geometry shape <- envelope(idecaf_shp);

	init {
//		center1 <- {world.shape.width / 2, world.shape.height / 2};
		create ground from: idecaf_shp;
		create stand from: stand_shp;
		create gate from: gates_shp;
//		save gate to:"../includes/gates.shp" type:shp;
		center1<-stand[0].location;
		cc<-stand collect each.location;
//		loop times: 2 {
//			point nc;
//			bool ok <- false;
//			loop while: !ok {
//				nc <- {rnd(world.shape.width), rnd(world.shape.height)};
//				ok <- true;
//				loop cen over: cc {
//					if (distance_to(nc, cen) < (radius_of_circle * 2) or (nc.x < radius_of_circle) or (nc.y < radius_of_circle) or (nc.x > world.shape.width - radius_of_circle) or
//					(nc.y > world.shape.height - radius_of_circle)) {
//						ok <- false;
//					}
//
//				}
//
//			}
//
//			cc <+ nc;
//		}
		//Creation of the cell agents
		create people number: number_of_agents {
			location<-any_location_in(any(gate));
			center <- center1;
		}

	}

	reflex sss {
		if (length(people where (each.count > 200)) > 50) {
			ask (people where (each.count > 200)) {
				center <- cc[rnd(length(cc) - 1)];
				count <- 0;
			}

		}

	}

}

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

species gate {

	aspect default {
		draw shape+1 color: #darkgray depth:150;
	}

}
species stand {

	aspect default {
		draw shape+1 color: #darkgray depth:150;
	}

}
species ground {

	aspect default {
		draw shape+1 color: #darkgray depth:50;
	}

}
//Species cell which represents the cell agents, using the skill moving
species people skills: [moving] {
	point center;
	//Color of the cell, randomly chosen
	rgb color const: true <- [100 + rnd(155), 100 + rnd(155), 100 + rnd(155)] as rgb;
	//Size of the cell
	float size const: true <- float(radius_of_circle);
	//Range of the cell
	float range const: true <- float(range_of_agents);
	//Speed of the cell
	float speed const: true <- speed_of_agents;
	//Heading of the cell, the direction it 'watches'
	//	int heading <- rnd(359);

	//Reflex to make the cell agent fo to the center, calling the derivated action move
	reflex go_to_center {
		heading <- (((self distance_to center) > radius_of_circle) ? self towards center : (self towards center) - 180);
		do wander amplitude: 25.0 speed: speed;
		//		do move speed: speed;
	}

	int count <- 0;
	//Reflex to flee of the other cells agents, which will help to design the circle shape
	reflex flee_others {

	//write ""+cycle+" "+self+"\n";
		people close <- one_of(((self neighbors_at range) of_species people) sort_by (self distance_to each));
		if close != nil {
			heading <- (self towards close) - 180;
			float dist <- self distance_to close;
			do move speed: dist / repulsion_strength heading: heading;
			do wander speed: dist / repulsion_strength;
		}

		int nn <- length((self neighbors_at (range * 1.5)) of_species people);
		if (nn > 4) {
			count <- count + 1;
		}

	}

	aspect default {
		draw sphere(size) color: color;
	}

}

experiment main type: gui {
	output {
		display Circle type:opengl{
			species ground;
			species people;
		}

	}

}
