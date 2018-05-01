<?php

set_time_limit(0);
ini_set( "memory_limit", "256M");
ini_set('MAX_EXECUTION_TIME', -1);

//include 'config.php';
//include 'global.php';
define('upload_transient_file', "/opt/tomcat/webapps/III/resources/uploadFile/" );

$func = $_REQUEST["func"];

switch ($func) {
    case "transient_nobody":
        $echo = transient_nobody();
        break;
}

echo json_encode($echo);

function transient_nobody() {
        
        $callback = array();

        $FileName = $_FILES["file"]['name'];
        $FileSub = explode( "." , $FileName );
        $FileSub = $FileSub[count($FileSub)-1];

        if( !file_exists(upload_transient_file) ){
            mkdir(upload_transient_file, 0777, true);
        }
        $filepath_o = upload_transient_file.$_FILES["file"]['name'];
        if( file_exists($filepath_o) ) {
            unlink($filepath_o);
        }
        //$time = udate('YmdHisu');
        
        $filepath = upload_transient_file.$_FILES["file"]['name'];
        //$httppath = "http://".$_SERVER["SERVER_NAME"]."/ttshow/transient_file/".$time.".".$_REQUEST['subname'];

        move_uploaded_file( $_FILES["file"]["tmp_name"] , $filepath );
        if( file_exists($filepath) ) {
            $callback['data'] = array( "file" => $_FILES["file"]['name'] ,
                                       "ori_file" => $_FILES["file"]['name'] );
            $callback['success'] = true;
        } else {
            $callback['msg'] = "Upload fail";
            $callback['success'] = false;
        }

        return $callback;
        
}

function udate($format = 'u', $utimestamp = null) {
        if (is_null($utimestamp))
            $utimestamp = microtime(true);

        $timestamp = floor($utimestamp);
        $milliseconds = round(($utimestamp - $timestamp) * 1000000);

        return date(preg_replace('`(?<!\\\\)u`', $milliseconds, $format), $timestamp);
}

?>