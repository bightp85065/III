<%@page import="java.io.IOException;" %>
<%@page import="java.io.PrintWriter;" %>
<%@page import="java.time.LocalDate;" %>
<%@page import="java.time.LocalTime;" %>
<%@page import="java.time.format.DateTimeFormatter;" %>
<%@page import="java.util.ArrayList;" %>
<%@page import="java.util.List;" %>
<%@page import="java.util.UUID;" %>

  
<%

    HttpSession session=request.getSession();
    List<String> list=(List<String>)session.getAttribute("files");
    if(list==null){
        list=new ArrayList<String>();
    }    
    
    try {
        String desc=request.getParameter("desc");
        Part part=request.getPart("file");
        String name=part.getHeader("content-disposition");
        //System.out.println(desc);//
        
        String root=request.getServletContext().getRealPath("/upload");
        System.out.println("PATH："+root);
        
        String str=name.substring(name.lastIndexOf("."), name.length()-1);
        System.out.println("PATH："+str);
        
        String fname=UUID.randomUUID().toString()+str;
        list.add(fname);
        session.setAttribute("files", list);
        
        String filename=root+"\\"+fname;
        System.out.println("PATH："+filename);
        
        part.write(filename);
        
        request.setAttribute("info", "Success");
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("info", "Fail");
    }
    
    request.getRequestDispatcher("/upload.jsp").forward(request, response);


%>