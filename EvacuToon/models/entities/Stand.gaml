model Stand
import "../Parameters.gaml" 

species stand {
	geometry shape<-circle(20);
	aspect default {
		draw shape + 1 color: #darkgray depth: 150;
	}

}