<%@ page language="java" contentType="text/html; charset=UTF-8"  
    pageEncoding="UTF-8"%>

<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONObject" %>

<%@ page import="java.sql.*" %>  
<%@ page import="java.io.PrintWriter" %>  
<%@ page import="java.io.StringWriter" %>  

<%@ page import="java.util.Date" %>  
<%@ page import="java.util.Enumeration" %>  
<%@ page import="java.text.DateFormat" %>  
<%@ page import="java.text.SimpleDateFormat" %>  
<%@ page import="java.time.LocalDateTime" %>  
<%@ page import="java.time.format.DateTimeFormatter" %>  
<%@ page import="java.util.Calendar" %>   
<%@ page import="java.sql.Timestamp" %>  


<%
    
    JSONObject jsonCallback = new JSONObject();
    String func = request.getParameter("func");
    
    if(func==null){
        jsonCallback.put("success", false);
        jsonCallback.put("msg", "function not define");
    }
    else{
        switch(func) {
            case "create": 
                jsonCallback = createAccessPoint(request); 
                break; 
            case "delete": 
                jsonCallback = accessPointDelete(request); 
                break; 
            case "list": 
                jsonCallback = accessPointList(request); 
                break;
            case "getOne": 
                jsonCallback = getOneAccessPoint(request); 
                break;
            case "modifyOne": 
                jsonCallback = modifyOneAccessPoint(request); 
                break;
            default:
                jsonCallback.put("success", false);
                jsonCallback.put("msg", "function not define");
        }
    }
     
%> 

<%!
    
    public static JSONObject createAccessPoint(HttpServletRequest request) {
        
        JSONObject jsonCallback = new JSONObject();
        JSONObject data = new JSONObject();
        Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            // 其中test是我们要链接的数据库，user是数据库用户名，password是数据库密码。    
            // 3306是mysql的端口号，一般是这个    
            // 后面那串长长的参数是为了防止乱码，免去每次都需要在任何语句都加入一条SET NAMES UTF8    
            String url = "jdbc:mysql://localhost:3306/iii?useUnicode=true&characterEncoding=utf8&useOldAliasMetadataBehavior=true";    
            String user = "root";    
            String password = "mitlab";    
            con = DriverManager.getConnection(url, user, password);

            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = new Date();
            
            String query = "INSERT INTO access_point (ap_name, ap_mac_address, ap_ssid, ap_rotation, ap_elevation, ap_range, ap_radio_enabled, ap_40mhz_channels, ap_short_gi, ap_greenfield"
                                            + ", ap_standard, ap_power, ap_channel, ap_secondary_channel, ap_type, ap_species, ap_spatial_streams, ap_image)"
                                            + " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, '')";
            
            PreparedStatement preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, request.getParameter("ap_name"));
            preparedStatement.setString(2, request.getParameter("ap_mac_address"));
            preparedStatement.setString(3, request.getParameter("ap_ssid"));
            preparedStatement.setString(4, request.getParameter("ap_rotation"));
            preparedStatement.setString(5, request.getParameter("ap_elevation"));
            preparedStatement.setString(6, request.getParameter("ap_range"));
            preparedStatement.setString(7, request.getParameter("ap_radio_enabled"));
            preparedStatement.setString(8, request.getParameter("ap_40mhz_channels"));
            preparedStatement.setString(9, request.getParameter("ap_short_gi"));
            preparedStatement.setString(10, request.getParameter("ap_greenfield"));
            preparedStatement.setString(11, request.getParameter("ap_standard"));
            preparedStatement.setString(12, request.getParameter("ap_power"));
            preparedStatement.setString(13, request.getParameter("ap_channel"));
            preparedStatement.setString(14, request.getParameter("ap_secondary_channel"));
            preparedStatement.setString(15, request.getParameter("ap_type"));
            preparedStatement.setString(16, request.getParameter("ap_species"));
            preparedStatement.setString(17, request.getParameter("ap_spatial_streams"));
            int state = preparedStatement.executeUpdate();

            if( state>0 ){
                jsonCallback.put("success", true);
            }
            else{
                jsonCallback.put("success", false);
                jsonCallback.put("data", "create fail");
            }

//            out.println("sucessss！");  
        } catch (Exception e) {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
//            out.println(pw.toString());  
//            out.println("<br>");
//            out.println(e.toString());
//            out.println(e.getMessage());
            jsonCallback.put("success", false);
            jsonCallback.put("msg", e.getMessage());
        }

        return jsonCallback;
    }
    
    public static JSONObject accessPointDelete(HttpServletRequest request) {
        
        JSONObject jsonCallback = new JSONObject();
        JSONArray data = new JSONArray();
        JSONObject data2;
        Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");    
            // 其中test是我们要链接的数据库，user是数据库用户名，password是数据库密码。    
            // 3306是mysql的端口号，一般是这个    
            // 后面那串长长的参数是为了防止乱码，免去每次都需要在任何语句都加入一条SET NAMES UTF8    
            String url = "jdbc:mysql://localhost:3306/iii?useUnicode=true&characterEncoding=utf8&useOldAliasMetadataBehavior=true";    
            String user = "root";    
            String password = "mitlab";    
            con = DriverManager.getConnection(url, user, password);
    
            String query = "DELETE FROM access_point WHERE ap_id = ?";

            PreparedStatement preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, request.getParameter("ap_id"));
            int state = preparedStatement.executeUpdate();
            

            if( state>0 ){
                jsonCallback.put("success", true);
            }
            else{
                jsonCallback.put("success", false);
                jsonCallback.put("data", "delete fail");
            }

