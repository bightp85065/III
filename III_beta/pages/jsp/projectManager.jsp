<%@ page import="java.io.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.zip.*" %>

<%@ page import="java.nio.file.Files" %>

<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONObject" %>

<%@ page import="com.mitlab.DataPacket" %>
<%@ page import="com.mitlab.JSONparser" %>



<%!
    private static void copyFileUsingStream(File source, File dest) throws IOException {
        InputStream is = null;
        OutputStream os = null;
        try {
            is = new FileInputStream(source);
            os = new FileOutputStream(dest);
            byte[] buffer = new byte[1024];
            int length;
            while ((length = is.read(buffer)) > 0) {
                os.write(buffer, 0, length);
            }
        } finally {
            is.close();
            os.close();
        }
    }
%>


<%!

    public void packin(File projFile, String... pathName) {
        ZipOutputStream out = null;
        try {
            FileOutputStream fileOutputStream = new FileOutputStream(projFile);
            CheckedOutputStream cos = new CheckedOutputStream(fileOutputStream,
                    new CRC32());
            out = new ZipOutputStream(cos);
            String basedir = "";
            for (int i=0;i<pathName.length;i++){
                packin(new File(pathName[i]), out, basedir);
            }
            out.close();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

%>

<%!
    public void packin(String srcPathName, File projFile) {
        File file = new File(srcPathName);
        if (!file.exists())
            throw new RuntimeException(srcPathName + " is not exist！ << ProjectManager");
        try {
            FileOutputStream fileOutputStream = new FileOutputStream(projFile);
            CheckedOutputStream cos = new CheckedOutputStream(fileOutputStream,
                    new CRC32());
            ZipOutputStream out = new ZipOutputStream(cos);
            String basedir = "";
            packin(file, out, basedir);
            out.close();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
%>

<%!
    private void packin(File file, ZipOutputStream out, String basedir) {
        /* determine file or dir */
        if (file.isDirectory()) {
            System.out.println("Compress：" + basedir + file.getName());
            this.packinDirectory(file, out, basedir);
        } else {
            System.out.println("Compress：" + basedir + file.getName());
            this.packinFile(file, out, basedir);
        }
    }
%>

<%!
    /** compress dir */
    private void packinDirectory(File dir, ZipOutputStream out, String basedir) {
        if (!dir.exists())
            return;

        File[] files = dir.listFiles();
        for (int i = 0; i < files.length; i++) {
            packin(files[i], out, basedir + dir.getName() + "/");
        }
    }
%>

<%!
    /** compress one file */
    private void packinFile(File file, ZipOutputStream out, String basedir) {
        if (!file.exists()) {
            return;
        }
        try {
            BufferedInputStream bis = new BufferedInputStream(
                    new FileInputStream(file));
            ZipEntry entry = new ZipEntry(basedir + file.getName());
            out.putNextEntry(entry);
            int count;
            byte data[] = new byte[8192];
            while ((count = bis.read(data, 0, 8192)) != -1) {
                out.write(data, 0, count);
            }
            bis.close();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
%>


<%

	JSONObject jsonCallback = new JSONObject();
	JSONObject jsonObj = new JSONObject();


	Boolean readOrSave = Boolean.parseBoolean(request.getParameter("readOrSave"));


	// ProjectManager projectManager = new ProjectManager();
	DataPacket dataPacket = new DataPacket();

	String project_export_folder_path = "/opt/tomcat/webapps/III/resources/projects/" + dataPacket.project_time_stamp;
	String project_export_path_fname = "/opt/tomcat/webapps/III/resources/projects/" + "Site_survey_Project_" + dataPacket.project_time_stamp + ".fu3i";
    
    String target_project_file = request.getParameter("targetFile");

    String project_name = "Site_survey_Project_" + dataPacket.project_time_stamp + ".fu3i"; 

    // String workingDir = project_export_folder_path;
    // File dir_file = new File(workingDir);	      
    // dir_file.mkdir();


	if(readOrSave) { //true for read
        // unzipFilePath = projectManager.unPackin(project_export_path_fname, "/opt/tomcat/webapps/III/resources/projects/unpack");
        // ***
        String unpackFilePath = "";
        String unpackImagePath = "";
        String unpackImageName = "";
        byte[] buffer = new byte[1024];

        try{

            //create output directory is not exists
            File folder = new File("/opt/tomcat/webapps/III/resources/projects/unpack");
            if(!folder.exists()){
                folder.mkdir();
            }

            //get the zip file content
            ZipInputStream zis =
                    new ZipInputStream(new FileInputStream("/opt/tomcat/webapps/III/resources/uploadFile/"+ target_project_file));
            //get the zipped file list entry
            ZipEntry ze = zis.getNextEntry();

            while(ze!=null){

                String fileName = ze.getName();
                File newFile = new File("/opt/tomcat/webapps/III/resources/projects/unpack" + File.separator + fileName);

                System.out.println("ProjectManager >> file unpack : "+ newFile.getAbsoluteFile());


                if (fileName.contains("json")) {
                    System.out.printf("ProjectManager >> unpack >> JSON fileName = %s\n", fileName);
                    unpackFilePath = String.valueOf(newFile.getAbsoluteFile());
                    System.out.printf("ProjectManager >> unpack >> filePath = %s\n", unpackFilePath);

                }

                if (fileName.contains("jpg") | fileName.contains("png")| fileName.contains("bmp")| fileName.contains("gif")) {
                    System.out.printf("ProjectManager >> unpack >> Image fileName = %s\n", fileName);
                    unpackImageName = fileName;
                    unpackImagePath = String.valueOf(newFile.getAbsoluteFile());
                    System.out.printf("ProjectManager >> unpack >> ImagePath = %s\n", unpackImagePath);

                }



                //create all non exists folders
                //else you will hit FileNotFoundException for compressed folder
                new File(newFile.getParent()).mkdirs();

                FileOutputStream fos = new FileOutputStream(newFile);

                int len;
                while ((len = zis.read(buffer)) > 0) {
                    fos.write(buffer, 0, len);
                }

                fos.close();
                ze = zis.getNextEntry();
            }

            zis.closeEntry();
            zis.close();

            System.out.println("Done");

        } catch(IOException ex) {
            ex.printStackTrace();
        }
        // ***
        
        jsonCallback.put("project_json_path", unpackFilePath); // return json path
        jsonCallback.put("project_image_path", unpackImagePath); // return image path
        jsonCallback.put("project_image_name", unpackImageName); // return image name

        JSONparser jsonParser = new JSONparser();
        JSONObject jsonObject_unpack = null;
        jsonObject_unpack = jsonParser.read_jsonfile(unpackFilePath);
        jsonCallback.put("jsonObject_unpack", jsonObject_unpack);


	}
	else { // false for save

    // add new lines
    int imgWidth  = Integer.valueOf(request.getParameter("imgWidth"));
    int imgHeight = Integer.valueOf(request.getParameter("imgHeight"));

    JSONArray drawLines	= new JSONArray(request.getParameter("drawLines"));
    JSONArray drawStraightLines	= new JSONArray(request.getParameter("drawStraightLines"));
    JSONArray drawSquares = new JSONArray(request.getParameter("drawSquares"));
    JSONArray drawSquaresForElevator = new JSONArray(request.getParameter("drawSquaresForElevator"));
    JSONArray drawUplinkPoint = new JSONArray(request.getParameter("drawUplinkPoint"));
    JSONArray drawSensorNode = new JSONArray(request.getParameter("drawSensorNode"));
    JSONArray drawRegionClassifications = new JSONArray(request.getParameter("drawRegionClassifications"));
    JSONArray drawRegionClassificationsTemp = new JSONArray(request.getParameter("drawRegionClassificationsTemp"));
    JSONArray drawRequirementAreaPolygonals = new JSONArray(request.getParameter("drawRequirementAreaPolygonals"));
    JSONArray drawRequirementAreaPolygonalsTemp = new JSONArray(request.getParameter("drawRequirementAreaPolygonalsTemp"));
    JSONArray sensorNode = new JSONArray(request.getParameter("sensorNode"));



    String deploymentType = request.getParameter("deploymentType");
    String deployApType = request.getParameter("deployApType");
    String nowPage = request.getParameter("nowPage");

    JSONArray deployPara = new JSONArray(request.getParameter("deployPara"));

    JSONObject ap               = new JSONObject(request.getParameter("ap"));
    double scale  = Double.parseDouble(request.getParameter("scale"));



    // add new lines
    jsonObj.put("imgWidth", imgWidth);
    jsonObj.put("imgHeight", imgHeight);
    jsonObj.put("scale", scale);
    jsonObj.put("ap", ap);

    jsonObj.put("drawLines", drawLines);
    jsonObj.put("drawStraightLines", drawStraightLines);
    jsonObj.put("drawSquares", drawSquares);
    jsonObj.put("drawSquaresForElevator", drawSquaresForElevator);
    jsonObj.put("drawUplinkPoint", drawUplinkPoint);
    jsonObj.put("drawSensorNode", drawSensorNode);
    jsonObj.put("drawRegionClassifications", drawRegionClassifications);
    jsonObj.put("drawRegionClassificationsTemp", drawRegionClassificationsTemp);
    jsonObj.put("deploymentType", deploymentType);
    jsonObj.put("deployApType", deployApType);
    jsonObj.put("nowPage", nowPage);
    jsonObj.put("deployPara", deployPara);
    jsonObj.put("drawRequirementAreaPolygonals", drawRequirementAreaPolygonals);
    jsonObj.put("drawRequirementAreaPolygonalsTemp", drawRequirementAreaPolygonalsTemp);
    jsonObj.put("sensorNode", sensorNode);



    // projectManager.initPackin(dataPacket, jsonObj);
    // methods below

    int BUFFER = 8192;

    File projFile;
    
    String pathName = project_export_path_fname;

    projFile = new File(pathName);

    System.out.printf("ProjectManager >> projFile = %s\n", projFile);

    String workingDir = project_export_folder_path;

    File dir_file = new File(workingDir);
    dir_file.mkdir();

    // temp: For Debug
    String tempJSONFileName = workingDir + "/" + dataPacket.project_time_stamp + "_proj.json";
    try {
        FileWriter fileWriter = new FileWriter(tempJSONFileName);
        fileWriter.write(jsonObj.toString());
        fileWriter.flush();
    } catch (Exception e) {
        e.printStackTrace();
    }



    String uploadMapImage = request.getParameter("uploadMapImage");
    
    jsonCallback.put("uploadMapImage", uploadMapImage);
    // String nullString = "";
    if (!uploadMapImage.equals("")) {

        // move jpg to my workingdir
        // File sourceFile = new File("/opt/tomcat/webapps/III/resources/mapImage" + File.separator + uploadMapImage);
        // File targetFile = new File(project_export_folder_path + File.separator + uploadMapImage);
        // jsonCallback.put("sourceFile", "/opt/tomcat/webapps/III/resources/mapImage" + File.separator + uploadMapImage);
        // jsonCallback.put("targetFile", project_export_folder_path + File.separator + uploadMapImage);

        String sourceIMG = "/opt/tomcat/webapps/III/resources/mapImage" + File.separator + uploadMapImage;

        packin(projFile, project_export_folder_path, sourceIMG);
        // File targetFile = new File("/opt/tomcat/webapps/III/resources/projects/2018-04-21_10-27-09" + File.separator + "uploadMapImage");
        // copyFileUsingStream(sourceFile, targetFile);
        // jsonCallback.put("uploadMapImage", uploadMapImage);
        jsonCallback.put("uploadMapImageisNull", "Exist");
    } else {
        
        jsonCallback.put("uploadMapImageisNull", "Null");
        // jsonCallback.put("uploadMapImage", uploadMapImage);
        packin(project_export_folder_path, projFile);
    
    }

    


    // projectManager.packin("/opt/tomcat/webapps/III/resources/projects/2018-04-19_13-35-44");

    jsonCallback.put("project_export_folder_path", project_export_folder_path);
    jsonCallback.put("project_file_path", project_export_path_fname); // return project file path
    jsonCallback.put("project_name", project_name);



	}

%>

<%= jsonCallback%>