/**
* Name: Circle 
* Author: 
* Description: This model shows the movement of cells trying to do a circle shape with themselves 
* 	considering the other cells. The second experiment shows a bigger circle using more cell agents. 
* Tags: skill
*/
model circle_model

import "Parameters.gaml"
import "entities/Button.gaml"
import "entities/Cell.gaml"
import "entities/Ground.gaml"

global {

	action activate_act {
		button selected_but <- first(button overlapping (circle(1) at_location #user_location));
		if (selected_but != nil) {
			ask selected_but {
				ask button {
					bord_col <- #black;
				}

				if (action_type != id) {
					action_type <- id;
					bord_col <- #red;
				} else {
					action_type <- -1;
				}

			}

		}

	}

	action cell_management {
		ground selected_cell <- first(ground overlapping (circle(1.0) at_location #user_location));
		if (selected_cell != nil) {
			ask selected_cell {
				obstacle <- action_type;
				ask cell overlapping selected_cell {
					is_wall <- true;
				}

				if (action_type = 2) {
					count_fire <- count_fire + 1;
				}

				if (action_type = 0) {
					if (obstacle = 2) {
						count_fire <- count_fire - 1;
					}

					obstacle <- -1;
					ask cell overlapping selected_cell {
						is_wall <- false;
					}

				}

			}

		}

	}

}   