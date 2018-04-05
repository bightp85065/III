<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONObject" %>

<%@ page import="java.io.*" %>
<%@ page import="java.awt.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.awt.Point" %>
<%@ page import="java.lang.Math" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="static java.lang.StrictMath.cos" %>
<%@ page import="static java.lang.StrictMath.sin" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStream" %>

<%@ page import="com.mitlab.JSONparser" %>
<%@ page import="com.mitlab.DataPacket" %>
<%@ page import="com.mitlab.ImageWeight" %>
<%@ page import="com.mitlab.EXCELwriter" %>
<%@ page import="com.mitlab.FunctionPack" %>
<%@ page import="com.mitlab.AlgorithmPack" %>

<%@ page import="org.bytedeco.javacv.*" %>
<%@ page import="org.bytedeco.javacpp.*" %>
<%@ page import="org.bytedeco.javacpp.indexer.*" %>
<%@ page import="org.bytedeco.javacpp.opencv_core.*" %>
<%@ page import="org.bytedeco.javacpp.opencv_highgui.*" %>
<%@ page import="org.bytedeco.javacpp.opencv_imgcodecs.*" %>

<%@ page import="jxl.Workbook" %>
<%@ page import="jxl.WorkbookSettings" %>
<%@ page import="jxl.write.Label" %>
<%@ page import="jxl.write.WritableSheet" %>
<%@ page import="jxl.write.WriteException" %>
<%@ page import="jxl.write.WritableWorkbook" %>

