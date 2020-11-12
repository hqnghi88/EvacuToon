model param

global {
//Number of agents to create
	int number_of_agents <- 15;
	//Radius of the circle that the cells will make
	float radius_of_circle <- 5.0;
	//Repulsion strength of one cell to the others
	int repulsion_strength min: 1 <- 10;
	//Size of the environment
	//	int width_and_height_of_environment min: 10 <- 10000;
	//Range of the agents
	int range_of_agents min: 1 <- 15;
	//Speed of the agents
	float speed_of_agents  <- 15.0;
	//Size of the agents
	int nb_cols <- 100;
	int nb_rows <- 100;
	//	int size_of_agents <- 100;
	//Center of the considered circle created by the cells
	point center1 <- {world.shape.width / 2, world.shape.height / 2};
	shape_file idecaf_shp <- shape_file("../includes/ground.shp");
	shape_file stand_shp <- shape_file("../includes/stands.shp");
	shape_file gates_shp <- shape_file("../includes/gates.shp");
	list<point> cc <- [center1];
	geometry shape <- envelope(idecaf_shp);

	//current action type
	int action_type <- -1;
	int count_fire<-0;
	//images used for the buttons
	list<file> images <- [file("../images/eraser.png"),file("../images/rock.png"),file("../images/fire.gif")];
	string event <- "vvhazard";
} 
