<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONObject" %>

<%@ page import="com.mitlab.DataPacket" %>
<%@ page import="com.mitlab.ProjectManager" %>

<%

	JSONObject jsonCallback = new JSONObject();

	request.getParameter("readOrSave");


	ProjectManager projectManager = new ProjectManager();
	DataPacket dataPacket = new DataPacket();
	dataPacket.project_export_folder_path = "/opt/tomcat/webapps/III/resources/projects/" + dataPacket.project_time_stamp;
	dataPacket.project_export_path_fname = "/opt/tomcat/webapps/III/resources/projects/" + "Site_survey_Project_" + dataPacket.project_time_stamp + ".fu3i";


	if(readOrSave) { //true for read
		String unzipFilePath = "";
        unzipFilePath = projectManager.unPackin(packet.project_export_path_fname, "/opt/tomcat/webapps/III/resources/projects/unzip");
        jsonCallback.put("project_json_path", unzipFilePath); // return json path

	}
	else { // false for save

	JSONArray  rssi_info_arr    = new JSONArray();
    JSONArray  ap_pos_info_arr  = new JSONArray();
    JSONArray  heatmap_RGB_arr  = new JSONArray();
    JSONObject rssi_info_obj    = new JSONObject();
    JSONObject heatmap_RGB_obj  = new JSONObject();
    JSONObject ap_pos_info_obj  = new JSONObject();

    double scale  = Double.parseDouble(request.getParameter("scale"));
    // float scale  = Float.valueOf(request.getParameter("scale"));

    int imgWidth  = Integer.valueOf(request.getParameter("imgWidth"));
    int imgHeight = Integer.valueOf(request.getParameter("imgHeight"));

    JSONObject jsonObj          = new JSONObject();                                         // store indoor image information
    JSONArray pos               = new JSONArray(request.getParameter("pos"));               // wall positions
    JSONArray elevator          = new JSONArray(request.getParameter("elevator"));          // elevator positions
    JSONArray sensorNode        = new JSONArray(request.getParameter("sensorNode"));        // sensorNode positions
    JSONArray uplinkPoint       = new JSONArray(request.getParameter("uplinkPoint"));       // uplinkPoint positions
    JSONObject ap               = new JSONObject(request.getParameter("ap"));               // ap information
    JSONObject requirementArea  = new JSONObject(request.getParameter("requirementArea"));  // Requirement Area
    JSONArray regionClassifications = new JSONArray(request.getParameter("regionClassifications"));  // Sub-Requirement Area

    // add new lines
    JSONArray drawLines	= new JSONArray(request.getParameter("drawLines"));
    JSONArray drawStraightLines	= new JSONArray(request.getParameter("drawStraightLines"));
    JSONArray drawSquares = new JSONArray(request.getParameter("drawSquares"));
    JSONArray drawSquaresForElevator = new JSONArray(request.getParameter("drawSquaresForElevator"));
    JSONArray drawUplinkPoint = new JSONArray(request.getParameter("drawUplinkPoint"));
    JSONArray drawSensorNode = new JSONArray(request.getParameter("drawSensorNode"));
    JSONArray drawRegionClassifications = new JSONArray(request.getParameter("drawRegionClassifications"));
    JSONArray drawRegionClassificationsTemp = new JSONArray(request.getParameter("drawRegionClassificationsTemp"));

    String deploymentType = request.getParameter("deploymentType");
    String deployApType = request.getParameter("deployApType");
    String nowPage = request.getParameter("nowPage");

    JSONArray deployPara = new JSONArray(request.getParameter("deployPara"));

    //******************

    String apType   = request.getParameter("apType");
    String miniRSSI = request.getParameter("miniRSSI");
    String apAndApInitPower = request.getParameter("apAndApInitPower");
    String meshAndSSNInitPower = request.getParameter("meshAndSSNInitPower");
    String apAndApRange = request.getParameter("apAndApRange");
    String meshAndSSNRange = request.getParameter("meshAndSSNRange");
    String sensorNodeImage = request.getParameter("sensorNodeImage");

    jsonObj.put("imgWidth", imgWidth);
    jsonObj.put("imgHeight", imgHeight);
    jsonObj.put("scale", scale);
    jsonObj.put("requirementArea", requirementArea);
    jsonObj.put("pos", pos);
    jsonObj.put("ap", ap);
    jsonObj.put("elevator", elevator);
    jsonObj.put("uplinkPoint", uplinkPoint);
    jsonObj.put("sensorNode", sensorNode);
    jsonObj.put("apType", apType);
    jsonObj.put("miniRSSI", miniRSSI);
    jsonObj.put("apAndApInitPower", apAndApInitPower);
    jsonObj.put("meshAndSSNInitPower", meshAndSSNInitPower);
    jsonObj.put("apAndApRange", apAndApRange);
    jsonObj.put("meshAndSSNRange", meshAndSSNRange);
    jsonObj.put("sensorNodeImage", sensorNodeImage);
    jsonObj.put("regionClassifications", regionClassifications);

    // add new lines
    jsonObj.put("drawLines", drawLines);
    jsonObj.put("drawStraightLines", drawStraightLines);
    jsonObj.put("drawSquares", drawSquares);
    jsonObj.put("drawSquaresForElevator", drawSquaresForElevator);
    jsonObj.put("drawUplinkPoint", drawUplinkPoint);
    jsonObj.put("drawSensorNode", drawSensorNode);
    jsonObj.put("drawRegionClassifications", drawRegionClassifications);
    jsonObj.put("drawRegionClassificationsTemp", drawRegionClassificationsTemp);
    jsonObj.put("deploymentType", deploymentType);
    jsonObj.put("deployApType", deployApType);
    jsonObj.put("nowPage", nowPage);
    jsonObj.put("deployPara", deployPara);


    projectManager.initPackin(dataPacket, jsonObj);
    projectManager.packin(dataPacket.project_export_folder_path);
    jsonCallback.put("project_file_path", dataPacket.project_export_path_fname); // return project file path
   



	}

%>

<%= jsonCallback%>