<%
    // main script

    // ----------------------------------- ONLY EXIST IN JSP ----------------------------------- //

    JSONArray  rssi_info_arr    = new JSONArray();
    JSONArray  ap_pos_info_arr  = new JSONArray();
    JSONArray  heatmap_RGB_arr  = new JSONArray();
    JSONObject rssi_info_obj    = new JSONObject();
    JSONObject heatmap_RGB_obj  = new JSONObject();
    JSONObject ap_pos_info_obj  = new JSONObject();
    JSONObject jsonCallback     = new JSONObject();

    
    
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

    String apType   = request.getParameter("apType");
    String miniRSSI = request.getParameter("miniRSSI");

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

    // ----------------------------------- ONLY EXIST IN JSP ----------------------------------- //

    // ===== COPY TO JSP : START ===== //
    int img_pxl_value;
    int deployed_ap_num;
	    // int weight_value;
    final UByteIndexer img_Idx;
    // final UByteIndexer img_weight_Idx;
    JSONparser    jsonParser    = new JSONparser();
    DataPacket    packet        = new DataPacket();
    ImageWeight   imageWeight   = new ImageWeight();
    AlgorithmPack algorithmPack = new AlgorithmPack();
    FunctionPack  functionPack  = new FunctionPack();
    // ArrayList<Integer>  = new ArrayList<>();
    Mat imgWeight;
    long imageWeight_func_time_start, imageWeight_func_time_end, imageWeight_func_elapsed_time;
    JSONObject jsonObject_wall_info = null;
    JSONObject jsonObject_indr_img = new JSONObject();
    JSONObject jsonObject_program_state = new JSONObject();
    Point deployed_AP_pos = new Point();

    jsonObject_wall_info = functionPack.get_wallList_fromDB();
    jsonParser.generate_wall_info(packet, jsonObject_wall_info);

    // AP setting
    // packet.apType = "AP";   // AP type representing "AP" or "Mesh"
    packet.apType = jsonObj.getString("apType").toUpperCase();   // AP type representing "AP" or "Mesh"

    packet.AP_dict.put("p_d0", -20);        // The strength with dBm at "1 meter" distance(d0) from the AP
    packet.AP_dict.put("nW_C", 2);          // The maximum number of obstructions(walls) up to which the attenuation factor makes a difference
    packet.AP_dict.put("n_rate", 2);        // The rate at which the path loss increases with distance
    packet.AP_dict.put("d0", 1);            // Reference distance
        // out.println(packet.AP_dict.toString(4));
    // out.println(jsonObject_wall_info.toString(4));
    // out.println(packet.wall_dict.toString(4));

    // out.println("\n------------------------------------------------------------------");
    // out.println("JsonObject parameters     >> imgWidth = " + jsonObj.getInt("imgWidth"));
    // out.println("JsonObject parameters     >> imgHeight = " + jsonObj.getInt("imgHeight"));
    // out.println("JsonObject parameters     >> scale = " + jsonObj.getDouble("scale"));
    // out.println("JsonObject parameters     >> apType = " + jsonObj.getString("apType"));
    // out.println("JsonObject parameters     >> miniRSSI = " + jsonObj.getString("miniRSSI"));

    jsonObject_indr_img = jsonObj;
    jsonParser.initialize_all_parameters(packet, jsonObject_indr_img);                          // Initialize all parameters in DataPacket.java
    jsonParser.generate_image_array(packet, functionPack, jsonObject_indr_img);
    jsonParser.generate_requirement_area_image_array(packet, functionPack, jsonObject_indr_img);
    // Transform img_arr to Mat format
    packet.img = functionPack.array_to_mat(packet.img_arr, packet.img);
    packet.img_ori_clone = functionPack.array_to_mat(packet.img_arr_ori_clone, packet.img_ori_clone);

    // ===== 1st: Give image weights ===== //
        // imageWeight_func_time_start = System.nanoTime();
    imgWeight = imageWeight.imageWeightAlgorithm(packet);

        // imageWeight_func_time_end = System.nanoTime();
        //time elapsed
        // imageWeight_func_elapsed_time = imageWeight_func_time_end - imageWeight_func_time_start;
        // out.println("\nElapsed time of imageWeight.imageWeightAlgorithm is " + imageWeight_func_elapsed_time/1000000000 + "." + imageWeight_func_elapsed_time%1000000000 + " sec");

    // ===== 2nd: Find candidate AP positions ===== //
    // ----- fill Mat value to image_array ----- //
    img_Idx = packet.img.createIndexer();
    for(int _row=0; _row<packet.img_rows; _row++){
        for(int _col=0; _col<packet.img_cols; _col++){
            img_pxl_value = img_Idx.get(_row, _col, 0);
            packet.img_arr[_row][_col] = img_pxl_value;
        }
    }
    // out.println("\n------------------------------------------------------------------");
    // out.println("JSONObject parameters    >> upper left x1 = " + jsonObj.getInt("imgWidth"));
    // out.println("JSONObject parameters    >> lower left x2 = " + packet.x2_reqArea + "\tlower left y2 = " + packet.y2_reqArea);
    // out.println("JSONObject parameters    >> Map scale = " + packet.map_scale);
    // out.println("JSONObject parameters    >> AP type = " + packet.apType);
    // out.println("JSONObject parameters    >> AP radius = " + packet.radius + "\tAP diameter = " + packet.json_content_apIntensity + "\tAP heigtht = " + packet.ap_z_coordinate);
    // out.println("JSONObject parameters    >> Image rows = " + packet.img_rows + "\tImage cols = " + packet.img_cols);
    // out.println("JSONObject parameters    >> Max particle numbers across all quadrants = " + packet.particle_num);
    // out.println("JSONObject parameters    >> Window size to slide image = " + packet.window_size);

    // out.println("\n==================================================================");
    // out.println("Deployed AP numbers = " + packet.output_ap_pos.size());

        // imageWeight_func_time_start = System.nanoTime();
    algorithmPack.apDeployAlgorithm(packet, functionPack, jsonParser, jsonObject_indr_img, imgWeight);
        // imageWeight_func_time_end = System.nanoTime();
        // imageWeight_func_elapsed_time = imageWeight_func_time_end - imageWeight_func_time_start;
        // out.println("\nElapsed time of algorithmPack.apDeployAlgorithm is " + imageWeight_func_elapsed_time/1000000000 + "." + imageWeight_func_elapsed_time%1000000000 + " sec");

        // out.println("\n------------------------------------------------------------------");
        // out.println("Requirement (Area)        >> upper left x1 = " + packet.x1_reqArea + "\tupper left y1 = " + packet.y1_reqArea);
        // out.println("Requirement (Area)        >> lower left x2 = " + packet.x2_reqArea + "\tlower left y2 = " + packet.y2_reqArea);
        // out.println("Parameters  (scale)       >> Map scale = " + packet.map_scale);
        // out.println("Paramaters  (AP)          >> AP type = " + packet.apType);
        // out.println("Paramaters  (AP)          >> AP radius = " + packet.radius + "\tAP diameter = " + packet.json_content_apIntensity + "\tAP heigtht = " + packet.ap_z_coordinate);
        // out.println("Paramaters  (Image)       >> Image rows = " + packet.img_rows + "\tImage cols = " + packet.img_cols);
        // out.println("Paramaters  (Particle)    >> Max particle numbers across all quadrants = " + packet.particle_num);
        // out.println("Paramaters  (Window Size) >> Window size to slide image = " + packet.window_size);

        // out.println("\n==================================================================");
        // out.println("Deployed AP numbers = " + packet.output_ap_pos.size());

    img_Idx.release();

    // Store Data for excel exporting
    packet.json_content_sensorNode_power = jsonParser.getParameterJSON(jsonObject_indr_img, 6);
    packet.json_content_sensorNode_coodinate = jsonParser.getCoordinateJSON(jsonObject_indr_img, 0);
    packet.json_content_uplinkPoint_coodinate = jsonParser.getCoordinateJSON(jsonObject_indr_img, 1);

    // Exporting excel
    EXCELwriter writer = new EXCELwriter();
    writer.export(packet, packet.excel_export_path_fname);
    // ===== COPY TO JSP : END ===== //

    // ===== Return AP information to front-end part ===== //
    jsonCallback.put("heatmap_fname", packet.heatmap_fname);                            // output filename of heatmap image
    jsonCallback.put("indr_img_fname", packet.indr_img_fname);                          // output filename of indoor image
    jsonCallback.put("indr_heatmap_fname", packet.indr_heatmap_fname);                  // output filename of indoor image combining heatmap
    jsonCallback.put("excel_report", packet.excel_export_path_name);                   // output filename of report in excel format

    // debug
    int wall_key_int;
    String wall_key_string;
    Iterator<String> wall_dict_keys;    

    // ----- Add deployed AP positions to json ----- //
    for(int i=0; i<packet.output_ap_pos.size(); i++){
        ap_pos_info_obj = new JSONObject();
        deployed_AP_pos = packet.output_ap_pos.get(i);
        // out.println("idx = " + i + "\tap_x = " + deployed_AP_pos.x + "\tap_y = " + deployed_AP_pos.y);
        ap_pos_info_obj.put("x", deployed_AP_pos.x);
        ap_pos_info_obj.put("y", deployed_AP_pos.y);
        ap_pos_info_arr.put(ap_pos_info_obj);                                            // Add jsonObject to jsonArray

        // debug
        /*
        wall_dict_keys = packet.wall_dict.keys();
        int img_arr_value = packet.img_arr[deployed_AP_pos.y][deployed_AP_pos.x];
        while (wall_dict_keys.hasNext()){
            wall_key_string = wall_dict_keys.next();
            wall_key_int = Integer.parseInt(wall_key_string);
            if(wall_key_int == img_arr_value){
                out.println("\n------------------------------------------------------------------");
                out.println("AP_x = " + deployed_AP_pos.x + "\tAP_y = " + deployed_AP_pos.y);
                out.println("wall value = " + wall_key_int);
            }
        }
        */

    }
    jsonCallback.put("Deployed_AP_pos", ap_pos_info_arr);                                // output RSSI value of every pixel

    // ----- Add RSSI information to json ----- //
    // for(int _row=packet.y1_reqArea; _row<packet.y2_reqArea; _row++){
    //     for(int _col=packet.x1_reqArea; _col<packet.x2_reqArea; _col++){
    //        // if(packet.signal_stength_output_arr[_row][_col] < packet.signal_strength_thre)
    //        out.println(packet.signal_stength_output_arr[_row][_col]);
    //     }
    // }
    // jsonCallback.put("indr_RSSI_information", packet.img_signal_rssi_output_arr);          // output RSSI value of every pixel
    jsonCallback.put("indr_RSSI_information", packet.signal_stength_output_arr);          // output RSSI value of every pixel


    // ----- Add colored heatmap array ----- //
    // for(int _row=0; _row<packet.img_rows; _row++){
    //     for(int _col=0; _col<packet.img_cols; _col++){
    //         heatmap_RGB_obj = new JSONObject();
    //         heatmap_RGB_obj.put("x", _col);
    //         heatmap_RGB_obj.put("y", _row);
    //         heatmap_RGB_obj.put("R", packet.heatmap_colorRGB_arr_frontend[_row][_col][0]);
    //         heatmap_RGB_obj.put("G", packet.heatmap_colorRGB_arr_frontend[_row][_col][1]);
    //         heatmap_RGB_obj.put("B", packet.heatmap_colorRGB_arr_frontend[_row][_col][2]);
    //         heatmap_RGB_arr.put(heatmap_RGB_obj);                                       // Add jsonObject to jsonArray
    //     }
    // }
    // jsonCallback.put("heatmap_RGB", heatmap_RGB_arr);                                   // output RSSI value of every pixel
    // out.println(jsonCallback.toString(4));

    // ===== Program State ===== //
    if((Integer.parseInt(miniRSSI) > packet.RSSI_max_value) && (Integer.parseInt(miniRSSI) < packet.RSSI_min_value)){
        jsonObject_program_state.put("success", false);
        jsonObject_program_state.put("msg", packet.ERR_RSSI_OOR);
        jsonCallback.put("state", jsonObject_program_state);
    }

    // ===== debug ===== //
    // for(int i=0; i<packet.output_ap_pos.size(); i++){
    //     deployed_AP_pos = packet.output_ap_pos.get(i);
    //     int ap_x = deployed_AP_pos.x;
    //     int ap_y = deployed_AP_pos.y;
    //     if (!(ap_x >= packet.x1_reqArea && ap_x <= packet.x2_reqArea && ap_y >= packet.y1_reqArea && ap_y <= packet.y2_reqArea))
    //         out.println("(ERROR) >> AP is out of requirement Area" + "\tap_x = " + ap_x + "\tap_y = " + ap_y);
    // }

%>

<%= jsonCallback%>
<%--<%= pos%>
<%= imgWidth%>
<%= imgHeight%>
<%= requirementArea%>
<%= scale%>
<%= ap%>--%>
<%--<%= jsonObj%>--%>