//            out.println("sucessss！");  
        } catch (Exception e) {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
//            out.println(pw.toString());  
//            out.println("<br>");
//            out.println(e.toString());
//            out.println(e.getMessage());
            jsonCallback.put("success", false);
            jsonCallback.put("msg2", e.toString());
            jsonCallback.put("msg3", pw.toString());
            jsonCallback.put("msg", e.getMessage());
        }

        return jsonCallback;
    }
    
    public static JSONObject accessPointList(HttpServletRequest request) {
        
        JSONObject jsonCallback = new JSONObject();
        JSONArray data = new JSONArray();
        JSONObject data2;
        Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");    
            // 其中test是我们要链接的数据库，user是数据库用户名，password是数据库密码。    
            // 3306是mysql的端口号，一般是这个    
            // 后面那串长长的参数是为了防止乱码，免去每次都需要在任何语句都加入一条SET NAMES UTF8    
            String url = "jdbc:mysql://localhost:3306/iii?useUnicode=true&characterEncoding=utf8&useOldAliasMetadataBehavior=true";    
            String user = "root";    
            String password = "mitlab";    
            con = DriverManager.getConnection(url, user, password);
    
            String query = "SELECT * FROM access_point";

            PreparedStatement preparedStatement = con.prepareStatement(query);
            ResultSet rs = preparedStatement.executeQuery();
            // create the java statement
//            Statement st = con.createStatement();
            rs.last(); 
            int size = rs.getRow();
            if(size==0){
                jsonCallback.put("success", false);
                jsonCallback.put("msg", "error.");
                return jsonCallback;
            }
            rs.beforeFirst();
            // execute the query, and get a java resultset
//            ResultSet rs = st.executeQuery(query);
            
            // iterate through the java resultset
            while (rs.next())
            {
                data2 = new JSONObject();
                data2.put("ap_id", rs.getInt("ap_id"));
                data2.put("ap_name", rs.getString("ap_name"));
                data2.put("ap_species", rs.getString("ap_species"));
                data2.put("ap_image", rs.getString("ap_image"));
                data2.put("ap_range", rs.getString("ap_range"));
                data2.put("ap_standard", rs.getString("ap_standard"));
                data2.put("ap_power", rs.getString("ap_power"));
                data2.put("ap_mac_address", rs.getString("ap_mac_address"));
                data2.put("ap_ssid", rs.getString("ap_ssid"));
                data.put(data2);
            }
            jsonCallback.put("success", true);
            jsonCallback.put("data", data);
//            st.close();

//            out.println("sucessss！");  
        } catch (Exception e) {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
//            out.println(pw.toString());  
//            out.println("<br>");
//            out.println(e.toString());
//            out.println(e.getMessage());
            jsonCallback.put("success", false);
            jsonCallback.put("msg2", e.toString());
            jsonCallback.put("msg3", pw.toString());
            jsonCallback.put("msg", e.getMessage());
        }

        return jsonCallback;
    }

    public static JSONObject getOneAccessPoint(HttpServletRequest request) {
        
        JSONObject jsonCallback = new JSONObject();
        JSONObject data = new JSONObject();
        Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");    
            // 其中test是我们要链接的数据库，user是数据库用户名，password是数据库密码。    
            // 3306是mysql的端口号，一般是这个    
            // 后面那串长长的参数是为了防止乱码，免去每次都需要在任何语句都加入一条SET NAMES UTF8    
            String url = "jdbc:mysql://localhost:3306/iii?useUnicode=true&characterEncoding=utf8&useOldAliasMetadataBehavior=true";    
            String user = "root";    
            String password = "mitlab";    
            con = DriverManager.getConnection(url, user, password);
    
            String query = "SELECT * FROM access_point WHERE ap_id = ?";

            PreparedStatement preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, request.getParameter("ap_id"));
            ResultSet rs = preparedStatement.executeQuery();
            // create the java statement
//            Statement st = con.createStatement();
            rs.last(); 
            int size = rs.getRow();
            if(size==0){
                jsonCallback.put("success", false);
                jsonCallback.put("msg", "error.");
                return jsonCallback;
            }
            rs.beforeFirst();
            // execute the query, and get a java resultset
