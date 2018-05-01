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
<%@ page import="com.mitlab.MovedApDataPacket" %>
<%@ page import="com.mitlab.EXCELwriter" %>
<%@ page import="com.mitlab.FunctionPack" %>
<%@ page import="com.mitlab.MovedApHeatmap" %>
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

    // out.println(jsonObj.toString(4));
    // ----------------------------------- ONLY EXIST IN JSP ----------------------------------- //

    // ===== COPY TO JSP : START ===== //
    MovedApDataPacket movedPacket = new MovedApDataPacket();
    MovedApHeatmap movedApHeatmap = new MovedApHeatmap();
    FunctionPack  functionPack  = new FunctionPack();
    JSONparser    jsonParser    = new JSONparser();

    // ArrayList<Integer>  = new ArrayList<>();
    long imageWeight_func_time_start, imageWeight_func_time_end, imageWeight_func_elapsed_time;
    JSONObject jsonObject_wall_info = null;
    JSONObject jsonObject_indr_img = new JSONObject();
    JSONObject jsonObject_program_state = new JSONObject();
    // Point deployed_AP_pos = new Point();

    jsonObject_wall_info = functionPack.get_wallList_fromDB();
    movedApHeatmap.generate_wall_info(movedPacket, jsonObject_wall_info);

    // out.println(jsonObject_wall_info.toString(4));
    // AP setting
    // packet.apType = "AP";   // AP type representing "AP" or "Mesh"
    movedPacket.apType = jsonObj.getString("apType").toUpperCase();   // AP type representing "AP" or "Mesh"

    // AP Image file name and path
    movedPacket.apImg_fname = sensorNodeImage;
    movedPacket.apImg_path = Paths.get(movedPacket.dst_img_output_path, movedPacket.apImg_fname);                                 // folder path with file name
    movedPacket.apImg_path_fname = movedPacket.apImg_path.toString();

    jsonObject_indr_img = new JSONObject(jsonObj, JSONObject.getNames(jsonObj));
    movedApHeatmap.initialize_all_parameters(movedPacket, jsonObject_indr_img);                          // Initialize all parameters in DataPacket.java
    movedApHeatmap.generate_image_array(movedPacket, functionPack, jsonObject_indr_img);
    movedApHeatmap.generate_requirement_area_image_array(movedPacket, functionPack, jsonObject_indr_img);
    movedApHeatmap.generate_subRegion_parameters(movedPacket, jsonObject_indr_img);                      // subregion parameter

    // Transform img_arr to Mat format
    movedPacket.img = functionPack.array_to_mat(movedPacket.img_arr, movedPacket.img);
    movedPacket.img_ori_clone = functionPack.array_to_mat(movedPacket.img_arr_ori_clone, movedPacket.img_ori_clone);
    movedApHeatmap.MovedApHeatmapDraw(movedPacket, functionPack, jsonObject_indr_img);
    // out.println(jsonObject_indr_img.toString(4));
    // Store Data for excel exporting
    movedPacket.json_content_sensorNode_power = jsonParser.getParameterJSON(jsonObject_indr_img, 6);
    movedPacket.json_content_sensorNode_coodinate = jsonParser.getCoordinateJSON(jsonObject_indr_img, 0);
    movedPacket.json_content_uplinkPoint_coodinate = jsonParser.getCoordinateJSON(jsonObject_indr_img, 1);
    // out.println("map_scale = " + movedPacket.map_scale);
    // Exporting excel
    EXCELwriter writer = new EXCELwriter();
    writer.extraFunction_export(movedPacket, movedPacket.excel_export_path_fname);
    // ===== Return AP information to front-end part ===== //
    jsonCallback.put("heatmap_fname", movedPacket.movedHeatmap_fname);                       // output filename of heatmap image
    jsonCallback.put("ap_heatmap_fname", movedPacket.movedAPHeatmap_fname);                  // output filename of heatmap image
    // jsonCallback.put("sensorNode_Image_path", movedPacket.sensorNode_fname);
    jsonCallback.put("excel_report", movedPacket.excel_export_path_name);                    // output filename of report in excel format
    // out.println("movedHeatmap_fname = " + movedPacket.movedHeatmap_fname);
    // out.println("movedAPHeatmap_fname = " + movedPacket.movedAPHeatmap_fname);
    // out.println("excel_export_path_name = " + movedPacket.excel_export_path_name);
    // // ----- Add deployed AP positions to json ----- //
    for(int i=0; i<movedPacket.output_ap_pos.size(); i++){
        JSONObject ap_pos_info_obj = new JSONObject();
        Point deployed_AP_pos = movedPacket.output_ap_pos.get(i);
        // out.println("idx = " + i + "\tap_x = " + deployed_AP_pos.x + "\tap_y = " + deployed_AP_pos.y);
        ap_pos_info_obj.put("x", deployed_AP_pos.x);
        ap_pos_info_obj.put("y", deployed_AP_pos.y);
        ap_pos_info_arr.put(ap_pos_info_obj);                                            // Add jsonObject to jsonArray
    }
    jsonCallback.put("Deployed_AP_pos", ap_pos_info_arr);                                // output RSSI value of every pixel
    JSONArray sensorNodeRSSIArr = new JSONArray();
    if(movedPacket.sensorNodeRSSI.length() != 0)
        sensorNodeRSSIArr = movedPacket.sensorNodeRSSI.getJSONArray("sensorNodeRSSI");
    jsonCallback.put("sensorNodeRSSI", sensorNodeRSSIArr);                                // output RSSI value of every pixel
    // out.println(sensorNodeRSSIArr.toString(4));
    // ----- Add RSSI information to json ----- //
    jsonCallback.put("indr_RSSI_information", movedPacket.apMoved_rssi_output_arr);          // output RSSI value of every pixel
    // out.println(movedPacket.apMoved_rssi_output_arr);
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
