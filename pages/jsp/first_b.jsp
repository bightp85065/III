
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONObject" %>

<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.awt.*" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="static java.lang.StrictMath.cos" %>
<%@ page import="static java.lang.StrictMath.sin" %>

<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStream" %>



<%!
	
    public class JSONparser {
        public int[][] source_map;

        public List<Integer> result = new ArrayList<>();
        public List<Integer> file_content_json_x = new ArrayList<>();
        public List<Integer> file_content_json_y = new ArrayList<>();
        public List<String> file_content_json_type = new ArrayList<>();
        public List<Integer> file_content_json_apspec = new ArrayList<>();

        public String getType(JSONObject jsonObj) throws JSONException {
            InputStream reader = null;
            String jsonStr = null;

            String apType = jsonObj.getString("apType");

            return apType;
        }

        public List<Integer> getParameter(JSONObject jsonObj, int chooseWhich) throws JSONException {
            List<Integer> result = new ArrayList<>();
            List<Integer> file_content_json_x = new ArrayList<>();
            List<Integer> file_content_json_y = new ArrayList<>();
            List<Integer> file_content_json_type = new ArrayList<>();
            List<Integer> file_content_json_apspec = new ArrayList<>();

            InputStream reader = null;
            String jsonStr = null;


            // Get Scale
            int scale = jsonObj.getInt("scale");
            System.out.printf("getParameter >> scale = %d\n", scale);

            // Get AP spec from json
            JSONArray ap_spec = jsonObj.getJSONArray("ap");
            for (int i = 0; i < ap_spec.length(); i++) {
                int ap_intensity = Integer.parseInt(ap_spec.getString(i));
                file_content_json_apspec.add(ap_intensity);
                System.out.printf("getParameter >> ap_intensity = %d\n", ap_intensity);
            }

            // Get width and height from json
            int imgWidth = jsonObj.getInt("imgWidth");
            int imgHeight = jsonObj.getInt("imgHeight");
            System.out.printf("getParameter >> (imgWidth, imgHeight) = (%d, %d)\n", imgWidth, imgHeight);

            // Get requirementArea !!later work

            // Get Wall index
            JSONArray pos = jsonObj.getJSONArray("pos");
            for (int i = 0; i < pos.length(); i++) {
                JSONObject content = pos.getJSONObject(i);
                int x = content.getInt("x");
                int y = content.getInt("y");
                int type = content.getInt("w_type"); //wall type

                if ((x < imgWidth) && (y < imgHeight)) {
                    file_content_json_x.add(x);
                    file_content_json_y.add(y);
                    file_content_json_type.add(type);
                } else {
                    // System.out.printf("getParameter >> Phasing JSON out of border !! >> x = %d, y = %d, type = %s\n", x, y, type);
                }


                // System.out.printf("getParameter >> Phasing JSON >> x = %d, y = %d, type = %s\n", x, y, type);
            }


            switch (chooseWhich) {
                case 0:
                    result = file_content_json_x;
                case 1:
                    result = file_content_json_y;
                case 2:
                    result = file_content_json_type;
                case 3:
                    result = file_content_json_apspec;
            }
            return result;
        }


        public int[][] drawMAP(JSONObject jsonObj, int wallValue, int elevatorValue, int manualAPValue, int mainAPValue, int sensorNodeValue) throws JSONException {

            InputStream reader = null;
            String jsonStr = null;

            // Get width and height from json
            int imgWidth = jsonObj.getInt("imgWidth");
            int imgHeight = jsonObj.getInt("imgHeight");
            System.out.printf("drawMAP >> (imgWidth, imgHeight) = (%d, %d)\n", imgWidth, imgHeight);
            // Fitting MAP
            int result[][] = new int[imgWidth][imgHeight];


            // Get requirementArea
            JSONObject requirementAreaParameter = jsonObj.getJSONObject("requirementArea");
            int x1 = requirementAreaParameter.getInt("x1");
            int y1 = requirementAreaParameter.getInt("y1");
            int x2 = requirementAreaParameter.getInt("x2");
            int y2 = requirementAreaParameter.getInt("y2");
            System.out.printf("drawMAP >> (x1, y1) (x2, y2) = (%d, %d) (%d, %d)\n", x1, y1, x2, y2);
            for (int row = 0; row < imgHeight; row++) {
                for (int col = 0; col < imgWidth; col++) {
                    if (!(col >= x1 & col <= x2 & row >= y1 & row <= y2)) {
                        result[col][row] = wallValue;
                        // System.out.printf("drawMAP >> out of requirementArea!!\n");
                    }
                }
            }


            // Get Wall index
            JSONArray pos = jsonObj.getJSONArray("pos");
            for (int i = 0; i < pos.length(); i++) {
                JSONObject content = pos.getJSONObject(i);
                int x_wall = content.getInt("x");
                int y_wall = content.getInt("y");
                String type = content.getString("w_type"); //wall type

                if ((x_wall < imgWidth) && (y_wall < imgHeight)) {
                    result[x_wall][y_wall] = wallValue;
                } else {
                    // System.out.printf("drawMAP >> Phasing JSON out of border !! >> x = %d, y = %d, type = %s\n", x, y, type);
                }

                // System.out.printf("drawMAP >> Phasing JSON >> x = %d, y = %d, type = %s\n", x, y, type);
            }

            // Get elevator
            JSONArray elevator = jsonObj.getJSONArray("elevator");
            for (int i = 0; i < elevator.length(); i++) {
                JSONObject content = elevator.getJSONObject(i);
                int x1_Elevator = content.getInt("x1");
                int y1_Elevator = content.getInt("y1");
                int x2_Elevator = content.getInt("x2");
                int y2_Elevator = content.getInt("y2");

                if ((x1_Elevator < imgWidth) && (y1_Elevator < imgHeight) && (x2_Elevator < imgWidth) && (y2_Elevator < imgHeight)) {
                    for (int y = y1_Elevator; y < y2_Elevator; y++){
                        for (int x = x1_Elevator; x < x2_Elevator; x++){
                            result[x][y] = elevatorValue;
                        }
                    }
                } else {
                }
            }
            //
            // // Get manual-deploy APs
            // JSONArray manualDeployAP = jsonObj.getJSONArray("manualDeployAP");
            // for (int i = 0; i < manualDeployAP.length(); i++) {
            //     JSONObject content = manualDeployAP.getJSONObject(i);
            //     int x_ManualDeployAP = content.getInt("x");
            //     int y_ManualDeployAP = content.getInt("y");
            //
            //     if ((x_ManualDeployAP < imgWidth) && (y_ManualDeployAP < imgHeight)) {
            //         result[x_ManualDeployAP][y_ManualDeployAP] = manualAPValue;
            //     } else {
            //     }
            // }
            //
            // Get manual-deploy mainAps
            JSONArray manualDeployMainAP = jsonObj.getJSONArray("uplinkPoint");
            for (int i = 0; i < manualDeployMainAP.length(); i++) {
                JSONObject content = manualDeployMainAP.getJSONObject(i);
                int x_ManualDeployMainAP = content.getInt("x");
                int y_ManualDeployMainAP = content.getInt("y");

                if ((x_ManualDeployMainAP < imgWidth) && (y_ManualDeployMainAP < imgHeight)) {
                    result[x_ManualDeployMainAP][y_ManualDeployMainAP] = mainAPValue;
                } else {
                }
            }

            // Get sensorNode
            JSONArray sensorNode = jsonObj.getJSONArray("sensorNode");
            for (int i = 0; i < sensorNode.length(); i++) {
                JSONObject content = sensorNode.getJSONObject(i);
                int x_sensorNode = content.getInt("x");
                int y_sensorNode = content.getInt("y");

                if ((x_sensorNode < imgWidth) && (y_sensorNode < imgHeight)) {
                    result[x_sensorNode][y_sensorNode] = sensorNodeValue;
                } else {
                }
            }

            return result;


        }


    }

