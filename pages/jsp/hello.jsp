<%@ page import="javax.imageio.ImageIO" %>


<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONObject" %>

<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.awt.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>
<%@ page import="static java.lang.StrictMath.cos" %>
<%@ page import="static java.lang.StrictMath.sin" %>

<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>


<%
    String imgWidth = request.getParameter("imgWidth");
    String imgHeight = request.getParameter("imgHeight");
//    requirementArea
//        if (author != null && !author.equals(""))) {
%>
<%= imgWidth %>
<%= imgHeight %>
