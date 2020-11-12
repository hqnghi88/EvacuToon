model People

import "../Parameters.gaml"
import "Stand.gaml"
import "Cell.gaml"

//Species cell which represents the cell agents, using the skill moving
species people skills: [moving] {
	bool is_presenter <- false;
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
	cell c;
	//Evacuation point
	point target;
	list<cell> passed <- [];
	path path_followed;
	int count <- 0;
	bool arrived <- false;
	int sex<-rnd(1);
 
	reflex visit when: !is_presenter { //when: event = "hazard" {
		ask cell at location {
			used <- false;
		}
		//		do goto target: target speed: 1.0 on: (cell where (not each.is_wall and (each.p != self))) return_path: true recompute_path: true; 
		path_followed <- goto(target: target, on: (cell where ((not each.is_wall) and (not each.used))), speed: 15.0, recompute_path: true, return_path: true);
		ask cell at location {
			used <- true;
		}
		//		if (path_followed != nil) {
		//			ask (passed) {
		//				used <- false;
		//				p <- nil;
		//				color <- #white;
		//			}
		//
		//			passed <- cell overlapping path_followed.shape;
		//		}
		//
		//		ask (passed) {
		//			used <- true;
		//			p <- myself;
		//			color <- myself.color;
		//		}
		if (current_edge = nil and flip(0.01)) {
			ask cell at location {
				used <- false;
			}

			center <- any_location_in(any(stand).shape);
			target <- cell at center;
			if (count_fire > 0) {
				target <- one_of(cell where each.is_exit).location;
			}
			//			target <- one_of(cell where each.is_exit).location;
		}
		//		people close <- one_of(((self neighbors_at range) of_species people) sort_by (self distance_to each));
		//		if close != nil {
		//			heading <- (self towards close) - 180;
		//			float dist <- self distance_to close;
		//			do move speed: dist / repulsion_strength heading: heading;
		//			//			do wander speed: dist / repulsion_strength;
		//		}
		//If the agent is close enough to the exit, it dies
		if ((self distance_to target) < 100.0) {
			if (flip(0.00001)) {
			//				ask (passed) {
			//					used <- false;
			//					p <- nil;
			//					color <- #white;
			//				}
				ask cell at location {
					used <- false;
				}

				center <- any_location_in(any(stand).shape);
				target <- cell at center;
			}
			//			arrived <- true;

			//			do die;
			if (count_fire > 0) {
				ask cell at location {
					used <- false;
				}

				do die;
			}

		} }

	aspect default {
		draw sex=1?pyramid(size):box(4,10,size) color: color;
		draw sphere(size / 3) at: {location.x, location.y, size * 0.75} color: color;
	} }