//            ResultSet rs = st.executeQuery(query);
            
            // iterate through the java resultset
            while (rs.next())
            {
                data.put("ap_id", rs.getInt("ap_id"));
                data.put("ap_name", rs.getString("ap_name"));
                data.put("ap_species", rs.getString("ap_species"));
                data.put("ap_radio_enabled", rs.getBoolean("ap_radio_enabled"));
                data.put("ap_standard", rs.getString("ap_standard"));
                data.put("ap_power", rs.getString("ap_power"));
                data.put("ap_range", rs.getString("ap_range"));
                data.put("ap_channel", rs.getString("ap_channel"));
                data.put("ap_mac_address", rs.getString("ap_mac_address"));
                data.put("ap_ssid", rs.getString("ap_ssid"));
                data.put("ap_40mhz_channels", rs.getString("ap_40mhz_channels"));
                data.put("ap_secondary_channel", rs.getString("ap_secondary_channel"));
                data.put("ap_spatial_streams", rs.getString("ap_spatial_streams"));
                data.put("ap_short_gi", rs.getBoolean("ap_short_gi"));
                data.put("ap_greenfield", rs.getBoolean("ap_greenfield"));
                data.put("ap_type", rs.getString("ap_type"));
                data.put("ap_rotation", rs.getString("ap_rotation"));
                data.put("ap_elevation", rs.getString("ap_elevation"));
            }
            jsonCallback.put("success", true);
            jsonCallback.put("data", data);
//            st.close();

//            out.println("sucessss！");  
        } catch (Exception e) {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
//            out.println(pw.toString());  
//            out.println("<br>");
//            out.println(e.toString());
//            out.println(e.getMessage());
            jsonCallback.put("success", false);
            jsonCallback.put("msg2", e.toString());
            jsonCallback.put("msg3", pw.toString());
            jsonCallback.put("msg", e.getMessage());
        }

        return jsonCallback;
    }
    
    public static JSONObject modifyOneAccessPoint(HttpServletRequest request) {
        
        JSONObject jsonCallback = new JSONObject();
        JSONArray data = new JSONArray();
        JSONObject data2;
        Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");    
            // 其中test是我们要链接的数据库，user是数据库用户名，password是数据库密码。    
            // 3306是mysql的端口号，一般是这个    
            // 后面那串长长的参数是为了防止乱码，免去每次都需要在任何语句都加入一条SET NAMES UTF8    
            String url = "jdbc:mysql://localhost:3306/iii?useUnicode=true&characterEncoding=utf8&useOldAliasMetadataBehavior=true";    
            String user = "root";    
            String password = "mitlab";    
            con = DriverManager.getConnection(url, user, password);
            int state;
            
            String query = "Update access_point SET ap_name=?, ap_mac_address=?, ap_ssid=?, ap_rotation=?, ap_elevation=?, ap_range=?, ap_radio_enabled=?, ap_40mhz_channels=?, ap_short_gi=?, ap_greenfield=?, ap_standard=?, ap_power=?, ap_channel=?, ap_secondary_channel=?, ap_type=?, ap_species=?, ap_spatial_streams=? where ap_id=?";

            PreparedStatement preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, request.getParameter("ap_name"));
            preparedStatement.setString(2, request.getParameter("ap_mac_address"));
            preparedStatement.setString(3, request.getParameter("ap_ssid"));
            preparedStatement.setString(4, request.getParameter("ap_rotation"));
            preparedStatement.setString(5, request.getParameter("ap_elevation"));
            preparedStatement.setString(6, request.getParameter("ap_range"));
            preparedStatement.setString(7, request.getParameter("ap_radio_enabled"));
            preparedStatement.setString(8, request.getParameter("ap_40mhz_channels"));
            preparedStatement.setString(9, request.getParameter("ap_short_gi"));
            preparedStatement.setString(10, request.getParameter("ap_greenfield"));
            preparedStatement.setString(11, request.getParameter("ap_standard"));
            preparedStatement.setString(12, request.getParameter("ap_power"));
            preparedStatement.setString(13, request.getParameter("ap_channel"));
            preparedStatement.setString(14, request.getParameter("ap_secondary_channel"));
            preparedStatement.setString(15, request.getParameter("ap_type"));
            preparedStatement.setString(16, request.getParameter("ap_species"));
            preparedStatement.setString(17, request.getParameter("ap_spatial_streams"));
            preparedStatement.setString(18, request.getParameter("ap_id"));
            state = preparedStatement.executeUpdate();
            
            if( state>0 ){
                jsonCallback.put("success", true);
            }
            else{
                jsonCallback.put("success", false);
                jsonCallback.put("data", "update fail");
            }

//            out.println("sucessss！");  
        } catch (Exception e) {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
//            out.println(pw.toString());  
//            out.println("<br>");
//            out.println(e.toString());
//            out.println(e.getMessage());
            jsonCallback.put("success", false);
            jsonCallback.put("msg2", e.toString());
            jsonCallback.put("msg3", pw.toString());
            jsonCallback.put("msg", e.getMessage());
        }

        return jsonCallback;
    }

%>

<%= jsonCallback%>