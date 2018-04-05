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
            case "delete": 
                jsonCallback = accountDelete(request); 
                break; 
            case "list": 
                jsonCallback = wallList(request); 
                break;
            case "getOne": 
                jsonCallback = getOneWall(request); 
                break;
            case "modifyOne": 
                jsonCallback = modifyOneWall(request); 
                break;
            default:
                jsonCallback.put("success", false);
                jsonCallback.put("msg", "function not define");
        }
    }
     
%> 

<%!
    
    public static JSONObject accountDelete(HttpServletRequest request) {
        
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
    
            String query = "DELETE FROM account WHERE a_id = ?";

            PreparedStatement preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, request.getParameter("a_id"));
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
    
    public static JSONObject wallList(HttpServletRequest request) {
        
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
    
            String query = "SELECT * FROM wall";

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
                data2.put("w_id", rs.getInt("w_id"));
                data2.put("w_name", rs.getString("w_name"));
                data2.put("w_attenuation_factor", rs.getString("w_attenuation_factor"));
                data2.put("w_color_rgb", rs.getString("w_color_rgb"));
                DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date date = rs.getDate("w_last_update_datetime");
                if(date != null)
                    data2.put("w_last_update_datetime", dateFormat.format(date) );
                else
                    data2.put("w_last_update_datetime", "" );
                date = rs.getDate("w_create_datetime");
                if(date != null)
                    data2.put("w_create_datetime", dateFormat.format(date) );
                else
                    data2.put("w_create_datetime", "" );
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

    public static JSONObject getOneWall(HttpServletRequest request) {
        
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
    
            String query = "SELECT w_id, w_name, w_attenuation_factor, w_color_rgb FROM wall WHERE w_id = ? ORDER BY w_id ASC";

            PreparedStatement preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, request.getParameter("w_id"));
            ResultSet rs = preparedStatement.executeQuery();
            // create the java statement
//            Statement st = con.createStatement();
            rs.last(); 
            int size = rs.getRow();
            if(size==0){
                jsonCallback.put("success", false);
                jsonCallback.put("msg", "wall id error.");
                return jsonCallback;
            }
            rs.beforeFirst();
            // execute the query, and get a java resultset
//            ResultSet rs = st.executeQuery(query);
            
            // iterate through the java resultset
            while (rs.next())
            {
                data.put("w_id", rs.getInt("w_id"));
                data.put("w_name", rs.getString("w_name"));
                data.put("w_attenuation_factor", rs.getString("w_attenuation_factor"));
                data.put("w_color_rgb", rs.getString("w_color_rgb"));
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
    
    public static JSONObject modifyOneWall(HttpServletRequest request) {
        
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
            
            String query = "Update wall SET w_name=?,w_attenuation_factor=?,w_color_rgb=?,w_last_update_datetime=? where w_id=?";

            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = new Date();

            PreparedStatement preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, request.getParameter("w_name"));
            preparedStatement.setString(2, request.getParameter("w_attenuation_factor"));
            preparedStatement.setString(3, request.getParameter("w_color_rgb"));
            preparedStatement.setString(4, dateFormat.format(date));
            preparedStatement.setString(5, request.getParameter("w_id"));
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