model Idecaf_evacuation

import "../models/Global.gaml"
experiment main type: gui {
	output {
		layout vertical([0::1000, 1::9000]) tabs: false toolbars: false editors: false;
		display action_buton name: "Tools panel" {
			species button aspect: normal;
			event mouse_down action: activate_act;
		}
		display Plan type: opengl ambient_light:(0){
			grid ground;
			species ground;
			species wall;
			species people;
			event mouse_down action: cell_management;
		}


	}

}
