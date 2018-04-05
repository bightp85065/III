$(document).ready(function() {
        
        upload_event();
        
});

function allowSubname( val ) {
        
        var subname;
        val = val || "all";
        
        switch( val ){
            case "jpg":
                subname = [ "jpg" ];
                break;
            case "images":
                subname = [ "jpg" , "jpeg" , "png" , "gif" ];
                break;
        }
        return subname;
}

function allowSize( val ) {
        
        var object;
        
        switch( val ){
            case "type1":
                object = {"width":323,"height":400};
                break;
        }
        return object;
}

function upload_event()
{
            //example-basic
            $("#subContent,#example-basic").delegate("#mapUpload","change",function(e){
                    
                    var JudgeFilesType = e.originalEvent.target.files[0].name.split(".");
                    JudgeFilesType = JudgeFilesType[JudgeFilesType.length-1];
                    JudgeFilesType = JudgeFilesType.toLowerCase();

                    var allow = "images";//$( this ).attr( "allow" )

                    if( typeof allow === "undefined" ){

                    }
                    else{
                        allow = allowSubname( allow );
                        if( $.inArray( JudgeFilesType , allow ) === -1 ) {
                            show_remind( "please upload " + allow.join( "、" ) + " file" , "error" );
                        }
                    }


                        var files = e.originalEvent.target.files;
                        $.debugFiles = files;
                        if( $( this ).attr( "size" ) ){
                            var size2 = $( this ).attr( "size" );
                            // check upload img width height
                            var _URL = window.URL || window.webkitURL;
                            var file, img;
                            if ((file = this.files[0])) {
                                img = new Image();
//                                    img.setAttribute("size", size2);
                                img.onload = function onload() {
//                                        var size = this.getAttribute("size");
                                    var size = allowSize( size2 );
                                    if( size.width !== this.width || size.height !== this.height ){
                                            show_remind( "please check width:"+size.width+"，height"+size.height+"" , "error");
                                            return false;
                                    }
//                                    handleFileUpload( files , $( "[id='bar'][target='"+$(e.target).attr("target")+"']" ) , "transient2" , $(e.target) );
                                    imgInitCanvas(files[0]);
                                    $("#mapUploadFileName").val(files[0]["name"]);
                                    
                                };
                                img.src = _URL.createObjectURL(file);
                            }

                        }
                        else{
                            imgInitCanvas(this.files[0]);
                            $("#mapUploadFileName").val(this.files[0]["name"]);
//                            handleFileUpload( files , $( "[id='bar'][target='"+$(e.target).attr("target")+"']" ) , "transient2" , $(e.target) );
                            
                        }
//                        }
                    e.preventDefault();
                    
            });
            
            $( ".clear_upload" ).unbind('click').bind('click', function(e) {
                    var target = $( this ).attr( "target" );
                    if( $("#"+target).prop("tagName")==="DIV" )
                        $( "#" + target ).css( "background-image" , "url('"+website_no_img_url+"')" );
                    else if( $("#"+target).prop("tagName")==="IMG" )
                        $( "#" + target ).attr( "src" , website_no_img_url );
                    $.upload_file[ target ] = "CLEAR";
            });
}

function handleFileUpload(files,obj,func,event)
{
        for (var tmp = 0; tmp < files.length; tmp++) 
        {
                
                console.log(this);
                var fd = new FormData();
                fd.append('file', files[tmp]);

                var status = new createStatusbar(obj); //Using this we can set progress.
                status.setFileNameSize(files[tmp].name,files[tmp].size);
                
                sendHtmlToServer(fd,files[tmp],status,func,event);//["1036_vincent_5-46","1037_vincent_5-47","1038_vincent_5-48"]
                
        }
}

var rowCount=0;
function createStatusbar(obj)
{
            rowCount++;
            var row="odd";
            if(rowCount %2 ===0) row ="even";
            this.statusbar = $("<div class='statusbar "+row+"'></div>");
            this.filename = $("<div class='filename'></div>").appendTo(this.statusbar);
            this.size = $("<div class='filesize'></div>").appendTo(this.statusbar);
            this.progressBar = $("<div class='progressBar'><div></div></div>").appendTo(this.statusbar);
            this.abort = $("<div class='abort'>Abort</div>").appendTo(this.statusbar);
            this.statusbar.attr("class","")
            obj.append(this.statusbar);

           this.setFileNameSize = function(name,size)
           {
                        var sizeStr="";
                        var sizeKB = size/1024;
                        if(parseInt(sizeKB) > 1024)
                        {
                                var sizeMB = sizeKB/1024;
                                sizeStr = sizeMB.toFixed(2)+" MB";
                        }
                        else
                        {
                                sizeStr = sizeKB.toFixed(2)+" KB";
                        }

                        this.filename.html(name);
                        this.size.html(sizeStr);
           };
           this.setProgress = function(progress)
           {
                        var progressBarWidth =progress*this.progressBar.width()/ 100;  
                        this.progressBar.find('div').animate({ width: progressBarWidth }, 10).html(progress + "% ");
                        if(parseInt(progress) >= 100)
                        {
                                this.abort.hide();
                                //bohan
                                this.abort.parent().prev().prev().show();
                                //this.abort.parent().next().children().attr( "src" , "" );
                                //this.abort.parent().next().show();
                                this.abort.parent().remove();
                        }
           };
           this.setAbort = function(jqxhr)
           {
                        var sb = this.statusbar;
                        this.abort.click(function()
                        {
                                jqxhr.abort();
                                if( $.upload_file != undefined && $.upload_file.upload == "transient_file" ) {
                                        $("#usericon").css("background-image",'url("template/assets/img/icon_uplaod-02.png")');
                                        $("#usericon").attr("img", "" );
                                        $("#cooperate_icon").css("background-image",'url("template/assets/img/icon_uplaod-02.png")');
                                        $("#cooperate_icon").attr("img", "" );
                                }
                                sb.hide();
                        });
           };
}

