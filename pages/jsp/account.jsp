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
                jsonCallback = createAccount(request); 
                break; 
            case "login": 
                jsonCallback = login(request); 
                break; 
            case "loginByToken": 
                jsonCallback = loginByToken(request); 
                break; 
            case "delete": 
                jsonCallback = accountDelete(request); 
                break; 
            case "list": 
                jsonCallback = accountList(request); 
                break;
            case "getOne": 
                jsonCallback = getOneAccount(request); 
                break;
            case "modifyOne": 
                jsonCallback = modifyOneAccount(request); 
                break;
            case "login2": 
                jsonCallback = login2(request);
                break;
            default:
                jsonCallback.put("success", false);
                jsonCallback.put("msg", "function not define");
        }
    }
     
%> 

<%!
    
    public static String randomAlphaNumeric(int count) {
        String ALPHA_NUMERIC_STRING = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder builder = new StringBuilder();
        while (count-- != 0) {
            int character = (int)(Math.random()*ALPHA_NUMERIC_STRING.length());
            builder.append(ALPHA_NUMERIC_STRING.charAt(character));
        }
        return builder.toString();
    }

    public static JSONObject createAccount(HttpServletRequest request) {
        
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
            
            String query = "INSERT INTO account (a_account, a_password, a_name, a_create_datetime, a_role) VALUES (?, ?, ?, ?, ?)";
            
            PreparedStatement preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, request.getParameter("a_account"));
            preparedStatement.setString(2, request.getParameter("a_password"));
            preparedStatement.setString(3, request.getParameter("a_name"));
            preparedStatement.setString(4, dateFormat.format(date));
            preparedStatement.setString(5, request.getParameter("a_role"));
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

    public static JSONObject login(HttpServletRequest request) {
        
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
    
            String query = "SELECT a_id, a_account, a_name FROM account WHERE a_account = ? and a_password = ?";

            PreparedStatement preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, request.getParameter("a_account"));
            preparedStatement.setString(2, request.getParameter("a_password"));
            ResultSet rs = preparedStatement.executeQuery();
            // create the java statement
//            Statement st = con.createStatement();
            rs.last(); 
            int size = rs.getRow();
            if(size==0){
                jsonCallback.put("success", false);
                jsonCallback.put("msg", "account or password error.");
                return jsonCallback;
            }
            rs.beforeFirst();
            // execute the query, and get a java resultset
//            ResultSet rs = st.executeQuery(query);
            int a_id=0;
            // iterate through the java resultset
            while (rs.next())
            {
                data2 = new JSONObject();
                a_id = rs.getInt("a_id");
                
                data2.put("a_id", rs.getInt("a_id"));
                data2.put("a_account", rs.getString("a_account"));
                data2.put("a_name", rs.getString("a_name"));
                data.put(data2);
            }
            jsonCallback.put("success", true);
            jsonCallback.put("data", data);
            
            
            String au_token = randomAlphaNumeric(20);
            jsonCallback.put("au_token", au_token);
            
            
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = new Date();
            String aid = Integer.toString(a_id);
            ///////////////////////////////test
            query = "INSERT INTO authenticate (au_a_id, au_token, au_effect_datetime) VALUES (?, ?, ?)";
            
            preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, aid);
            preparedStatement.setString(2, au_token);
            preparedStatement.setString(3, dateFormat.format(date));
            int state = preparedStatement.executeUpdate();

            if( state==0 ){
                jsonCallback.put("success", false);
                jsonCallback.put("data", "create token fail");
                return jsonCallback;
            }
            
            
            
            
            
            
            query = "Update account SET a_last_datetime=? where a_id=?";
            PreparedStatement preparedStatement2 = con.prepareStatement(query);
            preparedStatement2.setString(1, dateFormat.format(date));
            preparedStatement2.setString(2, aid);
            state = preparedStatement2.executeUpdate();

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

    public static JSONObject loginByToken(HttpServletRequest request) {
        
        JSONObject jsonCallback = new JSONObject();
        //JSONArray data = new JSONArray();
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
            
            String query = "SELECT a.a_id, a.a_account, a.a_name, a.a_role FROM account as a JOIN authenticate as au on a.a_id=au.au_a_id WHERE au.au_token = ?";

            PreparedStatement preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, request.getParameter("token"));
            ResultSet rs = preparedStatement.executeQuery();
            // create the java statement
