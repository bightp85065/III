<%@ page language="java" contentType="text/html; charset=UTF-8"  
    pageEncoding="UTF-8"%>  
<%@ page import="java.sql.*" %>  
<%@ page import="java.io.PrintWriter" %>  
<%@ page import="java.io.StringWriter" %>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>  
<head>  
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">  
<title>Insert title here</title>  
</head>  
<body>  
<%  
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

    // create the java statement
    Statement st = con.createStatement();

    // execute the query, and get a java resultset
    ResultSet rs = st.executeQuery(query);
    
    String ap_name = "default";
    // iterate through the java resultset
    while (rs.next())
    {
        int ap_id = rs.getInt("ap_id");
        ap_name = rs.getString("ap_name");
        boolean ap_radio_enabled = rs.getBoolean("ap_radio_enabled");
        String ap_standard = rs.getString("ap_standard");
        String ap_power = rs.getString("ap_power");
        String ap_channel = rs.getString("ap_channel");
//      Date dateCreated = rs.getDate("date_created");
//        int i=st.executeUpdate("insert into users(first_name,last_name,city_name,email)values('"+first_name+"','"+last_name+"','"+city_name+"','"+email+"')"); out.println("Data is successfully inserted!");
      // print the results
        out.println(ap_name);
        out.println(ap_standard);
        out.println(ap_power);
        out.println(ap_channel);
    }
    st.close();
    
    out.println("sucessss！");  
} catch (Exception e) {
    StringWriter sw = new StringWriter();
    PrintWriter pw = new PrintWriter(sw);
    e.printStackTrace(pw);
    out.println(pw.toString());  
    out.println("<br>");
    out.println(e.toString());
    out.println(e.getMessage());
}
out.println("数据库链接成功！");  
%>  
<%--<%= "ap_name="%>
<%= ap_name%>--%>
</body>  
</html>  