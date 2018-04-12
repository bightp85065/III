
        $.drawCanvas=document.getElementById("canvas");
        $.drawCtx=$.drawCanvas.getContext("2d");
        $.drawCanvasOffset=$("#canvas").offset();
        $.drawOffsetX=$.drawCanvasOffset.left;
        $.drawOffsetY=$.drawCanvasOffset.top;

        //            var $.drawStartX,$.drawStartY,$.drawMouseX,$.drawMouseY;
        $.drawIsDown=false;

        $.drawLines=[];
        $.drawStraightLines=[];
        $.drawSquares=[];
        $.drawSquaresForElevator=[];
        $.drawUplinkPoint=[];
        $.drawSensorNode=[];

        $.drawImageOpacity=0.33;
        
        function imgInitCanvas(file){

            $.drawImgSrc = true;
            $.drawImg=new Image();
            $.drawImg.crossOrigin="anonymous";
            $.drawImg.onload=start;
        //                $.drawImg.src="f_10057631_1.jpg";
            var _URL = window.URL || window.webkitURL;
            $.drawImg.src=_URL.createObjectURL(file);
            $("#canvasPlace").css("visibility","visible");
            
        }

        function imgInitCanvasForUrl(url){

            $.drawImgSrc = true;
            $.drawImg=new Image();
            $.drawImg.crossOrigin="anonymous";
            $.drawImg.onload=start;
            $.drawImg.src=url;

        }

        function start(){

            $(".coverCanvas,.dragPlace").css("height",$.drawImg.height).css("width",$.drawImg.width);
            $.drawCanvas.width=$.drawCanvas.width=$.drawImg.width;
            $.drawCanvas.height=$.drawImg.height;
            $.drawCtx.strokeStyle="green";
            $.drawCtx.lineWidth=3;

            $("#canvas").mousedown(function(e){handleMouseDown(e);});
            $("#canvas").mousemove(function(e){handleMouseMove(e);});
            $("#canvas").mouseup(function(e){handleMouseUp(e);});
            $("#canvas").mouseout(function(e){handleMouseUp(e);});
            
            
            $(".coverCanvas").mousemove(function(e){handleMouseMoveForCover(e);});
            $(".coverCanvas").mouseout(function(e){handleMouseOutForCover(e);});
        
            // redraw the image
            drawTheImage($.drawImg,$.drawImageOpacity);
            drawWhole();
            
        }

        function drawStraightLines(toX,toY){
            // clear the canvas
            $.drawCtx.clearRect(0,0,$.drawCanvas.width,$.drawCanvas.height);

            // redraw the image
            drawTheImage($.drawImg,$.drawImageOpacity);

            // redraw all previous $.drawLines
            for(var i=0;i<$.drawLines.length;i++){
                drawLine($.drawLines[i]);
            }

            for(var i=0;i<$.drawSquares.length;i++){
                drawSquare($.drawSquares[i]);
            }

            for(var i=0;i<$.drawSquaresForElevator.length;i++){
                drawSquareForElevator($.drawSquaresForElevator[i]);
            }
            
            for(var i=0;i<$.drawUplinkPoint.length;i++){
                drawUplinkPoint($.drawUplinkPoint[i]);
            }

            for(var i=0;i<$.drawSensorNode.length;i++){
                drawSensorNode($.drawSensorNode[i]);
            }

            for(var i=0;i<$.drawStraightLines.length;i++){
                drawStraightLineForWall($.drawStraightLines[i]);
            }
            
            // draw the current line
            drawStraightLine({x1:$.drawStartX,y1:$.drawStartY,x2:$.drawMouseX,y2:$.drawMouseY,color:$("#wallColor").val(),lineWidth:$("#wallThick").val(),w_type:$("#wallColor [value="+$("#wallColor").val()+"]").attr("w_type")});
        }

        function drawStraightLinesForWall(toX,toY){
            // clear the canvas
            $.drawCtx.clearRect(0,0,$.drawCanvas.width,$.drawCanvas.height);

            // redraw the image
            drawTheImage($.drawImg,$.drawImageOpacity);

            // redraw all previous $.drawLines
            for(var i=0;i<$.drawLines.length;i++){
                drawLine($.drawLines[i]);
            }

            for(var i=0;i<$.drawSquares.length;i++){
                drawSquare($.drawSquares[i]);
            }

            for(var i=0;i<$.drawSquaresForElevator.length;i++){
                drawSquareForElevator($.drawSquaresForElevator[i]);
            }
            
            for(var i=0;i<$.drawUplinkPoint.length;i++){
                drawUplinkPoint($.drawUplinkPoint[i]);
            }

            for(var i=0;i<$.drawSensorNode.length;i++){
                drawSensorNode($.drawSensorNode[i]);
            }

            for(var i=0;i<$.drawStraightLines.length;i++){
                drawStraightLineForWall($.drawStraightLines[i]);
            }
            
            var x1 = $.drawStartX;
            var x2 = $.drawMouseX;
            var y1 = $.drawStartY;
            var y2 = $.drawMouseY;
            if(Math.abs(x2-x1)>=Math.abs(y2-y1)){
                y2 = y1;
            }
            else{
                x2 = x1;
            }
            // draw the current line
            drawStraightLineForWall({x1:x1,y1:y1,x2:x2,y2:y2,color:$("#wallColor").val(),lineWidth:$("#wallThick").val(),w_type:$("#wallColor [value="+$("#wallColor").val()+"]").attr("w_type")});
        }

        function drawLines(toX,toY){
            // clear the canvas
            $.drawCtx.clearRect(0,0,$.drawCanvas.width,$.drawCanvas.height);

            // redraw the image
            drawTheImage($.drawImg,$.drawImageOpacity);

            // redraw all previous $.drawLines
            for(var i=0;i<$.drawLines.length;i++){
                drawLine($.drawLines[i]);
            }

            for(var i=0;i<$.drawSquares.length;i++){
                drawSquare($.drawSquares[i]);
            }

            for(var i=0;i<$.drawSquaresForElevator.length;i++){
                drawSquareForElevator($.drawSquaresForElevator[i]);
            }
            
            for(var i=0;i<$.drawUplinkPoint.length;i++){
                drawUplinkPoint($.drawUplinkPoint[i]);
            }

            for(var i=0;i<$.drawSensorNode.length;i++){
                drawSensorNode($.drawSensorNode[i]);
            }

            for(var i=0;i<$.drawStraightLines.length;i++){
                drawStraightLineForWall($.drawStraightLines[i]);
            }


            // draw the current line
            drawLine({x1:$.drawStartX,y1:$.drawStartY,x2:$.drawMouseX,y2:$.drawMouseY,color:$("#wallColor").val(),lineWidth:$("#wallThick").val(),w_type:$("#wallColor [value="+$("#wallColor").val()+"]").attr("w_type")});
        }

        function drawSquares(toX,toY){
            // clear the canvas
            $.drawCtx.clearRect(0,0,$.drawCanvas.width,$.drawCanvas.height);

            // redraw the image
            drawTheImage($.drawImg,$.drawImageOpacity);

            // redraw all previous $.drawLines
            for(var i=0;i<$.drawLines.length;i++){
                drawLine($.drawLines[i]);
            }

            for(var i=0;i<$.drawSquaresForElevator.length;i++){
                drawSquareForElevator($.drawSquaresForElevator[i]);
            }

            for(var i=0;i<$.drawStraightLines.length;i++){
                drawStraightLineForWall($.drawStraightLines[i]);
            }

            // draw the current line
            drawSquare({x1:$.drawStartX,y1:$.drawStartY,x2:$.drawMouseX,y2:$.drawMouseY});
        }

        function drawWhole(){
            // clear the canvas
            $.drawCtx.clearRect(0,0,$.drawCanvas.width,$.drawCanvas.height);

            // redraw the image
            drawTheImage($.drawImg,$.drawImageOpacity);

            // redraw all previous $.drawLines
            for(var i=0;i<$.drawLines.length;i++){
                drawLine($.drawLines[i]);
            }

            for(var i=0;i<$.drawSquares.length;i++){
                drawSquare($.drawSquares[i]);
            }

            for(var i=0;i<$.drawSquaresForElevator.length;i++){
                drawSquareForElevator($.drawSquaresForElevator[i]);
            }

            for(var i=0;i<$.drawUplinkPoint.length;i++){
                drawUplinkPoint($.drawUplinkPoint[i]);
            }

            for(var i=0;i<$.drawSensorNode.length;i++){
                drawSensorNode($.drawSensorNode[i]);
            }

            for(var i=0;i<$.drawStraightLines.length;i++){
                drawStraightLineForWall($.drawStraightLines[i]);
            }

        }

        function drawSquaresForElevator(toX,toY){
            // clear the canvas
            $.drawCtx.clearRect(0,0,$.drawCanvas.width,$.drawCanvas.height);

            // redraw the image
            drawTheImage($.drawImg,$.drawImageOpacity);

            // redraw all previous $.drawLines
            for(var i=0;i<$.drawLines.length;i++){
                drawLine($.drawLines[i]);
            }

            for(var i=0;i<$.drawSquares.length;i++){
                drawSquare($.drawSquares[i]);
            }

            for(var i=0;i<$.drawSquaresForElevator.length;i++){
                drawSquareForElevator($.drawSquaresForElevator[i]);
            }
            
            for(var i=0;i<$.drawUplinkPoint.length;i++){
                drawUplinkPoint($.drawUplinkPoint[i]);
            }

            for(var i=0;i<$.drawSensorNode.length;i++){
                drawSensorNode($.drawSensorNode[i]);
            }

            for(var i=0;i<$.drawStraightLines.length;i++){
                drawStraightLineForWall($.drawStraightLines[i]);
            }

            // draw the current line
            drawSquareForElevator({x1:$.drawStartX,y1:$.drawStartY,x2:$.drawMouseX,y2:$.drawMouseY});
        }

        function drawTheImage(img,opacity){
            $.drawCtx.globalAlpha=opacity;
            $.drawCtx.drawImage(img,0,0);
            $.drawCtx.globalAlpha=1.00;
        }

        function drawLine(line){
            if(line===undefined){return;}
            $.drawCtx.lineWidth=line.lineWidth;
            $.drawCtx.strokeStyle=line.color;
            $.drawCtx.beginPath();
            $.drawCtx.moveTo(line.x1, line.y1);
            $.drawCtx.lineTo(line.x2, line.y2);
            $.drawCtx.stroke();
        }

        function drawStraightLine(line){
            $.drawCtx.lineWidth=1;
            $.drawCtx.strokeStyle="#000000";
            $.drawCtx.beginPath();
            $.drawCtx.moveTo(line.x1, line.y1);
            if(line.x2-line.x1>=line.y2-line.y1){
                $.drawCtx.lineTo(line.x2, line.y1);
                $.scaleFinalX = line.x2;
                $.scaleFinalY = line.y1;
                $.scalePixel = line.x2-line.x1+1;
            }
            else{
                $.drawCtx.lineTo(line.x1, line.y2);
                $.scaleFinalX = line.x1;
                $.scaleFinalY = line.y2;
                $.scalePixel = line.y2-line.y1+1;
            }
            $.drawCtx.stroke();
        }

        function drawStraightLineForWall(line){
            if(line===undefined){return;}
            $.drawCtx.lineWidth=line.lineWidth;
            $.drawCtx.strokeStyle=line.color;
            
            $.drawCtx.beginPath();
            $.drawCtx.moveTo(line.x1, line.y1);
            $.drawCtx.lineTo(line.x2, line.y2);
            $.drawCtx.stroke();
        }



        function drawSquare(square){
            $.drawCtx.lineWidth=1;
            $.drawCtx.strokeStyle="#000000";
            $.drawCtx.beginPath();
            $.drawCtx.rect(square.x1,square.y1,square.x2-square.x1,square.y2-square.y1);
            $.drawCtx.stroke();
        }

        function drawSquareForElevator(square){
            if(square===undefined){return;}
            $.drawCtx.lineWidth=1;
            $.drawCtx.fillStyle="#770077";
            $.drawCtx.strokeStyle="#E38EFF";
            $.drawCtx.beginPath();
            $.drawCtx.rect(square.x1,square.y1,square.x2-square.x1,square.y2-square.y1);
            $.drawCtx.stroke();
            $.drawCtx.fill();
        }

        function drawUplinkPoint(uplinkPoint){
            if(uplinkPoint===undefined){return;}
            var img = new Image();
            img.onload = function(){
              $.drawCtx.drawImage(img,uplinkPoint.x-15,uplinkPoint.y-15);
              $.drawCtx.beginPath();
        //                  $.drawCtx.moveTo(uplinkPoint.x,uplinkPoint.y);
        //                  $.drawCtx.lineTo(uplinkPoint.x,uplinkPoint.y);
        //                  $.drawCtx.lineTo(uplinkPoint.x,uplinkPoint.y);
        //                  $.drawCtx.lineTo(uplinkPoint.x,uplinkPoint.y);
        //                  $.drawCtx.moveTo(30,96);
        //                  $.drawCtx.lineTo(70,66);
        //                  $.drawCtx.lineTo(103,76);
        //                  $.drawCtx.lineTo(170,15);
              $.drawCtx.stroke();
            };
            img.src = '../resources/images/'+uplinkPoint.image;
        }

        function drawSensorNode(sensorNode){
            if(sensorNode===undefined){return;}
            var img = new Image();
            img.onload = function(){
              $.drawCtx.drawImage(img,sensorNode.x-15,sensorNode.y-15);
              $.drawCtx.beginPath();
        //                  $.drawCtx.moveTo(sensorNode.x,sensorNode.y);
        //                  $.drawCtx.lineTo(sensorNode.x,sensorNode.y);
        //                  $.drawCtx.lineTo(sensorNode.x,sensorNode.y);
        //                  $.drawCtx.lineTo(sensorNode.x,sensorNode.y);
              $.drawCtx.stroke();
            };
            img.src = '../resources/images/'+sensorNode.image;

        //                $.drawCtx.rect(sensorNode.x,sensorNode.y);
        //                $.drawCtx.stroke();
        //                $.drawCtx.fill();
        }
        
        function handleMouseDown(e){

            $.initOffSetLeft = $("head").offset().left;
            $.initOffSetTop = $("head").offset().top;
            $.correctX = e.clientX-e.pageX;
            $.correctY = e.clientY-e.pageY;

            $.drawCanvasOffset=$("#canvas").offset();
            $.drawOffsetX=$.drawCanvasOffset.left-$("head").offset().left;
            $.drawOffsetY=$.drawCanvasOffset.top-$("head").offset().top;
//            console.log("handleMouseDown");
            e.stopPropagation();
            e.preventDefault();
            $.drawMouseX=parseInt(e.clientX-$.drawOffsetX);
            $.drawMouseY=parseInt(e.clientY-$.drawOffsetY);

            // Put your mousedown stuff here
            $.drawStartX=$.drawMouseX;
            $.drawStartY=$.drawMouseY;
            $.drawIsDown=true;
        }
        
        function handleMouseUp(e){
//            console.log("handleMouseUp");
            e.stopPropagation();
            e.preventDefault();
            if(!$.drawIsDown){return;}
            var infoData;
            // Put your mouseup stuff here
            $.drawIsDown=false;
            if($("#btnRequirementArea").hasClass("active")){
                $.drawSquares = [ { x1:$.drawStartX,y1:$.drawStartY,x2:$.drawMouseX,y2:$.drawMouseY } ];
                $(".btnNext:eq(0)").trigger("click");
                $("#placeForScale").css("margin-left", (($.drawStartX<$.drawMouseX?$.drawStartX:$.drawMouseX)-10)+"px");
            }
            else if($("#btnScale").hasClass("active")){
                if($.imageScale!==undefined&&$.scalePixel!==undefined)
                    $("#inputScale").val(parseInt($.imageScale*$.scalePixel));
                $("#inputScalePlace").css("left", ($.scaleFinalX+$.drawCanvasOffset.left)+"px").css("top",($.scaleFinalY+$.drawCanvasOffset.top)+"px").show();
            }
            else if($("#btnElevator").hasClass("active")){
                addOneElevator($.drawStartX, $.drawStartY, $.drawMouseX, $.drawMouseY, $.drawSquaresForElevator.length);
                $('.listOfComponent[component-type="elevator"] .list-group-item:last').trigger("click");
            }
            else if($("#btnUplinkPoint").hasClass("active")){
                var opt = $("#selectUplinkPoint [value="+$("#selectUplinkPoint").val()+"]");
                addOneUplinkPoint($.drawMouseX,$.drawMouseY,0,$.drawUplinkPoint.length,opt.attr("image"),opt.attr("device"));
                $.setAPHeightType="uplinkPoint";
                $.setAPIndex = $.drawUplinkPoint.length-1;
                $("#inputHeight").val("0");
                $("#inputHeightPlace").css("left", ($.drawMouseX+$.drawCanvasOffset.left)+"px").css("top",($.drawMouseY+$.drawCanvasOffset.top)+"px").show();
                $('.listOfComponent[component-type="uplinkPoint"] .list-group-item:last').trigger("click");
            }
            else if($("#btnSensorNode").hasClass("active")){
                var opt = $("#selectSensorNode [value="+$("#selectSensorNode").val()+"]");
                addOneSensorNode($.drawMouseX,$.drawMouseY,$("#selectSensorNode").val(),0,$.drawSensorNode.length,opt.attr("image"),opt.attr("device"));
                $.setAPHeightType="sensorNode";
                $.setAPIndex = $.drawSensorNode.length-1;
                $("#inputHeight").val("0");
                $("#inputHeightPlace").css("left", ($.drawMouseX+$.drawCanvasOffset.left)+"px").css("top",($.drawMouseY+$.drawCanvasOffset.top)+"px").show();
                $('.listOfComponent[component-type="sensorNode"] .list-group-item[index='+$.setAPIndex+']').trigger("click");
            }
            else if($("#btnDrawWall").hasClass("active")){
                addOneWall($.drawStartX,$.drawStartY,$.drawMouseX,$.drawMouseY,$("#wallColor").val(),$("#wallThick").val(),$("#wallColor [value="+$("#wallColor").val()+"]").attr("w_type"),$.drawLines.length);
                $('.listOfComponent[component-type="wall"] .list-group-item:last').trigger("click");
            }
            else if($("#btnStraightDrawWall").hasClass("active")){
                var x1 = $.drawStartX;
                var x2 = $.drawMouseX;
                var y1 = $.drawStartY;
                var y2 = $.drawMouseY;
                if(Math.abs(x2-x1)>=Math.abs(y2-y1)){
                    y2 = y1;
                }
                else{
                    x2 = x1;
                }
                addOneStraightWall(x1,y1,x2,y2,$("#wallColor").val(),$("#wallThick").val(),$("#wallColor [value="+$("#wallColor").val()+"]").attr("w_type"),$.drawStraightLines.length);
                $('.listOfComponent[component-type="straightWall"] .list-group-item:last').trigger("click");
            }
        }

        function handleMouseMove(e){
//            console.log("handleMouseMove");
            if(!$.drawIsDown){return;}
            e.stopPropagation();
            e.preventDefault();
            
            if($.initOffSetLeft === $("head").offset().left){
                $.drawMouseX=parseInt(e.clientX-$.drawOffsetX);
            }
            else{
                $.drawMouseX=parseInt(e.pageX-$.drawOffsetX+$.correctX);
            }
            if($.initOffSetTop === $("head").offset().top){
                $.drawMouseY=parseInt(e.clientY-$.drawOffsetY);
            }
            else{
                $.drawMouseY=parseInt(e.pageY-$.drawOffsetY+$.correctY);
            }

            if($("#btnRequirementArea").hasClass("active")){
                // Put your mousemove stuff here
                drawSquares($.drawMouseX,$.drawMouseY);
            }
            else if($("#btnScale").hasClass("active")){
                drawStraightLines($.drawMouseX,$.drawMouseY);
            }
            else if($("#btnElevator").hasClass("active")){
                drawSquaresForElevator($.drawMouseX,$.drawMouseY);
            }
            else if($("#btnUplinkPoint").hasClass("active")||$("#btnSensorNode").hasClass("active")){

            }
            else if($("#btnDrawWall").hasClass("active")){
                drawLines($.drawMouseX,$.drawMouseY);
            }
            else if($("#btnStraightDrawWall").hasClass("active")){
                drawStraightLinesForWall($.drawMouseX,$.drawMouseY);
            }

        }
        
        function handleMouseOutForCover(e){
//            console.log("handleMouseUp");
            e.stopPropagation();
            e.preventDefault();
            
            $(".tooltip").css("opacity",0);
        }

        function handleMouseMoveForCover(e){
            
            e.stopPropagation();
            e.preventDefault();
            
            var initOffSetLeft = $("head").offset().left;
            var initOffSetTop = $("head").offset().top;
            var correctX = e.clientX-e.pageX;
            var correctY = e.clientY-e.pageY;
            
            var drawCanvasOffset=$("#canvas").offset();
            var drawOffsetX=drawCanvasOffset.left-$("head").offset().left;
            var drawOffsetY=drawCanvasOffset.top-$("head").offset().top;
            var drawMouseX,drawMouseY;
            if(initOffSetLeft === $("head").offset().left){
                drawMouseX=parseInt(e.clientX-drawOffsetX);
            }
            else{
                drawMouseX=parseInt(e.pageX-drawOffsetX+correctX);
            }
            if(initOffSetTop === $("head").offset().top){
                drawMouseY=parseInt(e.clientY-drawOffsetY);
            }
            else{
                drawMouseY=parseInt(e.pageY-drawOffsetY+correctY);
            }
//            console.log(e.clientX,e.clientY)
            
            var drawOffsetX = drawCanvasOffset.left-$("head").offset().left;
            var drawOffsetY=drawCanvasOffset.top-$("head").offset().top;
            var x=parseInt(e.clientX-drawOffsetX), y=parseInt(e.clientY-drawOffsetY);//+68
            console.log(x ,y, $.indr_RSSI_information[y][x], drawMouseX, drawMouseY );
            $(".tooltip").css("top",y+10).css("left",x+10).css("opacity",1);
            $(".tooltip-inner").html("RSSI:"+$.indr_RSSI_information[y][x]);
//            if($.initOffSetLeft === $("head").offset().left){
//                $.drawMouseX=parseInt(e.clientX-$.drawOffsetX);
//            }
//            else{
//                $.drawMouseX=parseInt(e.pageX-$.drawOffsetX+$.correctX);
//            }
//            if($.initOffSetTop === $("head").offset().top){
//                $.drawMouseY=parseInt(e.clientY-$.drawOffsetY);
//            }
//            else{
//                $.drawMouseY=parseInt(e.pageY-$.drawOffsetY+$.correctY);
//            }
//
//            if($("#btnRequirementArea").hasClass("active")){
//                // Put your mousemove stuff here
//                drawSquares($.drawMouseX,$.drawMouseY);
//            }
//            else if($("#btnScale").hasClass("active")){
//                drawStraightLines($.drawMouseX,$.drawMouseY);
//            }
//            else if($("#btnElevator").hasClass("active")){
//                drawSquaresForElevator($.drawMouseX,$.drawMouseY);
//            }
//            else if($("#btnUplinkPoint").hasClass("active")||$("#btnSensorNode").hasClass("active")){
//
//            }
//            else if($("#btnDrawWall").hasClass("active")){
//                drawLines($.drawMouseX,$.drawMouseY);
//            }

        }
        
        function drawLinesPlace(){
            $.each($.drawLines,function(k,v){
                
            });
        }
        
        function updateComponentPos(componentType,listIndex,info,x1,y1,x2,y2){
//            var originData;
            var infoData;
            switch(componentType) {
                case "wall":
                    infoData = $.drawLines[listIndex];
                    infoData["x1"] = x1;
                    infoData["y1"] = y1;
                    infoData["x2"] = x2;
                    infoData["y2"] = y2;
                    $.drawLines[listIndex] = infoData;
                    $(".listOfComponent .active").data("info",infoData);
                    break;
                case "straightWall":
                    infoData = $.drawStraightLines[listIndex];
                    infoData["x1"] = x1;
                    infoData["y1"] = y1;
                    infoData["x2"] = x2;
                    infoData["y2"] = y2;
                    $.drawStraightLines[listIndex] = infoData;
                    $(".listOfComponent .active").data("info",infoData);
                    break;
                case "elevator":
                    infoData = $.drawSquaresForElevator[listIndex];
                    infoData["x1"] = x1;
                    infoData["y1"] = y1;
                    infoData["x2"] = x2;
                    infoData["y2"] = y2;
                    $.drawSquaresForElevator[listIndex] = infoData;
                    $(".listOfComponent .active").data("info",infoData);
                    break;
                case "uplinkPoint":
                    infoData = $.drawUplinkPoint[listIndex];
                    infoData["x"] = x1+15;
                    infoData["y"] = y1+15;
                    $.drawUplinkPoint[listIndex] = infoData;
                    $(".listOfComponent .active").data("info",infoData);
                    break;
                case "sensorNode":
                    infoData = $.drawSensorNode[listIndex];
                    infoData["x"] = x1+15;
                    infoData["y"] = y1+15;
                    $.drawSensorNode[listIndex] = infoData;
                    $(".listOfComponent .active").data("info",infoData);
                    break;
            }
            drawWhole();
        }
        
        function addOneUplinkPoint(x, y, height, index, image, device){
                var infoData = { x:x,y:y,height:height ,index:index,image:image};
                $.drawUplinkPoint.push(infoData);
                drawWhole();
                var clone = $(".list-group-item-sample").clone();
                clone.removeClass("list-group-item-sample").data("info",infoData).attr("index",index);
                clone.children("img").attr("src","../resources/images/"+image);
                clone.children("span").eq(0).remove();
                clone.children("span").eq(0).html(device+"-"+$.drawUplinkPoint.length);
                $(".listOfComponent[component-type='uplinkPoint'] .list-group").append(clone);
                autoDisplayList($('.listOfComponent[component-type="uplinkPoint"]'));
                
                var div = document.createElement("div");
                $(div).css("left",x-15).css("top",y-15).css("width",30).css("height",30).attr("component-type","uplinkPoint").attr("index",index).data("info",infoData);
                $(".dragPlace").append(div);
                dragPlaceEvent();
        }
        
        function addOneSensorNode(x, y, range, height, index, image, device){
                var infoData = { x:x,y:y,height:height ,index:index,image:image, range:range};
                $.drawSensorNode.push(infoData);
                drawWhole();
                var clone = $(".list-group-item-sample").clone();
                clone.removeClass("list-group-item-sample").data("info",infoData).attr("index",index);
                clone.children("img").attr("src","../resources/images/"+image);
                clone.children("span").eq(0).remove();
                clone.children("span").eq(0).html(device+"-"+$.drawSensorNode.length);
                $(".listOfComponent[component-type='sensorNode'] .list-group").append(clone);
                autoDisplayList($('.listOfComponent[component-type="sensorNode"]'));
                
                var div = document.createElement("div");
                $(div).css("left",x-15).css("top",y-15).css("width",30).css("height",30).attr("component-type","sensorNode").attr("index",index).data("info",infoData);
                $(".dragPlace").append(div);
                dragPlaceEvent();
        }
        
        function addOneWall(x1, y1, x2, y2, color, lineWidth, w_type, index){
                var infoData = {x1:x1, y1:y1, x2:x2, y2:y2, color:color, lineWidth:lineWidth, w_type:w_type, index:index};
                $.drawLines.push(infoData);
                drawLinesPlace();
                var clone = $(".list-group-item-sample").clone();
                clone.removeClass("list-group-item-sample").data("info",infoData).attr("index",index);
                clone.children("img").remove();
                clone.children("span").eq(0).addClass("icon-box-0").css("background-color",color);
                clone.children("span").eq(1).html($("#wallColor [value="+color+"]").html()+$.drawLines.length);
                $(".listOfComponent[component-type='wall'] .list-group").append(clone);
                autoDisplayList($('.listOfComponent[component-type="wall"]'));
                
                var div = document.createElement("div");
                $(div).css("left",x1<x2?x1:x2).css("top",y1<y2?y1:y2).css("width",Math.abs(x2-x1)).css("height",Math.abs(y2-y1)).attr("component-type","wall").attr("index",index).data("info",infoData);
                $(".dragPlace").append(div);
                dragPlaceEvent();
        }
        
        function addOneStraightWall(x1, y1, x2, y2, color, lineWidth, w_type, index){
                var infoData = {x1:x1, y1:y1, x2:x2, y2:y2, color:color, lineWidth:lineWidth, w_type:w_type, index:index};
                $.drawStraightLines.push(infoData);
                drawLinesPlace();
                var clone = $(".list-group-item-sample").clone();
                clone.removeClass("list-group-item-sample").data("info",infoData).attr("index",index);
                clone.children("img").remove();
                clone.children("span").eq(0).addClass("icon-box-0").css("background-color",color);
                clone.children("span").eq(1).html($("#wallColor [value="+color+"]").html()+$.drawLines.length);
                $(".listOfComponent[component-type='straightWall'] .list-group").append(clone);
                autoDisplayList($('.listOfComponent[component-type="straightWall"]'));
                
                var div = document.createElement("div");
                $(div).css("left",x1<x2?x1:x2).css("top",y1<y2?y1:y2).css("width",Math.abs(x2-x1)).css("height",Math.abs(y2-y1)).attr("component-type","straightWall").attr("index",index).data("info",infoData);
                $(".dragPlace").append(div);
                dragPlaceEvent();
        }
        
        function addOneElevator(x1, y1, x2, y2, index){
                var infoData = { x1:x1, y1:y1, x2:x2, y2:y2, index:index};
                $.drawSquaresForElevator.push(infoData);
                var clone = $(".list-group-item-sample").clone();
                clone.removeClass("list-group-item-sample").data("info",infoData).attr("index",index);
                clone.children("img").remove();
                clone.children("span").eq(0).remove();
                clone.children("span").eq(0).html("Elevator"+$.drawSquaresForElevator.length);
                $(".listOfComponent[component-type='elevator'] .list-group").append(clone);
                autoDisplayList($('.listOfComponent[component-type="elevator"]'));
                
                var div = document.createElement("div");
                $(div).css("left",x1<x2?x1:x2).css("top",y1<y2?y1:y2).css("width",Math.abs(x2-x1)).css("height",Math.abs(y2-y1)).attr("component-type","elevator").attr("index",index).data("info",infoData);
                $(".dragPlace").append(div);
                dragPlaceEvent();
        }
        
        function autoDisplayList(listPlace){
            var leng = listPlace.find(".list-group-item").length;
            leng==0?listPlace.hide():listPlace.show();
        }
