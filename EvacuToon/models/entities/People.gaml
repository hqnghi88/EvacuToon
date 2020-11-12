model People

import "../Parameters.gaml"
import "Cell.gaml"

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
	cell c;
	//Evacuation point
	point target;
	list<cell> passed <- [];
	path path_followed;
	int count <- 0; 
	bool arrived<-false;

//	reflex go_to_center when: event != "hazard" {
//		heading <- (((self distance_to center) > radius_of_circle) ? self towards center : (self towards center) - 180);
//		do goto target:target on: (cell where ((not each.is_wall) and (not each.used)))  speed: speed;
//		
//		//		do move speed: speed;
//	}

	reflex flee_others   when:count_fire=0{//event != "hazard" {
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

	reflex evacuate when: !arrived{//when: event = "hazard" {
	//		do goto target: target speed: 1.0 on: (cell where (not each.is_wall and (each.p != self))) return_path: true recompute_path: true; 
		path_followed <- goto(target: target, on: (cell where ((not each.is_wall) and (not each.used))), speed: 15.0, recompute_path: true, return_path: true);
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

//				center <- any(cc);
//				target<-cell at center.location;
//			target <- one_of(cell where each.is_exit).location;
		}
		//If the agent is close enough to the exit, it dies
		if ((self distance_to target) < 10.0) {
			ask (passed) {
				used <- false;
				p <- nil;
				color <- #white;
			}
			arrived<-true;

//			do die;
		} 
		}

	aspect default {
		draw sphere(size) color: color;
	} }
