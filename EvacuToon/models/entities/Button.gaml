model button

import "../Parameters.gaml"
grid button width: 3 height: 1 {
	int id <- int(self);
	rgb bord_col <- #black;

	aspect normal {
		draw rectangle(shape.width * 0.8, shape.height * 0.8).contour + (shape.height * 0.01) color: bord_col;
		draw image_file(images[id]) size: {shape.width * 0.5, shape.height * 0.5};
	}

}