//            Statement st = con.createStatement();
            rs.last(); 
            int size = rs.getRow();
            if(size==0){
                jsonCallback.put("success", false);
                jsonCallback.put("msg", "token error.");
                return jsonCallback;
            }
            rs.beforeFirst();
            // execute the query, and get a java resultset
//            ResultSet rs = st.executeQuery(query);
            // iterate through the java resultset
            data2 = new JSONObject();

            while (rs.next())
            {
                
                
                data2.put("a_id", rs.getInt("a_id"));
                data2.put("a_account", rs.getString("a_account"));
                data2.put("a_name", rs.getString("a_name"));
                data2.put("a_role", rs.getString("a_role"));
            }
            jsonCallback.put("success", true);
            jsonCallback.put("data", data2);
            
            
            String au_token = randomAlphaNumeric(20);
            jsonCallback.put("au_token", au_token);
            
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
    
    public static JSONObject accountList(HttpServletRequest request) {
        
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
    
            String query = "SELECT * FROM account";

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
                data2.put("a_id", rs.getInt("a_id"));
                data2.put("a_account", rs.getString("a_account"));
                data2.put("a_name", rs.getString("a_name"));
                data2.put("a_role", rs.getString("a_role"));
//                data2.put("a_last_datetime", rs.getString("a_last_datetime") );
//                data2.put("a_create_datetime", rs.getString("a_create_datetime") );
                DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date date = rs.getDate("a_last_datetime");
                if(date != null)
                    data2.put("a_last_datetime", dateFormat.format(date) );
                else
                    data2.put("a_last_datetime", "" );
                date = rs.getDate("a_create_datetime");
                if(date != null)
                    data2.put("a_create_datetime", dateFormat.format(date) );
                else
                    data2.put("a_create_datetime", "" );
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

    public static JSONObject getOneAccount(HttpServletRequest request) {
        
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
    
            String query = "SELECT a_id, a_account, a_name, a_role FROM account WHERE a_id = ?";

            PreparedStatement preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, request.getParameter("a_id"));
            ResultSet rs = preparedStatement.executeQuery();
            // create the java statement
//            Statement st = con.createStatement();
            rs.last(); 
            int size = rs.getRow();
            if(size==0){
                jsonCallback.put("success", false);
                jsonCallback.put("msg", "account id error.");
                return jsonCallback;
            }
            rs.beforeFirst();
            // execute the query, and get a java resultset
//            ResultSet rs = st.executeQuery(query);
            
            // iterate through the java resultset
            while (rs.next())
            {
                data.put("a_id", rs.getInt("a_id"));
                data.put("a_account", rs.getString("a_account"));
                data.put("a_name", rs.getString("a_name"));
                data.put("a_role", rs.getString("a_role"));
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
    
    public static JSONObject modifyOneAccount(HttpServletRequest request) {
        
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
            if(request.getParameter("a_password")!=null){
                String query = "Update account SET a_account=?,a_name=?,a_password=?,a_role=? where a_id=?";
            
                PreparedStatement preparedStatement = con.prepareStatement(query);
                preparedStatement.setString(1, request.getParameter("a_account"));
                preparedStatement.setString(2, request.getParameter("a_name"));
                preparedStatement.setString(3, request.getParameter("a_password"));
                preparedStatement.setString(4, request.getParameter("a_role"));
                preparedStatement.setString(5, request.getParameter("a_id"));
                state = preparedStatement.executeUpdate();
            }
            else{
                String query = "Update account SET a_account=?,a_name=?,a_role=? where a_id=?";
            
                PreparedStatement preparedStatement = con.prepareStatement(query);
                preparedStatement.setString(1, request.getParameter("a_account"));
                preparedStatement.setString(2, request.getParameter("a_name"));
                preparedStatement.setString(3, request.getParameter("a_role"));
                preparedStatement.setString(4, request.getParameter("a_id"));
                state = preparedStatement.executeUpdate();
            }
            

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
    
    public static JSONObject login2(HttpServletRequest request) {
        
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
            
            String query = "INSERT INTO ip (ip_value, ip_page, ip_create_datetime) VALUES (?, ?, ?)";
            
            PreparedStatement preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, request.getRemoteHost());
            preparedStatement.setString(2, request.getHeader("referer"));
            preparedStatement.setString(3, dateFormat.format(date));
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

%>

<%= jsonCallback%>