function sendHtmlToServer( formData , file , status , func , event , backup_name )
{
            var uploadURL;
            
            uploadURL ='service/upload/tempFile';
//                    + '&Image_name=' + $("#Add_Image_name").val()
//                    + '&Artist=' + $("#Add_Artist").val()
//                    + '&Type=' + $("#Add_Type").val()
//                    + '&Medium=' + $("#Add_Medium").val()
//                    + '&Style=' + $("#Add_Style").val()
//                    + '&AskingPrice=' + $("#Add_AskingPrice").val()
            
            
            var extraData ={};
            var jqXHR=$.ajaxq("aaa",{
                        xhr: function() {
                                    var xhrobj = $.ajaxSettings.xhr();
                                    if (xhrobj.upload) {
                                                xhrobj.upload.addEventListener('progress', function(event) {
                                                            var percent = 0;
                                                            var position = event.loaded || event.position;
                                                            var total = event.total;
                                                            if (event.lengthComputable) {
                                                                                    percent = Math.ceil(position / total * 100);
                                                            }
                                                            //Set progress
                                                            status.setProgress(percent);
                                                }, false);
                                    }
                                    return xhrobj;
                        },
                        headers: {
                                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content') ,
                                    'Authorization': "Token "+getCookie("hochienbirdsCookie")
                        },
                        url: uploadURL,
                        type: "POST",
                        contentType:false,
                        processData: false,
                        cache: false,
                        data: formData,
                        data2 : event,
                        //dataType: "json",
                        success: function(data){
                                console.log(data);
                                var data = JSON.parse( data );
                                console.log(data);
                                if( data.success ){
                                    
//                                    if(func==="transient"){
//                                        show_remind("上傳??��??");
//                                        $.upload_file_transient[ $.upload_file_transient.length ] = data.data.file;
//                                        $.upload_file[ this.data2 ] = data.data.file;
////                                        if( this.data2==="adImage" ){
////                                            
////                                        }
//                                        if( $( "#" + this.data2 ).attr( "data-show" ) === "text" ){
//                                                $( "#" + this.data2 ).val( data.data.ori_file );
//                                        }
//                                        else{
//                                            if( $( "#" + this.data2 ).prop("tagName")==="IMG" )
//                                                $( "#" + this.data2 ).attr( "src" , data.data.path + data.data.file );
//                                            else
//                                                $( "#" + this.data2 ).css( "background-image" , "url('" + data.data.path + data.data.file + "')" );
//                                        }
//                                        
//                                        if( this.data2==="profileUserIcon" ){
//                                            $("#checkUploadUserIcon").removeClass("display-none");
//                                        }
//                                        else if( this.data2==="addSliderImage" ){
//                                            $("#addSliderImageText").html(data.data.ori_file);
//                                        }
//                                        else if( this.data2==="modifySliderImage" ){
//                                            $("#modifySliderImageText").html(data.data.ori_file);
//                                        }
//                                        else if( this.data2==="addProductTypeImage" ){
//                                            $("#addProductTypeImageText").html(data.data.ori_file);
//                                        }
//                                        else if( this.data2==="modifyProductTypeImage" ){
//                                            $("#modifyProductTypeImageText").html(data.data.ori_file);
//                                        }
//                                        
//                                    }
//                                    else if(func==="transient2"){
//                                        show_remind("");
//                                        $.upload_file_transient[ $.upload_file_transient.length ] = data.data.file;
////                                        $.upload_file[ this.data2 ] = data.data.file;
////                                        if( this.data2==="adImage" ){
////                                            
////                                        }
//                                        var pos = this.data2.prev().prev();
//                                        if( pos.attr( "data-show" ) === "text" ){
//                                                pos.val( data.data.ori_file );
//                                        }
//                                        else{
//                                            if( pos.prop("tagName")==="IMG" )
//                                                pos.attr( "src" , data.data.path + data.data.file ).attr("data",data.data.file);
//                                            else
//                                                pos.css( "background-image" , "url('" + data.data.path + data.data.file + "')" );
//                                        }
//                                        
//                                        pos.prev().html(data.data.ori_file);
//                                        
//                                    }
                                }
                                else{
                                    show_remind( data.msg , "error" );
                                }
                                
                        }
            });

            status.setAbort(jqXHR);
}

var delete_transient_file = function( filename ) {
        $.ajax({
            type:"POST",
            dataType: "text",
            url: "service/upload/delTemp",
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content'),
                'Authorization': "Token "+getCookie( "hochienbirdsCookie" )
            },
            data: {
                transient_file : filename
            },
            success: function(data){
                console.log(data);
                data = JSON.parse(data);
                if( data.success ) {
                        
                }
                else {
                        
                }
            },
            error:function(xhr, ajaxOptions, thrownError){ 
                console.log(xhr.status); 
                console.log(thrownError); 
            }
        });
//        $.ajax({
//                    type: "POST",
//                    url: "php/user_upload_image.php?func=",
//                    data : {
//                        transient_file : filename
//                    },
//                    success: function( data ) { return null; } ,
//                    error: function( data ) {  }
//        });
}
$(window).on('beforeunload', function(){
        $.each( $.upload_file_transient , function(index, value) {
                delete_transient_file( value );
        });
});
$(window).unload( function(){
        $.each( $.upload_file_transient , function(index, value) {
                delete_transient_file( value );
        });
});
