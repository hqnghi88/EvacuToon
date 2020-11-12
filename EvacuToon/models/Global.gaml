/**
* Name: Circle 
* Author: 
* Description: This model shows the movement of cells trying to do a circle shape with themselves 
* 	considering the other cells. The second experiment shows a bigger circle using more cell agents. 
* Tags: skill
*/
model circle_model

import "Actions.gaml"
import "Parameters.gaml"
import "entities/Button.gaml"
import "entities/Cell.gaml"
import "entities/Wall.gaml"
import "entities/Ground.gaml"
import "entities/Stand.gaml"
import "entities/Gate.gaml"

global {

	init {
	//		center1 <- {world.shape.width / 2, world.shape.height / 2};
		create wall from: idecaf_shp {
			ask cell overlapping self {
				is_wall <- true;
			}

		}

		create gate from: gates_shp {
			ask (cell overlapping self) where not each.is_wall {
				is_exit <- true;
			}

		}
		//		save gate to:"../includes/gates.shp" type:shp;
		create stand from: stand_shp {
			create people number: number_of_agents {
				is_presenter<-true;
				location <- any_location_in(myself.shape); 
				center <- any_location_in(myself.shape);
				target <- cell at center.location;
				//				target <- one_of(cell where each.is_exit).location;
			}

		}

		cc <- stand collect each.location;
	}

	reflex sss {
		if (count_fire > 0 and event!="hazard") {
			event<-"hazard";
			ask people {
				arrived <- false;
				target <- one_of(cell where each.is_exit).location;
			}

		}else{
//			ask people {
//				arrived <- false;
//				center <- any(cc);
//				target <- cell at center.location;
//			}
		}

//		if (length(people where (each.count > 20)) > 5) {
//			ask (people where (each.count > 20)) {
//				arrived <- false;
//				center <- any(cc);
//				target <- cell at center.location;
//				count <- 0;
//			}
//
//		}

	}

}   