%>

<%!

    public class DataPacket {

        public int arr_cols = 0;
        public int arr_rows = 0;

        public int state_wall = 255;
        public int state_elevator = 240;
        public int state_manualDeployAP = 220;
        public int state_manaulMainAP = 215;
        public int state_sensorNodeValue = 210;

        // Parameter status
        public int state_walked_non = 0;
        public int state_walked_x = 1;
        public int state_walked_y = 2;
        public int state_walked_both = 3;

        public int state_border_begin = 11;
        public int state_border_end = 12;
        public int state_border_together = 13;

        public int state_voted_x = 21;
        public int state_voted_y = 22;
        public int state_voted_both = 23;

        public int signal_intensity = 128;
        public int signal_intensity_mainap = 168;

        public int state_mainap_deploy = 200;

        // output Matrix
        public List<Integer> index_elected_x = new ArrayList<>();
        public List<Integer> index_elected_y = new ArrayList<>();
        public int index_counter_x = 0;
        public int index_counter_y = 0;

        // Initialize array value: Extract element in file_content
        public int states_channels = 7;

        public int channel_route = 0;
        public int channel_vote = 1;
        public int channel_intensity = 2;
        public int channel_inputsource = 3;
        public int channel_apchooser = 4;
        public int channel_mainap = 5;
        public int channel_heatmap = 6;
        public int[][][] mapArray = new int[arr_cols][arr_rows][states_channels];

        public List<Integer> json_content_x = new ArrayList<>();
        public List<Integer> json_content_y = new ArrayList<>();
        public List<Integer> json_content_type = new ArrayList<>();
        public List<Integer> json_content_apIntensity = new ArrayList<>();

        public int mainApIntensity = 180; //radius

    }

