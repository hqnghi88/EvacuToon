model Ground

import "../Parameters.gaml"
grid ground width: 70 height: 40 neighbors: 8 parallel: true {
	rgb color <- #white;
	int obstacle <- -1;

	aspect default {
		if (obstacle >= 0) {
		//			draw image_file(images[obstacle]) size: {shape.width, shape.height};
			if (obstacle = 2) {
				draw obj_file("../includes/Table_Carre.obj") at: {location.x, location.y, 10} color: #darkgray size: {shape.width, shape.height} rotate: -90::{1, 0, 0};
			} else if (obstacle = 4) {
				draw obj_file("../includes/Linda_Coffee_Table.obj") at: {location.x, location.y, 10} color: #darkgray size: {shape.width, shape.height} rotate: -90::{1, 0, 0};
			} else if (obstacle = 5) {
				draw obj_file("../includes/TableTwist_Obj.obj") at: {location.x, location.y, 10} color: #darkgray size: {shape.width, shape.height} rotate: -90::{1, 0, 0};
			} else {
				draw box(shape.width, shape.height, obstacle_depth[obstacle]) texture: image_file(images[obstacle]);
			} } } }