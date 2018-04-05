<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="iii.func.*" %>

<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONObject" %>

<%
    int state_wall = 255;

    // int test[][] = phaseJSONandDrawMAP(640, 480, state_wall);

    JSONObject obj = new JSONObject();
    obj.put("name", "mkyong.com");
    obj.put("age", new Integer(100));


    JSONArray arrayObj = new JSONArray();
    arrayObj.put("name :");
    arrayObj.put("Deepa");
    arrayObj.put("Reg No");
    arrayObj.put(123);
    arrayObj.put("Mark");
    arrayObj.put(new Double(90));
    arrayObj.put("City");
    arrayObj.put("Chennai");


%>

<html>

<body>
JSON Array : <%= arrayObj %>
JSON Object: <%= obj %>

</body>

</html>
</programlisting>
