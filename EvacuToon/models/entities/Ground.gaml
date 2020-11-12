model Ground

import "../Parameters.gaml"
grid ground width: 20 height: 20 neighbors: 8 parallel: true {
	rgb color <- #white;
	int obstacle <- -1;

	aspect default {
		if (obstacle >= 0) {
			draw image_file(images[obstacle]) size: {shape.width, shape.height};
			draw box(shape.width , shape.height , 50) texture: image_file(images[obstacle]);
		}

	}

}