%>

<%!
    static void drawCircle(int x, int y, int r, int intensity, int[][][] inputArray, int selectedChannel) {
        double PI = 3.1415926535;
        double i, angle, x1, y1;
        int arr_cols = inputArray.length;
        int arr_rows = inputArray[0].length;


        for (i = 0; i < 360; i += 1) {
            angle = i;
            x1 = r * cos(angle * PI / 180);
            y1 = r * sin(angle * PI / 180);

            int ElX = (int) Math.round(x + x1);
            int ElY = (int) Math.round(y + y1);

            if ((ElX > 0) && (ElY > 0) && (ElX < arr_cols) && (ElY < arr_rows)) {
                inputArray[ElX][ElY][selectedChannel] = intensity;
            } else {

            }
        }
    }

%>

<%!
    static boolean[][] drawBoolCircle(int x, int y, int r, boolean[][] inputArray) {
            double PI = 3.1415926535;
            double i, angle, x1, y1;
            // int tempArray[][] = new int[arr_rows][arr_cols];
            int arr_cols = inputArray.length;
            int arr_rows = inputArray[0].length;


            for (i = 0; i < 360; i += 1) {
                angle = i;
                x1 = r * cos(angle * PI / 180);
                y1 = r * sin(angle * PI / 180);

                int ElX = (int) Math.round(x + x1);
                int ElY = (int) Math.round(y + y1);
                // tempArray [ElX][ElY] = intensity;
    //            System.out.printf("drawCircle >> ElY = %d, ElY = %d\n", ElX, ElY);
                if ((ElX > 0) && (ElY > 0) && (ElX < arr_cols) && (ElY < arr_rows)) {
                    inputArray[ElX][ElY] = true;
                } else {
    //                System.out.printf("drawCircle >> outOfBonders\n");
                }
            }

            return inputArray;
        }

%>

