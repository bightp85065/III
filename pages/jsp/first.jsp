<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONObject" %>

<%@ page import="java.io.*" %>
<%@ page import="java.awt.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.awt.Point" %>
<%@ page import="java.lang.Math" %>
<%@ page import="java.nio.file.Path" %>
<%@ page import="java.nio.file.Paths" %>
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
<%@ page import="com.mitlab.EXCELwriter" %>
<%@ page import="com.mitlab.FunctionPack" %>
<%@ page import="com.mitlab.AlgorithmPack" %>
<%@ page import="com.mitlab.AlgorithmPatch" %>

<%-- <%@ page import="org.bytedeco.javacv.*" %>
<%@ page import="org.bytedeco.javacpp.*" %>
<%@ page import="org.bytedeco.javacpp.indexer.*" %>
<%@ page import="org.bytedeco.javacpp.opencv_core.*" %>
<%@ page import="org.bytedeco.javacpp.opencv_highgui.*" %>
<%@ page import="org.bytedeco.javacpp.opencv_imgcodecs.*" %> --%>

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
    // JSONObject ap_pos_info_obj  = new JSONObject();
    JSONObject jsonCallback     = new JSONObject();
    String scale  = request.getParameter("scale");
    // double scale  = Double.parseDouble(request.getParameter("scale"));
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

    // ----------------------------------- ONLY EXIST IN JSP ----------------------------------- //

    // ===== COPY TO JSP : START ===== //
    JSONparser    jsonParser    = new JSONparser();
    DataPacket    packet        = new DataPacket();
    AlgorithmPack algorithmPack = new AlgorithmPack();
    AlgorithmPatch algorithmPatch = new AlgorithmPatch();
    FunctionPack  functionPack  = new FunctionPack();
    // ArrayList<Integer>  = new ArrayList<>();
    long imageWeight_func_time_start, imageWeight_func_time_end, imageWeight_func_elapsed_time;
    JSONObject jsonObject_wall_info = null;
    JSONObject jsonObject_indr_img = new JSONObject();
    JSONObject jsonObject_program_state = new JSONObject();
    // Point deployed_AP_pos = new Point();

    jsonObject_wall_info = functionPack.get_wallList_fromDB();
    jsonParser.generate_wall_info(packet, jsonObject_wall_info);

    // AP setting
    // packet.apType = "AP";   // AP type representing "AP" or "Mesh"
    packet.apType = jsonObj.getString("apType").toUpperCase();   // AP type representing "AP" or "Mesh"

    // AP Image file name and path
    packet.apImg_fname = sensorNodeImage;
    packet.apImg_path = Paths.get(packet.dst_img_output_path, packet.apImg_fname);                                 // folder path with file name
    packet.apImg_path_fname = packet.apImg_path.toString();

        // out.println(packet.AP_dict.toString(4));
    // out.println(jsonObject_wall_info.toString(4));
    // out.println(packet.wall_dict.toString(4));

    // out.println("\n------------------------------------------------------------------");
    // out.println("JsonObject parameters     >> apType = " + jsonObj.getDouble("apType"));
    // out.println("JsonObject parameters     >> scale = " + jsonObj.getDouble("scale"));
    // out.println("JsonObject parameters     >> apAndApRange = " + jsonObj.getString("apAndApRange"));
    // out.println("JsonObject parameters     >> meshAndSSNRange = " + jsonObj.getString("meshAndSSNRange"));

    // jsonObject_indr_img = jsonObj;
    jsonObject_indr_img = new JSONObject(jsonObj, JSONObject.getNames(jsonObj));
    jsonParser.initialize_all_parameters(packet, jsonObject_indr_img);                          // Initialize all parameters in DataPacket.java
    jsonParser.generate_image_array(packet, functionPack, jsonObject_indr_img);
    jsonParser.generate_requirement_area_image_array(packet, functionPack, jsonObject_indr_img);
    jsonParser.generate_subRegion_parameters(packet, jsonObject_indr_img);                      // subregion parameter

    // out.println("Paramaters (AP) >> AP radius = " + packet.radius);
    // out.println("Paramaters (AP) >> AP diameter = " + packet.json_content_apIntensity);
    // out.println("Paramaters (AP) >> AP heigtht = " + packet.ap_z_coordinate);

    // Transform img_arr to Mat format
    packet.img = functionPack.array_to_mat(packet.img_arr, packet.img);
    packet.img_ori_clone = functionPack.array_to_mat(packet.img_arr_ori_clone, packet.img_ori_clone);

    packet.mapArray = algorithmPatch.genMapArray(packet, jsonObject_indr_img, packet.state_wall, packet.state_wall, packet.state_wall);
    packet.middlization_elected_points = algorithmPatch.middlization(packet);

    algorithmPack.apDeployAlgorithm(packet, functionPack, jsonParser, jsonObject_indr_img);

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
    jsonCallback.put("ap_heatmap_fname", packet.ap_heatmap_fname);                            // output filename of heatmap image
    // jsonCallback.put("indr_img_fname", packet.indr_img_fname);                          // output filename of indoor image
    // jsonCallback.put("indr_heatmap_fname", packet.indr_heatmap_fname);                  // output filename of indoor image combining heatmap
    jsonCallback.put("sensorNode_Image_path", packet.sensorNode_fname);                 // output filename of sensorNode Image
    jsonCallback.put("excel_report", packet.excel_export_path_name);                    // output filename of report in excel format

    // debug
    // int wall_key_int;
    // String wall_key_string;
    // Iterator<String> wall_dict_keys;

    // ----- Add deployed AP positions to json ----- //
    for(int i=0; i<packet.output_ap_pos.size(); i++){
        JSONObject ap_pos_info_obj = new JSONObject();
        Point deployed_AP_pos = packet.output_ap_pos.get(i);
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
    
    JSONArray sensorNodeRSSIArr = new JSONArray();
    if(packet.sensorNodeRSSI.length() != 0)
        sensorNodeRSSIArr = packet.sensorNodeRSSI.getJSONArray("sensorNodeRSSI");
    jsonCallback.put("sensorNodeRSSI", sensorNodeRSSIArr);                                // output RSSI value of every pixel

    // ----- Add RSSI information to json ----- //
    // for(int _row=packet.y1_reqArea; _row<packet.y2_reqArea; _row++){
    //     for(int _col=packet.x1_reqArea; _col<packet.x2_reqArea; _col++){
    //        // if(packet.signal_stength_output_arr[_row][_col] < packet.signal_strength_thre)
    //        out.println(packet.signal_stength_output_arr[_row][_col]);
    //     }
    // }
    jsonCallback.put("indr_RSSI_information", packet.img_signal_rssi_output_arr);          // output RSSI value of every pixel
    // jsonCallback.put("indr_RSSI_information", packet.signal_stength_output_arr);          // output RSSI value of every pixel


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
    System.gc();
%>

<%= jsonCallback%>
<%--<%= pos%>
<%= imgWidth%>
<%= imgHeight%>
<%= requirementArea%>
<%= scale%>
<%= ap%>--%>
<%--<%= jsonObj%>--%>
