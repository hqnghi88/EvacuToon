model Idecaf_evacuation

import "../models/Global.gaml"
experiment main type: gui {
	output {
		layout vertical([0::1000, 1::9000]) tabs: false toolbars: false editors: false;
		display action_buton name: "Tools panel" {
			species button aspect: normal;
			event mouse_down action: activate_act;
		}
		display Plan type: opengl ambient_light:(0) background:#lightgray{
			grid ground lines:#black;
			species ground;
			 
			species wall;
			species stand;
			species people;
			event mouse_down action: cell_management;
		}


	}

}