<%!
    public static DataPacket apDeployAlgorithm(DataPacket inputPacket) {

        int signal_ap1_range = inputPacket.json_content_apIntensity.get(0);     // unit = meter; one pixel represents one meter
        final int radius;
        radius = (int) Math.round(signal_ap1_range / 2 * 1.4142);


        // col(x) scan
        for (int row = 0; row < inputPacket.arr_rows; row++) {
            int col_status_current = 0; // 0 for begin; 1 for has set begin
            int col_index_border_begin = 0;
            int col_counter = 0;
            int col_ap_chooser = 0; // default = 0, biggest one
            for (int col = 0; col < inputPacket.arr_cols; col++) {
                switch (col_status_current) {
                    case 0: // begin
                        if (inputPacket.mapArray[col][row][inputPacket.channel_inputsource] == inputPacket.state_wall) { // wall
                            break;
                        } else {
                            inputPacket.mapArray[col][row][inputPacket.channel_route] = inputPacket.state_border_begin;
                            col_counter = 0;
                            col_index_border_begin = col; //set border begin
                            col_status_current = 1;
                            break;
                        }
                    case 1: // has set border begin
                        if (inputPacket.mapArray[col][row][inputPacket.channel_inputsource] == inputPacket.state_wall) { // wall
                            int half_col_counter = col_counter / 2;
                            inputPacket.mapArray[col][row][inputPacket.channel_route] = inputPacket.state_border_end;
                            inputPacket.mapArray[col_index_border_begin + half_col_counter][row][inputPacket.channel_vote] = inputPacket.state_voted_x; // set voted by x
                            for (int ap_counter = 0; ap_counter < inputPacket.json_content_apIntensity.size(); ap_counter++) { // choose other ap if range is small
                                if (col_counter <= inputPacket.json_content_apIntensity.get(ap_counter)) { //ap_intensity can converge row_counter
                                    col_ap_chooser = ap_counter;
                                } else { // ap_intensity cannot converge row_counter
                                    inputPacket.mapArray[col_index_border_begin + half_col_counter][row][inputPacket.channel_apchooser] = col_ap_chooser;
                                    break;
                                }

                            }
                            col_status_current = 0; // voted, init col status
                            break;
                        } else {
                            if (col_counter == signal_ap1_range) { // reach the signal limit
                                inputPacket.mapArray[col][row][inputPacket.channel_route] = inputPacket.state_border_end;
                                inputPacket.mapArray[col - radius][row][inputPacket.channel_vote] = inputPacket.state_voted_x; // set voted by x
                                inputPacket.mapArray[col - radius][row][inputPacket.channel_apchooser] = col_ap_chooser;
                                col_status_current = 0; // voted, init col status
                                break;
                            } else {
                                inputPacket.mapArray[col][row][inputPacket.channel_route] = inputPacket.state_walked_x;
                                col_counter += 1;
                                break;
                            }
                        }
                }
            }

        }

        // row(y) scan and detect double voted
        for (int col = 0; col < inputPacket.arr_cols; col++) {
            int row_status_current = 0; // 0 for begin; 1 for has set begin
            int row_index_border_begin = 0;
            int row_counter = 0;
            int row_ap_chooser = 0;
            int final_ap_chooser = 0;
            int ap_radius = 0;
            for (int row = 0; row < inputPacket.arr_rows; row++) {
                switch (row_status_current) {
                    case 0: // begin
                        if (inputPacket.mapArray[col][row][inputPacket.channel_inputsource] == inputPacket.state_wall) { // wall
                            break;
                        } else {
                            inputPacket.mapArray[col][row][inputPacket.channel_route] = inputPacket.state_border_begin;
                            row_counter = 0;
                            row_index_border_begin = row;
                            row_status_current = 1;
                            break;
                        }

                    case 1: // has set begin
                        if (inputPacket.mapArray[col][row][inputPacket.channel_inputsource] == inputPacket.state_wall) { // wall
                            int half_row_counter = row_counter / 2;
                            if (inputPacket.mapArray[col][row_index_border_begin + half_row_counter][inputPacket.channel_vote] == inputPacket.state_voted_x) { // already voted by x
                                inputPacket.mapArray[col][row_index_border_begin + half_row_counter][inputPacket.channel_vote] = inputPacket.state_voted_both; // elected
                                inputPacket.index_elected_x.add(col);
                                inputPacket.index_elected_y.add(row_index_border_begin + half_row_counter);

                                for (int ap_counter = 0; ap_counter < inputPacket.json_content_apIntensity.size(); ap_counter++) { // choose other ap if range is small
                                    if (row_counter <= inputPacket.json_content_apIntensity.get(ap_counter)) { //ap_intensity can converge row_counter
                                        row_ap_chooser = ap_counter;
                                    } else { // ap_intensity cannot converge row_counter
                                        inputPacket.mapArray[col][row_index_border_begin + half_row_counter][inputPacket.channel_apchooser] = row_ap_chooser;
                                        break;
                                    }
                                }

                                int temp_y = row_index_border_begin + half_row_counter;
                                ap_radius = (int) Math.round(inputPacket.json_content_apIntensity.get(inputPacket.mapArray[col][row_index_border_begin + half_row_counter][inputPacket.channel_apchooser]) / 2 * 1.4142);
                                //                                System.out.printf("inputPacket.mapArray[col][row][channel_apchooser] = %d\n", inputMapArray[col][row_index_border_begin + half_row_counter][channel_apchooser]);
                                //                                System.out.printf("row_ap_chooser = %d\n", row_ap_chooser);
                                //                                System.out.printf("ap_radius = %d\n", ap_radius);
                                drawCircle(col, temp_y, ap_radius, inputPacket.signal_intensity, inputPacket.mapArray, inputPacket.channel_intensity);
                                inputPacket.index_counter_x += 1;
                                inputPacket.index_counter_y += 1;
                                // System.out.printf("Elected >> AP number = %d\n", index_counter_x - 1);
                                // System.out.printf("Elected >> %d, %d (cols, rows)\n", col, row_index_border_begin + half_row_counter);
                                // System.out.printf("Elected >> %d, %d (cols, rows)\n", index_elected_x.get(index_counter_x - 1), index_elected_y.get(index_counter_y - 1));
                                row_ap_chooser = 0; // init
                                final_ap_chooser = 0;

                            } else {
                                inputPacket.mapArray[col][row][inputPacket.channel_route] = inputPacket.state_border_end;
                                inputPacket.mapArray[col][row_index_border_begin + half_row_counter][inputPacket.channel_vote] = inputPacket.state_voted_y; // set voted by y
                                inputPacket.mapArray[col][row_index_border_begin + half_row_counter][inputPacket.channel_apchooser] = row_ap_chooser;
                            }
                            row_status_current = 0; // voted, init status
                            break;
                        } else {
                            if (row_counter == signal_ap1_range) { // reach the signal limit
                                inputPacket.mapArray[col][row][inputPacket.channel_route] = inputPacket.state_border_end;
                                if (inputPacket.mapArray[col][row - radius][inputPacket.channel_vote] == inputPacket.state_voted_x) { // already voted by x
                                    inputPacket.mapArray[col][row - radius][inputPacket.channel_vote] = inputPacket.state_voted_both; // elected
                                    inputPacket.mapArray[col][row - radius][inputPacket.channel_apchooser] = row_ap_chooser;
                                    inputPacket.index_elected_x.add(col);
                                    inputPacket.index_elected_y.add(row - radius);
                                    int temp_y = row - radius;
                                    ap_radius = (int) Math.round(inputPacket.json_content_apIntensity.get(inputPacket.mapArray[col][row - radius][inputPacket.channel_apchooser]) / 2 * 1.4142);
                                    //                                    System.out.printf("inputPacket.mapArray[col][row][channel_apchooser] = %d\n", inputMapArray[col][row][channel_apchooser]);
                                    //                                    System.out.printf("row_ap_chooser = %d\n", row_ap_chooser);
                                    //                                    System.out.printf("ap_radius = %d\n", ap_radius);
                                    drawCircle(col, temp_y, ap_radius, inputPacket.signal_intensity, inputPacket.mapArray, inputPacket.channel_intensity);
                                    inputPacket.index_counter_x += 1;
                                    inputPacket.index_counter_y += 1;
                                    // System.out.printf("Elected >> AP number = %d\n", index_counter_x - 1);
                                    // System.out.printf("Elected >> %d, %d (cols, rows)\n", col, row - radius);
                                    // System.out.printf("Elected >> %d, %d (cols, rows)\n", index_elected_x.get(index_counter_x - 1), index_elected_y.get(index_counter_y - 1));
                                } else {
                                    inputPacket.mapArray[col][row][inputPacket.channel_route] = inputPacket.state_border_end;
                                    inputPacket.mapArray[col][row - radius][inputPacket.channel_vote] = inputPacket.state_voted_y; // set voted by x
                                }
                                row_status_current = 0; // voted, init status
                                break;
                            } else {
                                if (inputPacket.mapArray[col][row][inputPacket.channel_route] == inputPacket.state_walked_x)
                                    inputPacket.mapArray[col][row][inputPacket.channel_route] = inputPacket.state_walked_both;
                                else
                                    inputPacket.mapArray[col][row][inputPacket.channel_route] = inputPacket.state_walked_y;
                                row_counter += 1;
                                break;
                            }
                        }

                }
            }
        }

        System.out.printf("algorithm finished!!\n");
        return inputPacket;

    }

