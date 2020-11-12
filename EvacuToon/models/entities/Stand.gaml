model Stand
import "../Parameters.gaml" 

species stand {
	geometry shape<-circle(50);
	aspect default {
		draw box(2,2,100) color: color;
		draw box(50,2,70) texture:image_file(label_img[int(self)]) at: {location.x, location.y, 100} color: color;
	}

}