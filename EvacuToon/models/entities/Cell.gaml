model Cell

import "../Parameters.gaml"
import "People.gaml"
//Grid species to discretize space
grid cell width: nb_cols height: nb_rows neighbors: 8 parallel: true {
	bool is_wall <- false;
	bool used <- false;
	bool is_exit <- false;
	people p;
	rgb color <- #white;

	reflex ss {
	//			p <- nil;
	}

}