%>

<%!

    public static DataPacket deployMainAP(DataPacket inputPacket) {
        // inputPacket.index_elected_x;
        // inputPacket.index_elected_y;
        // inputPacket.mainApIntensity;
        System.out.printf("index_elected_x.size() = %d, index_elected_y.size() = %d\n", inputPacket.index_elected_x.size(), inputPacket.index_elected_y.size());

        // create a empty elected map
        boolean[][] map_elected = new boolean[inputPacket.arr_cols][inputPacket.arr_rows];
        boolean[][] map_empty = new boolean[inputPacket.arr_cols][inputPacket.arr_rows];
        boolean[][] map_result = new boolean[inputPacket.arr_cols][inputPacket.arr_rows];

        int counter = 0;

        List<Integer> index_mainap_elected_x = new ArrayList<>();
        List<Integer> index_mainap_elected_y = new ArrayList<>();

        // fill true into the right place
        for (int i = 0; i < inputPacket.index_elected_x.size(); i++) {
            map_elected[inputPacket.index_elected_x.get(i)][inputPacket.index_elected_y.get(i)] = true;
        }


        for (int i = inputPacket.mainApIntensity; i < inputPacket.arr_cols - inputPacket.mainApIntensity; i++) {
            // make a ArrayList, to record couter value during the current scan
            List<Integer> counter_list = new ArrayList<>();
            for (int j = inputPacket.mainApIntensity; j < inputPacket.arr_rows - inputPacket.mainApIntensity; j++) {
                boolean[][] mask = drawBoolCircle(i, j, inputPacket.mainApIntensity, map_empty); // Boolean[][] drawBoolCircle(int x, int y, int r, Boolean[][] inputArray)
                counter = 0;
                int x = i - inputPacket.mainApIntensity;
                int y = j - inputPacket.mainApIntensity;
                for (int k = i - inputPacket.mainApIntensity; k < i + inputPacket.mainApIntensity; k++) {
                    for (int h = j - inputPacket.mainApIntensity; h < j + inputPacket.mainApIntensity; h++) {
                        // System.out.printf("i = %d, j = %d, k = %d, h = %d\n", i, j, k, h);
                        if ((map_elected[k][h] == true) && (mask[k][h] == true)){
                            counter += 1;
                        }
                        if ((k == i + inputPacket.mainApIntensity - 1) && (h == j + inputPacket.mainApIntensity - 1)) {
                            // System.out.printf("end of loop, counter = %d\n", counter);
                            counter_list.add(counter);
                            if (counter_list.size() > 1) {
                                int couter_previous = counter_list.get(counter_list.size() - 2); // get previous couter value
                                if (counter > couter_previous) {
                                    map_result[k][h - 1] = true;
                                    index_mainap_elected_x.add(k);
                                    index_mainap_elected_y.add(h - 1);
                                    boolean[][] mask_erase = drawBoolCircle(k, h - 1, inputPacket.mainApIntensity, map_empty);
                                    for (int m = x - 1; m < x + inputPacket.mainApIntensity * 2 - 1; m++) {
                                        for (int n = y; n < y + inputPacket.mainApIntensity * 2; n++) {
                                            if(m >= 0 && m <= inputPacket.arr_cols && n >= 0 && n <= inputPacket.arr_rows) {
                                                if ((mask_erase[m][n] == true) && (map_elected[m][n] == true)) {
                                                    // System.out.printf("delete ap point at (%d, %d)\n", m, n);
                                                    map_elected[m][n] = false;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        int counter_print = 1;
        for (int i = 0; i < index_mainap_elected_x.size(); i++) {
            System.out.printf("inputPacket.index_mainap_elected_x = %d, inputPacket.index_mainap_elected_y = %d, counter = %d\n", index_mainap_elected_x.get(i), index_mainap_elected_y.get(i), counter_print);
            counter_print += 1;
        }

        return inputPacket;
    }

%>

<%!

    public static void drawJPG(DataPacket inputPacket) {

        // output as image
        try {
            BufferedImage image_alloc = new BufferedImage(inputPacket.arr_cols, inputPacket.arr_rows, BufferedImage.TYPE_INT_RGB);
            BufferedImage image_voted = new BufferedImage(inputPacket.arr_cols, inputPacket.arr_rows, BufferedImage.TYPE_INT_RGB);
            BufferedImage image_intensity = new BufferedImage(inputPacket.arr_cols, inputPacket.arr_rows, BufferedImage.TYPE_INT_RGB);
            BufferedImage image_inputsource = new BufferedImage(inputPacket.arr_cols, inputPacket.arr_rows, BufferedImage.TYPE_INT_RGB);
            BufferedImage image_merge = new BufferedImage(inputPacket.arr_cols, inputPacket.arr_rows, BufferedImage.TYPE_INT_RGB);
            Graphics2D indr_ap_graphic = image_voted.createGraphics();
            indr_ap_graphic.setColor(Color.RED);
            Color white = new Color(255, 255, 255);
            Color black = new Color(0, 0, 0);

            // Solarized Color Palette
            Color yellow = new Color(181, 137, 0);
            Color orange = new Color(203, 75, 22);
            Color red = new Color(220, 50, 47);
            Color magenta = new Color(211, 54, 130);
            Color violet = new Color(103, 118, 196);
            Color blue = new Color(38, 139, 210);
            Color cyan = new Color(42, 161, 152);
            Color green = new Color(133, 153, 0);


            // WritableRaster raster = (WritableRaster) image.getData();
            for (int row = 0; row < inputPacket.arr_rows; row++) {
                for (int col = 0; col < inputPacket.arr_cols; col++) {
                    int pixel_alloc = inputPacket.mapArray[col][row][inputPacket.channel_route];
                    int pixel_voted = inputPacket.mapArray[col][row][inputPacket.channel_vote];
                    int pixel_intensity = inputPacket.mapArray[col][row][inputPacket.channel_intensity];
                    int pixel_inputsource = inputPacket.mapArray[col][row][inputPacket.channel_inputsource];
                    if (pixel_inputsource == inputPacket.state_wall) {
                        image_inputsource.setRGB(col, row, black.getRGB());
                        image_merge.setRGB(col, row, white.getRGB());
                        // System.out.printf("drawJPG >> pixel_inputsource : wall >> %d, %d\n", col, row);
                    } else
                        image_inputsource.setRGB(col, row, white.getRGB());
                    if (pixel_alloc == inputPacket.state_wall) {
                        image_alloc.setRGB(col, row, black.getRGB());
                        // System.out.printf("drawJPG >> pixel_alloc : wall >> %d, %d\n", col, row);
                    } else
                        image_alloc.setRGB(col, row, white.getRGB());
                    if (pixel_intensity == inputPacket.signal_intensity) {
                        image_intensity.setRGB(col, row, red.getRGB());
                        image_merge.setRGB(col, row, red.getRGB());
                    }
                    switch (pixel_voted) {
                        case 21: //state_voted_x
                            image_voted.setRGB(col, row, blue.getRGB());
                            // image_merge.setRGB(col, row, blue.getRGB());
                            break;
                        case 22: //state_voted_y
                            image_voted.setRGB(col, row, green.getRGB());
                            // image_merge.setRGB(col, row, green.getRGB());
                            break;
                        case 23: //state_voted_both
                            image_voted.setRGB(col, row, red.getRGB());
                            image_merge.setRGB(col, row, red.getRGB());
                            break;
                        default:
                            image_voted.setRGB(col, row, white.getRGB());
                    }
                }
            }


            File output_img_alloc = new File("indr_alloc_color.jpg");
            File output_img_voted = new File("indr_voted_color.jpg");
            File output_img_intensity = new File("indr_intensity_color.jpg");
            File output_img_inputsource = new File("indr_inputsource_color.jpg");
            File output_img_merge = new File("indr_merge_color.jpg");
            ImageIO.write(image_alloc, "jpg", output_img_alloc);
            ImageIO.write(image_voted, "jpg", output_img_voted);
            ImageIO.write(image_intensity, "jpg", output_img_intensity);
            ImageIO.write(image_inputsource, "jpg", output_img_inputsource);
            ImageIO.write(image_merge, "jpg", output_img_merge);
            System.out.printf("drawJPG finished!!\n");
        } catch (Exception e) {
        }

    }

%>

<%
    // main script

    JSONObject jsonCallback = new JSONObject();

    float scale = Float.parseFloat(request.getParameter("scale"));

    int imgWidth = Integer.valueOf(request.getParameter("imgWidth"));
    int imgHeight = Integer.valueOf(request.getParameter("imgHeight"));

    JSONObject requirementArea = new JSONObject(request.getParameter("requirementArea"));
    JSONArray pos = new JSONArray(request.getParameter("pos"));
    JSONArray ap = new JSONArray(request.getParameter("ap"));

    JSONObject jsonObj = new JSONObject();

    jsonObj.put("imgWidth", imgWidth);
    jsonObj.put("imgHeight", imgHeight);
    jsonObj.put("scale", scale);
    jsonObj.put("requirementArea", requirementArea);
    jsonObj.put("pos", pos);
    jsonObj.put("ap", ap);

    int state_wall = 255;
    // Start from here
    // Set Wall value, more than one in the future
    
	DataPacket packet = new DataPacket();


    // read JSON and draw wall
    JSONparser jsonParser = new JSONparser(); // call com.mitlab.JSONparser
    int inputJOSNArray[][] = jsonParser.drawMAP(jsonObj, packet.state_wall, packet.state_elevator, packet.state_manualDeployAP, packet.state_manualDeployAP, packet.state_sensorNodeValue);
    packet.arr_cols = inputJOSNArray.length; //width for x
    packet.arr_rows = inputJOSNArray[0].length; //height for y
    System.out.printf("inputJSONArray size = %d x %d (cols x rows)\n", packet.arr_cols, packet.arr_rows);
    // read Parameter from JSON
    packet.json_content_x = jsonParser.getParameter(jsonObj, 0);
    packet.json_content_y = jsonParser.getParameter(jsonObj, 1);
    packet.json_content_type = jsonParser.getParameter(jsonObj, 2);
    packet.json_content_apIntensity = jsonParser.getParameter(jsonObj, 3);

    // // Parameter status
    // packet.state_walked_non = 0;
    // packet.state_walked_x = 1;
    // packet.state_walked_y = 2;
    // packet.state_walked_both = 3;

    // packet.state_border_begin = 11;
    // packet.state_border_end = 12;
    // packet.state_border_together = 13;

    // packet.state_voted_x = 21;
    // packet.state_voted_y = 22;
    // packet.state_voted_both = 23;

    // // Parameter
    // packet.signal_intensity = 128;

    // // output Matrix
    // packet.index_elected_x = new ArrayList<>();
    // packet.index_elected_y = new ArrayList<>();
    // packet.index_counter_x = 0;
    // packet.index_counter_y = 0;

    // // Initialize array value: Extract element in file_content
    // packet.states_channels = 5;
    // packet.channel_route = 0;
    // packet.channel_vote = 1;
    // packet.channel_intensity = 2;
    // packet.channel_inputsource = 3;
    // packet.channel_apchooser = 4;
    // packet.mapArray = new int[packet.arr_cols][packet.arr_rows][packet.states_channels];

    // if there is /n exist cols +1
    // System.out.printf("Array size = %d x %d (cols x rows)\n", arr_cols, arr_rows);
    for (int row = 0; row < packet.arr_rows; row++) {
        // System.out.println(str_arr.length);
        for (int col = 0; col < packet.arr_cols; col++) {
            packet.mapArray[col][row][packet.channel_route] = inputJOSNArray[col][row];
            packet.mapArray[col][row][packet.channel_inputsource] = inputJOSNArray[col][row];
            if ((col == (packet.arr_cols - 1)) || (row == (packet.arr_rows - 1))) {
                packet.mapArray[col][row][packet.channel_inputsource] = packet.state_wall;
            }
            packet.mapArray[col][row][packet.channel_vote] = 0;
            packet.mapArray[col][row][packet.channel_intensity] = 0;
        }
    }

    System.out.printf("mapArray size = %d x %d x %d\n", packet.mapArray.length, packet.mapArray[0].length, packet.mapArray[0][0].length);

    packet = apDeployAlgorithm(packet);
    //packet = deployMainAP(packet);

    drawJPG(packet);

%>

<%= jsonCallback %>
<%--<%= pos%>
<%= imgWidth%>
<%= imgHeight%>
<%= requirementArea%>
<%= scale%>
<%= ap%>--%>
<%--<%= jsonObj %>--%>
<%--<%= jsonObj %>--%>

