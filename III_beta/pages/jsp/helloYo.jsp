<!-- <%@ page import="com.lowagie.itext.Document" %> -->
<%--<%@ page import="json.JSONArray.java" %>
<%@ page import="json.JSONException.java" %>
<%@ page import="json.JSONObject.java" %>--%>
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



<%
    

        int state_wall = 255;

        int test[][] = phaseJSONandDrawMAP(640, 480, state_wall);

//        int state_walked_non = 0;
//        int state_walked_x = 1;
//        int state_walked_y = 2;
//        int state_walked_both = 3;
//
//        int state_border_begin = 11;
//        int state_border_end = 12;
//        int state_border_together = 13;
//
//        int state_voted_x = 21;
//        int state_voted_y = 22;
//        int state_voted_both = 23;
//
//        // Parameter
//        int signal_intensity = 128;
//
//        int signal_range = 40;     // unit = meter; one pixel represents one meter
//        final int radius;
//        radius = (int) Math.round(signal_range / 2 * 1.4142);
//
//        // input Matrix
////        String indr_alloc_filename = "indr_alloc_arr.txt";
////        List<String> file_content = read_txt2arrlist("indr_alloc_arr.txt");
//        //input JSON
////        List<Integer> file_content_json_x = new ArrayList<>();
////        List<Integer> file_content_json_y = new ArrayList<>();
////        List<Integer> file_content_json_type = new ArrayList<>();
//
//        // output Matrix
//        List<Integer> index_elected_x = new ArrayList<>();
//        List<Integer> index_elected_y = new ArrayList<>();
//        int index_counter_x = 0;
//        int index_counter_y = 0;
//
//        // Initialize array value: Extract element in file_content
////        int arr_rows = file_content.size();               // 480
//        // int arr_rows = file_content.size()/20;               // 480
//        // int arr_cols = 640;  // 640
//        int arr_cols = 640; //width for x
//        int arr_rows = 480; //height for y
//        int states_channels = 4;
//        int channel_route = 0;
//        int channel_vote = 1;
//        int channel_intensity = 2;
//        int channel_inputsource = 3;
//        int arr_indr_alloc[][][] = new int[arr_cols][arr_rows][states_channels];
//
//        // if there is /n exist cols +1
//        System.out.printf("Array size = %d x %d (cols x rows)\n", arr_cols, arr_rows);
//        for (int row = 0; row < arr_rows; row++) {
////            String[] str_arr = file_content.get(row).split("\\s+", -1);
//
//            // System.out.println(str_arr.length);
//            // for(int col=0; col<str_arr.length; col++)
//            for (int col = 0; col < arr_cols; col++) {
////                arr_indr_alloc[row][col][channel_route] = Integer.parseInt(str_arr[col]);
//                arr_indr_alloc[col][row][channel_route] = test[col][row];
//                arr_indr_alloc[col][row][channel_inputsource] = test[col][row];
//                if ((col == (arr_cols - 1)) || (row == (arr_rows - 1))){
//                  arr_indr_alloc[col][row][channel_inputsource] = state_wall;
//                }
//                if (arr_indr_alloc[col][row][channel_inputsource] == state_wall){
//                  System.out.printf("TESTETST  arr_indr_alloc[%d][%d][channel_inputsource] = %d, \n", col, row, state_wall);
//                }
//                if (test[col][row] == state_wall){
//                  // System.out.printf("TESTETST  test[%d][%d] = %d, \n", col, row, test[col][row]);
//                  // System.out.printf("TESTETST  arr_indr_alloc[%d][%d] = %d, \n", col, row, arr_indr_alloc[col][row][channel_route]);
//                }
//                arr_indr_alloc[col][row][channel_vote] = 0;
//                arr_indr_alloc[col][row][channel_intensity] = 0;
//            }
//        }
//
//
//
//
//        // col(x) scan
//        for (int row = 0; row < arr_rows; row++) {
//            int col_status_current = 0; // 0 for begin; 1 for has set begin
//            int col_index_border_begin = 0;
//            int col_counter = 0;
//            for (int col = 0; col < arr_cols; col++) {
//                switch (col_status_current) {
//                    case 0: // begin
//                        if (arr_indr_alloc[col][row][channel_inputsource] == state_wall) { // wall
//                            break;
//                        } else {
//                            arr_indr_alloc[col][row][channel_route] = state_border_begin;
//                            col_counter = 0;
//                            col_index_border_begin = col; //set border begin
//                            col_status_current = 1;
//                            break;
//                        }
//                    case 1: // has set border begin
//                        if (arr_indr_alloc[col][row][channel_inputsource] == state_wall) { // wall
//                            int half_col_counter = col_counter / 2;
//                            arr_indr_alloc[col][row][channel_route] = state_border_end;
//                            arr_indr_alloc[col_index_border_begin + half_col_counter][row][channel_vote] = state_voted_x; // set voted by x
//                            col_status_current = 0; // voted, init col status
//                            // if (half_counter_col == 0) {
//                            //     arr_indr_alloc[col_index_border_begin][row][channel_route] = state_border_together;
//                            // }
//                            break;
//                        } else {
//                            if (col_counter == signal_range) { // reach the signal limit
//                                arr_indr_alloc[col][row][channel_route] = state_border_end;
//                                arr_indr_alloc[col - radius][row][channel_vote] = state_voted_x; // set voted by x
//                                col_status_current = 0; // voted, init col status
//                                break;
//                            } else {
//                                arr_indr_alloc[col][row][channel_route] = state_walked_x;
//                                col_counter += 1;
//                                break;
//                            }
//                        }
//                }
//            }
//
//        }
//
//        // row(y) scan and detect double voted
//        for (int col = 0; col < arr_cols; col++) {
//            int row_status_current = 0; // 0 for begin; 1 for has set begin
//            int row_index_border_begin = 0;
//            int row_counter = 0;
//            for (int row = 0; row < arr_rows; row++) {
//                switch (row_status_current) {
//                    case 0: // begin
//                        if (arr_indr_alloc[col][row][channel_inputsource] == state_wall) { // wall
//                            break;
//                        } else {
//                            arr_indr_alloc[col][row][channel_route] = state_border_begin;
//                            row_counter = 0;
//                            row_index_border_begin = row;
//                            row_status_current = 1;
//                            break;
//                        }
//
//                    case 1: // has set begin
//                        if (arr_indr_alloc[col][row][channel_inputsource] == state_wall) { // wall
//                            int half_row_counter = row_counter / 2;
//                            if (arr_indr_alloc[col][row_index_border_begin + half_row_counter][channel_vote] == state_voted_x) { // already voted by x
//                                arr_indr_alloc[col][row_index_border_begin + half_row_counter][channel_vote] = state_voted_both; // elected
//                                index_elected_x.add(col);
//                                index_elected_y.add(row_index_border_begin + half_row_counter);
//                                int temp_y = row_index_border_begin + half_row_counter;
//                                drawCircle(col, temp_y, radius, signal_intensity, arr_indr_alloc, channel_intensity);
//                                // index_elected_x [index_counter_x] = row_index_border_begin + half_counter_row;
//                                index_counter_x += 1;
//                                // index_elected_y [index_counter_y] = col;
//                                index_counter_y += 1;
//                                System.out.printf("Elected >> AP number = %d\n", index_counter_x -1);
//                                // System.out.printf("Elected >> %d, %d (cols, rows)\n", col, row_index_border_begin + half_row_counter);
//                                System.out.printf("Elected >> %d, %d (cols, rows)\n", index_elected_x.get(index_counter_x - 1), index_elected_y.get(index_counter_y - 1));
//
//                            } else {
//                                arr_indr_alloc[col][row][channel_route] = state_border_end;
//                                arr_indr_alloc[col][row_index_border_begin + half_row_counter][channel_vote] = state_voted_y; // set voted by y
//                            }
//                            row_status_current = 0; // voted, init status
//                            // if (half_counter_row == 0) {
//                            //     arr_indr_alloc[col][row_index_border_begin][channel_route] = state_border_together;
//                            // }
//                            break;
//                        } else {
//                            if (row_counter == signal_range) { // reach the signal limit
//                                arr_indr_alloc[col][row][channel_route] = state_border_end;
//                                if (arr_indr_alloc[col][row - radius][channel_vote] == state_voted_x) { // already voted by x
//                                    arr_indr_alloc[col][row - radius][channel_vote] = state_voted_both; // elected
//                                    index_elected_x.add(col);
//                                    index_elected_y.add(row - radius);
//                                    int temp_y = row - radius;
//                                    drawCircle(col, temp_y, radius, signal_intensity, arr_indr_alloc, channel_intensity);
//                                    index_counter_x += 1;
//                                    index_counter_y += 1;
//                                    System.out.printf("Elected >> AP number = %d\n", index_counter_x -1);
//                                    // System.out.printf("Elected >> %d, %d (cols, rows)\n", col, row - radius);
//                                    System.out.printf("Elected >> %d, %d (cols, rows)\n", index_elected_x.get(index_counter_x - 1), index_elected_y.get(index_counter_y - 1));
//                                } else {
//                                    arr_indr_alloc[col][row][channel_route] = state_border_end;
//                                    arr_indr_alloc[col][row - radius][channel_vote] = state_voted_y; // set voted by x
//                                }
//                                row_status_current = 0; // voted, init status
//                                break;
//                            } else {
//                                if (arr_indr_alloc[col][row][channel_route] == state_walked_x)
//                                    arr_indr_alloc[col][row][channel_route] = state_walked_both;
//                                else
//                                    arr_indr_alloc[col][row][channel_route] = state_walked_y;
//                                row_counter += 1;
//                                break;
//                            }
//                        }
//
//                }
//            }
//        }
//
//        //for DEBUUG
//        for (int tmp_row = 0; tmp_row < arr_rows; tmp_row++){
//          for (int tmp_col = 0; tmp_col < arr_cols; tmp_col++){
//            if (arr_indr_alloc[tmp_col][tmp_row][channel_inputsource] != 0){
//              System.out.printf("DEBUG >> arr_indr_alloc[%d][%d][%d] = %d\n", tmp_col, tmp_row, channel_inputsource, arr_indr_alloc[tmp_col][tmp_row][channel_inputsource]);
//            }
//          }
//        }
//
//        // output as image
//        try {
//            // BufferedImage image_alloc = new BufferedImage(arr_cols, arr_rows, BufferedImage.TYPE_BYTE_GRAY);
//            // BufferedImage image_voted = new BufferedImage(arr_cols, arr_rows, BufferedImage.TYPE_BYTE_GRAY);
//            BufferedImage image_alloc = new BufferedImage(arr_cols, arr_rows, BufferedImage.TYPE_INT_RGB);
//            BufferedImage image_voted = new BufferedImage(arr_cols, arr_rows, BufferedImage.TYPE_INT_RGB);
//            BufferedImage image_intensity = new BufferedImage(arr_cols, arr_rows, BufferedImage.TYPE_INT_RGB);
//            BufferedImage image_inputsource = new BufferedImage(arr_cols, arr_rows, BufferedImage.TYPE_INT_RGB);
//            Graphics2D indr_ap_graphic = image_voted.createGraphics();
//            indr_ap_graphic.setColor(Color.RED);
//            Color white = new Color(255, 255, 255);
//            Color black = new Color(0, 0, 0);
//            Color red = new Color(255, 0, 0);
//            Color green = new Color(0, 255, 0);
//            Color blue = new Color(0, 0, 255);
//            // WritableRaster raster = (WritableRaster) image.getData();
//            for (int row = 0; row < arr_rows; row++) {
//                for (int col = 0; col < arr_cols; col++) {
//                    int pixel_alloc = arr_indr_alloc[col][row][channel_route];
//                    int pixel_voted = arr_indr_alloc[col][row][channel_vote];
//                    int pixel_intensity = arr_indr_alloc[col][row][channel_intensity];
//                    int pixel_inputsource = arr_indr_alloc[col][row][channel_inputsource];
//                    if (pixel_inputsource == state_wall){
//                      image_inputsource.setRGB(col, row, black.getRGB());
//                      System.out.printf("drawJPG >> pixel_inputsource : wall >> %d, %d\n", col, row);
//                    }
//                    else
//                      image_inputsource.setRGB(col, row, white.getRGB());
//                    if (pixel_alloc == state_wall){
//                      image_alloc.setRGB(col, row, black.getRGB());
//                      // System.out.printf("drawJPG >> pixel_alloc : wall >> %d, %d\n", col, row);
//                    }
//                    else
//                        image_alloc.setRGB(col, row, white.getRGB());
//                    if (pixel_intensity == 128)
//                        image_intensity.setRGB(col, row, red.getRGB());
//
//                    switch (pixel_voted) {
//                        case 21: //state_voted_x
//                            image_voted.setRGB(col, row, blue.getRGB());
//                            break;
//                        case 22: //state_voted_y
//                            image_voted.setRGB(col, row, green.getRGB());
//                            break;
//                        case 23: //state_voted_both
//                            image_voted.setRGB(col, row, red.getRGB());
//                            break;
//                        default:
//                            image_voted.setRGB(col, row, white.getRGB());
//                    }
//                }
//            }
//
//            // draw circle
//            // for(int row=0; row<arr_rows; row++){
//            //     for(int col=0; col<arr_cols; col++){
//            //         int pixel_voted = arr_indr_alloc[row][col][channel_vote];
//            //         if(pixel_voted == state_x_y_voted)
//            //             indr_ap_graphic.drawOval(row-radius, col-radius, radius*2, radius*2);     // fillOval(int x, int y, int width, int height)
//            //     }
//            // }
//
//            File ouptut_img_alloc = new File("indr_alloc_color.jpg");
//            File ouptut_img_voted = new File("indr_voted_color.jpg");
//            File ouptut_img_intensity = new File("indr_intensity_color.jpg");
//            File ouptut_img_inputsource = new File("indr_inputsource_color.jpg");
//            ImageIO.write(image_alloc, "jpg", ouptut_img_alloc);
//            ImageIO.write(image_voted, "jpg", ouptut_img_voted);
//            ImageIO.write(image_intensity, "jpg", ouptut_img_intensity);
//            ImageIO.write(image_inputsource, "jpg", ouptut_img_inputsource);
//        } catch (Exception e) {
//        }
//
//    
//    
    public static int[][] phaseJSONandDrawMAP(int col, int row, int wallvalue) throws JSONException {
        // Phasing JSON
        List<Integer> file_content_json_x = new ArrayList<>();
        List<Integer> file_content_json_y = new ArrayList<>();
        List<String> file_content_json_type = new ArrayList<>();


        InputStream reader = null;
        String jsonStr = null;
        JSONObject jsonObj = null;

        // Fitting MAP
        int result[][] = new int[col][row];

        try {

            reader = new FileInputStream("IIIajaxData2.json");
//          InputStream is = Test.class.getResourceAsStream("/test.json");
            byte[] buffer = new byte[reader.available()];
            reader.read(buffer);
            jsonStr = new String(buffer, "UTF-8");
            System.out.printf("JSON jsonStr >> %s\n", jsonStr);
            int ii = jsonStr.indexOf("pos");
            System.out.printf("JSON indexOf { >> %d\n", ii);

        } catch (IOException e) {
            e.printStackTrace();
        }


        try {
            jsonObj = new JSONObject(jsonStr);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        JSONArray pos = jsonObj.getJSONArray("pos");


        for (int i = 0; i < pos.length(); i++) {
            JSONObject content = pos.getJSONObject(i);
            int x = content.getInt("x");
            int y = content.getInt("y");
            String type = content.getString("type");

            if ((x < 640) && (y < 480)) {
                result[x][y] = wallvalue;
            }
            else {
                System.out.printf("Phasing JSON out of border !! >> x = %d, y = %d, type = %s\n", x, y, type);
            }

            file_content_json_x.add(x);
            file_content_json_y.add(y);
            file_content_json_type.add(type);
            System.out.printf("Phasing JSON >> x = %d, y = %d, type = %s\n", x, y, type);
        }


        return result;


    }
//
    // Reading text file into ArrayList in Java 7 & 8 List<String>
    public static List<String> read_txt2arrlist(String filename) {
        List<String> file_content = Collections.emptyList();
        try {
            file_content = Files.readAllLines(Paths.get(filename), StandardCharsets.UTF_8);
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return (file_content);
    }

    // Draw circle onto array
    static void drawCircle(int x, int y, int r, int intensity, int[][][] inputArray, int selectedChannel) {
        double PI = 3.1415926535;
        double i, angle, x1, y1;
        // int tempArray[][] = new int[arr_rows][arr_cols];
        int arr_cols = 640;
        int arr_rows = 480;


        for (i = 0; i < 360; i += 1) {
            angle = i;
            x1 = r * cos(angle * PI / 180);
            y1 = r * sin(angle * PI / 180);

            int ElX = (int) Math.round(x + x1);
            int ElY = (int) Math.round(y + y1);
            // tempArray [ElX][ElY] = intensity;
//            System.out.printf("drawCircle >> ElY = %d, ElY = %d\n", ElX, ElY);
            if ((ElX > 0) && (ElY > 0) && (ElX < arr_cols) && (ElY < arr_rows)) {
                inputArray[ElX][ElY][selectedChannel] = intensity;
            } else {
//                System.out.printf("drawCircle >> outOfBonders\n");
            }
        }
//        return inputArray;
    }
    
    
    String imgWidth = request.getParameter("imgWidth");
    String imgHeight = request.getParameter("imgHeight");
//    requirementArea
//        if (author != null && !author.equals(""))) {
%>
<%= imgWidth %>
<%= imgHeight %>
