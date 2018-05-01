
function sidebarInit(){
        $("#sidebarUserinfoID").html($.member.userinfo_ID);
        $("#sidebar_userinfo_UserName").html($.member.userinfo_UserName);
        $("#sidebarStar .starTag:lt("+($.member.average_evaluation)+")").addClass("active");
}

function getParameterByName(name) {
        name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
        return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function setCookie(name, value, expires, path, domain, secure){
    document.cookie= name + "=" + escape(value) +
    ((expires) ? "; expires=" + expires.toGMTString() : "") +
    ((path) ? "; path=" + path : "") +       //you having wrong quote here
    ((domain) ? "; domain=" + domain : "") +
    ((secure) ? "; secure" : "");
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
    }
    return "";
}

function delete_cookie( name, path, domain ) {
   if( getCookie( name ) ) {
     document.cookie = name + "=" +
       ((path) ? ";path="+path:"")+
       ((domain)?";domain="+domain:"") +
       ";expires=Thu, 01 Jan 1970 00:00:01 GMT";
   }
}

$.Ajax = function ( type , url , data , data2 , back , error_back)
{
           if( error_back == "" ) {
                   error_back = function(e) { console.log(e); };
           }
           $.ajax({
                       type : type ,
                       url : url ,
                       async: true ,
                       data : data ,
                       data2 : data2 ,
                       success : back ,
                       error : error_back
           });
}

function containsAllAscii(str) {
    return  /^[\000-\177]*$/.test(str) ;
}

function getStrLength( str ) {

    return str.replace(/[^\x00-\xff]/g,"xx").length;

}

function getInterceptedStr(sSource, iLen)
{
    if(sSource.replace(/[^\x00-\xff]/g,"xx").length <= iLen)
    {
            return sSource;
    }

    var str = "";
    var l = 0;
    var schar;
    for(var i=0; schar=sSource.charAt(i); i++)
    {
            str += schar;
            l += (schar.match(/[^\x00-\xff]/) != null ? 2 : 1);
            if(l >= iLen)
            {
                break;
            }
    }

    return str;
}


function notification_cb( msg )
{
    //show_remind( "os="+msg.os+ " ,app="+msg.app+ " ,udid="+msg.udid+ " ,token="+msg.token );
    $.noti_token = msg.token;
    var data = {
                os:  msg.os ,
                app:  msg.app ,
                udid:  msg.udid ,
                token:  msg.token
    };
    var success_back = function( data ) {

            //show_remind( data );

    };
    var error_back = function( data ) {
            console.log(data);
    };
    $.Ajax( "GET" , "php/mobile_API/insertToken.php" , data , "" , success_back , error_back);
    
}

function loading_ajax_show()
{
        $( "#loading" ).css( "z-index" , "9999" );
        $( "body" ).css( "overflow" , "hidden" );
//        $( "body" ).css( "display" , "none" );
        $( "#loading" ).show();
}
function loading_ajax_hide()
{ 
        $( "#loading" ).css( "z-index" , "-999" );
        $( "body" ).css( "overflow" , "auto" );
//        $( "body" ).css( "display" , "block" );
        $( "#loading" ).hide();
}

function show_remind( msg , state ) {
        state = state || "success";
        if( window.Web2App ) {
            //window.Web2App.ttt( msg );
        }
        else if( $.notify ) {
            if( state === "success" || state === "error" ){
                $.notify( msg , {  className: state, position:"middle center" });//bottom center
            }
            else
                $.notify( msg , {  className: "success", position:"middle center" });//bottom center
        }
        else {
            alert( msg );
        }
}

function difference_now( time ) {

        var callback;
        time = time.split(" ");
        var time1 = time[0].split( "-" );
        var time2 = time[1].split( ":" );
        var old_time = new Date( parseInt(time1[0]),parseInt(time1[1])-1,parseInt(time1[2]),parseInt(time2[0]),parseInt(time2[1]),parseInt(time2[2]) );
        var now_time = new Date();
        var difference = now_time.getTime() - old_time.getTime();
        var difference_sec = parseInt( difference/1000 );
        //callback["same_m"] = ( old_time.getMonth() === now_time.getMonth() && old_time.getFullYear() === now_time.getFullYear() ) ? true : old_time.getFullYear() + "-" + ( old_time.getMonth() + 1 );
        if( difference_sec < 60 ) {
            callback = difference_sec + " 秒";
        }
        else if( difference_sec < 60*60 ) {
            callback = parseInt( difference_sec/60 ) + " 分";
        }
        else if( difference_sec < 24*60*60 ) {
            callback = parseInt( difference_sec/60/60 ) + " 小時";
        }
        else if( difference_sec < 30*24*60*60 ) {
            callback = parseInt( difference_sec/60/60/24 ) + " 天";
        }
        else if( difference_sec < 12*30*24*60*60 ) {
            callback = parseInt( difference_sec/30/60/60/24 ) + " 月";
        }
        else{
            callback = parseInt( difference_sec/12/30/60/60/24 ) + " 年";
        }
        return callback;
}

function clear_input(){
        
        $( "input:not([type=button])" ).val( "" );
        $( "textarea" ).val( "" );
        
}


function scrollto( pos , time ){
        time = time || 1000;
        $('html, body').animate({
            scrollTop: pos.offset().top - $(window).height()/2
        }, time);
}

function isNumberKey(evt){
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
}

function GetDecimals( num , decimals ){
        //取小數點位數
        var tmp = Math.pow(10,decimals);
        return Math.floor(parseFloat(num)*tmp)/tmp;
}

function getCloseHundred( num ){
        if(num<50){
            return Math.round(num/10)*10;
        }
        else if(num<500){
            return Math.round(num/100)*100;
        }
        else if(num<5000){
            return Math.round(num/1000)*1000;
        }
        else if(num<50000){
            return Math.round(num/10000)*10000;
        }
        else if(num<500000){
            return Math.round(num/100000)*100000;
        }
            
}

function GetReadNumber( num ){
        
        var _tmp;
        var tmp = Math.floor(parseFloat(num));
        var length = String(tmp).length;
        if( length >= 7 ){
            _tmp = length - 7 > 3 ? 3 : length - 7 ;
            return Math.floor(tmp/Math.pow(10,3+_tmp))/Math.pow(10,3-_tmp) + "M";
        }
        else if( length >= 4 ){
            _tmp = length - 4 > 3 ? 3 : length - 4 ;
            return Math.floor(tmp/Math.pow(10,0+_tmp))/Math.pow(10,3-_tmp) + "K";
        }
        else{
            return GetDecimals( num , 1 );
        }
}

function NumConverteChinese( num ){
    
    if( typeof num === "number" ){
            String( num ).length;
    }
    return false;
}

function NumGetDigit( num ){
    
    
}

function YearFunction(sel)
{
        var tmp = "";
        if( $("[type=month]").val() === "02" )
        {
                if( parseInt( $(sel).val() )%4 === 0 )
                    var days = 29;
                else
                    var days = 28;
                for( var i=1 ; i<=days ; i++ )
                {
                        if( i < 10 )
                            tmp += '<option value=0' + i + '>' + i + '?��</option>';
                        else
                            tmp += '<option value=' + i + '>' + i + '?��</option>';
                }
                $("[type=day]").html(tmp);
        }
}
function MonthFunction(sel)
{
        var tmp = "";
        switch( $(sel).val() )
        {
        case "01":
        case "03":
        case "05":
        case "07":
        case "08":
        case "10":
        case "12":
          var days = 31;
          break;
        case "04":
        case "06":
        case "09":
        case "11":
          var days = 30;
          break;
        case "02":
          if( parseInt( $("[type=year]").val() )%4 === 0 )
              var days = 29;
          else
              var days = 28;
          break;
        }
        for( var i=1 ; i<=days ; i++ )
        {
                if( i < 10)
                    tmp += '<option value=0' + i + '>' + i + '?��</option>';
                else
                    tmp += '<option value=' + i + '>' + i + '?��</option>';
        }
        $("[type=day]").html(tmp);
}

/*
例�??:你�?�在45??�面補到字傳?��度為5??��?�串，�?�就要呼?��paddingLeft( 45 , 5 )
得到??��?��?�就??�是00045
*/
function paddingLeft(str,lenght){
        if( str != undefined )
        {
                if( typeof str == "number" )
                    str = str.toString();

                if(str.length >= lenght)
                return str;
                else
                return paddingLeft("0" +str,lenght);
        }
        else
        {
                return "" ;
        }
}
function paddingRight(str,lenght){
    
        if( typeof str == "number" )
            str = str.toString();
        
	if(str.length >= lenght)
	return str;
	else
	return paddingRight(str+"0",lenght);
}



$.globalLang = { "zh-tw":{}, "en-us":{} };
$("document").ready(function() {
        
        if( isEmpty( getCookie( "IIITranslate" ) ) )
            setCookie( "IIITranslate" ,"en-us" , "", "/" );
        
	doTranslate( getCookie("IIITranslate") , $.globalLang[ getCookie("IIITranslate") ] );
        
});

$.strToMoneyNumber = function(str) {
    str = str.toString().split(".");
    var val = str[0].replace(/\,/g,"").split("").reverse();
    var money = "";
    for(var i=0;i<val.length;i++) {
        if((i)%3 == 0 && i != 0) {
            money = "," + money;
        }
        money = val[i] + money;
    }
    if(str[1] != undefined) {
        money += "." + str[1];
    }
    return money;
}

/** 檢查input?��?��?���?
 * @param object valid {
                     bool: true?��?���?/false??�錯�?
                     ,msg: string?��誤�?�息
                 }
 * @param array id jquery select string
 * @param string str replace String
 * @return valid
 */
$.isValidRequiredField = function(valid, requiredField, str) {
    var tag = {}, errorMsg = "";
    for(var i=0;i<requiredField.length;i++) {
        tag = $(requiredField[i]);
        if(["INPUT", "TEXTAREA", "SELECT"].indexOf(tag[0].tagName) != -1) {
            if(tag.val() === "" || tag.val() === null) {
                tag.closest(".form-group").addClass("has-error").removeClass("has-success");
                valid["bool"] = false;
                if(valid["msg"] ==="") {
                    errorMsg = "Please input " + requiredField[i].replace(str, "");
                } else {
                    errorMsg = "?�input " + requiredField[i].replace(str, "");
                }
                valid["msg"] += errorMsg;
            }
        } else {
            if(tag.html() == "" || tag.data("data") == undefined) {
                tag.closest(".form-group").addClass("has-error").removeClass("has-success");
                valid["bool"] = false;
                if(valid["msg"] ==="") {
                    errorMsg = "Please input " + requiredField[i].replace(str, "");
                } else {
                    errorMsg = "?�input " + requiredField[i].replace(str, "");
                }
                valid["msg"] += errorMsg;
            }
        }
    }

    return valid;
}

/** 檢查email?���?
 * @param object valid {
                     bool: true?��?���?/false??�錯�?
                     ,msg: string?��誤�?�息
                 }
 * @param array id jquery select string
 * @param string str replace String
 * ??��?�網??:http://stackoverflow.com/questions/2855865/jquery-regex-validation-of-e-mail-address
 * @return valid
 */
$.isValidEmailAddress = function(valid, requiredField, str) {
    var pattern = /^([a-z\d!#$%&'*+\-\/=?^_`{|}~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+(\.[a-z\d!#$%&'*+\-\/=?^_`{|}~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+)*|"((([ \t]*\r\n)?[ \t]+)?([\x01-\x08\x0b\x0c\x0e-\x1f\x7f\x21\x23-\x5b\x5d-\x7e\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|\\[\x01-\x09\x0b\x0c\x0d-\x7f\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))*(([ \t]*\r\n)?[ \t]+)?")@(([a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|[a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF][a-z\d\-._~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]*[a-z\d\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])\.)+([a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]|[a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF][a-z\d\-._~\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]*[a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])\.?$/i;
    var input = {}, errorMsg = "";
    for(var i=0;i<requiredField.length;i++) {
        input = $(requiredField[i]);
        if(input.val() != "" && !pattern.test(input.val())) {
            input.closest(".form-group").addClass("has-error").removeClass("has-success");
            valid["bool"] = false;
            if(valid["msg"] ==="") {
                errorMsg = "Malformed email addresses";
            } else {
                errorMsg = "?�Malformed email addresses";
            }
            valid["msg"] += errorMsg;
        }
    }
    return valid;
}

/** ??�制input?��?��輸入?���?
 * ??�制input輸入?���?
 * @param string id jquery select string
 * @param int length 輸入??�長�?
 * ??��?�網??:http://stackoverflow.com/questions/995183/how-to-allow-only-numeric-0-9-in-html-inputbox-using-jquery
 */
$.inputOnlyNumber = function(id, length) {
    $(id).keydown(function (e) {
        var val = $(this).val();
        // Allow: backspace, delete, tab, escape, enter and .
        if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
             // Allow: Ctrl+A, Command+A
            (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) || 
             // Allow: home, end, left, right, down, up
            (e.keyCode >= 35 && e.keyCode <= 40)) {
                 // let it happen, don't do anything
                 return;
        }
        // Ensure that it is a number and stop the keypress
        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
            e.preventDefault();
        }
        if(length && val.length > length) {
            e.preventDefault();
        }
    });
}

function doTranslate( lang , langObj )
{

        if( isEmpty( langObj ) )
        {
                var data = {};
                var success_back = function( data ) {
                        data = JSON.parse(data);
                        console.log(data);
                        $.globalLang[lang] = data[0];
                        //show_remind( data );
                        doTranslate( lang , data[0] );
                };
                var error_back = function( data ) {
                        console.log(data);
                };
                $.Ajax( "GET" , "../resources/lang/"+lang+".html" , data , "" , success_back , error_back);
        }
        else
        {
                $.each( langObj , function(k,v){
//                        console.log(k);
                        $("[translate='" + k + "']").html(v);
                        if(lang==="en-us"){
                            $("[translate='" + k + "']").addClass("en-us-style");
                        }
                        else{
                            $("[translate='" + k + "']").removeClass("en-us-style");
                        }
                });
                $.each( $("[hzh-tw]") , function(k,v){
                        $(v).html($(v).attr("h"+lang));
                        if(lang==="en-us"){
                            $(v).addClass("en-us-style");
                        }
                        else{
                            $(v).removeClass("en-us-style");
                        }
                });
//                setCookie( "IIITranslate" ,lang );
                setCookie( "IIITranslate" ,lang , "", "/" );
                
        }
}

function isEmpty(obj) {

    // null and undefined are "empty"
    if (obj == null) return true;

    // Assume if it has a length property with a non-zero value
    // that that property is correct.
    if (obj.length > 0)    return false;
    if (obj.length === 0)  return true;

    // If it isn't an object at this point
    // it is empty, but it can't be anything *but* empty
    // Is it empty?  Depends on your application.
    if (typeof obj !== "object") return true;

    // Otherwise, does it have any properties of its own?
    // Note that this doesn't handle
    // toString and valueOf enumeration bugs in IE < 9
    for (var key in obj) {
        if (hasOwnProperty.call(obj, key)) return false;
    }

    return true;
}

window.mobilecheck = function() {
  var check = false;
  (function(a){if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4))) check = true;})(navigator.userAgent||navigator.vendor||window.opera);
  return check;
};

window.mobileAndTabletcheck = function() {
  var check = false;
  (function(a){if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino|android|ipad|playbook|silk/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4))) check = true;})(navigator.userAgent||navigator.vendor||window.opera);
  return check;
};

function arrayValue(array){
    var returnArr = [];
    $.each(array,function(k,v){
        if(v!==undefined)
            returnArr[returnArr.length] = v;
    });
    return returnArr;
}


function calculateBothDistanceAndInitPower(chooseTable){
        
        var returnJson = {};
        
        var pos = chooseTable.find("input");
        
//        var sensor_rx_power = $("#sensorNodeAttr").find("input").eq(0).val();
        var sensor_cable_loss_rx = parseInt( $("#sensorNodeAttr").find("input").eq(1).val() );
        var sensor_antenna_gain_rx = parseInt( $("#sensorNodeAttr").find("input").eq(2).val() );
        var sensor_freq = parseInt( $("#sensorNodeAttr").find("input").eq(3).val() );
        
        var tx_power = parseInt( pos.eq(0).val() );
        var cable_loss_tx = parseInt( pos.eq(1).val() );
        var antenna_gain_tx = parseInt( pos.eq(2).val() );
        
        var freq = parseInt( pos.eq(3).val() );
        var cable_loss_rx = parseInt( pos.eq(5).val() );
        var antenna_gain_rx = parseInt( pos.eq(6).val() );
        
        var tmpArr = calculateDistanceAndInitPower( tx_power, cable_loss_tx, antenna_gain_tx, sensor_cable_loss_rx, sensor_antenna_gain_rx, sensor_freq );
        
        returnJson["meshAndSSNRange"] = tmpArr[0];
        returnJson["meshAndSSNInitPower"] = tmpArr[1];
        
        var tmpArr = calculateDistanceAndInitPower( tx_power, cable_loss_tx, antenna_gain_tx, cable_loss_rx, antenna_gain_rx, freq );
        
        returnJson["apAndApRange"] = tmpArr[0];
        returnJson["apAndApInitPower"] = tmpArr[1];
        
        return returnJson;
}

function calculateDistanceAndInitPower( tx_power, cable_loss_tx, antenna_gain_tx, cable_loss_rx, antenna_gain_rx, freq ){
        
        console.log( "tx_power="+tx_power );
        console.log( "cable_loss_tx="+cable_loss_tx );
        console.log( "antenna_gain_tx="+antenna_gain_tx );
        console.log( "cable_loss_rx="+cable_loss_rx );
        console.log( "antenna_gain_rx="+antenna_gain_rx );
        console.log( "freq="+freq );
        
        var rx_power = -60;
        
        var rssi, pathloss;

        /* inspired by Stefan Teuscher ... DANKE FUER DEN INPUT !!!!!!!!!*/

        var offset_tx = 0;
//        if(document.generator.tx_dB[0].checked) {offset_tx = 0;};
//        if(document.generator.tx_dB[1].checked) {offset_tx = 2.15;};

        var offset_rx = 0;
//        if(document.generator.rx_dB[0].checked) {offset_rx = 0;};
//        if(document.generator.rx_dB[1].checked) {offset_rx = 2.15;};

        /* inspired by Jonathan Mlsna ... Thank You !!!! */

        antenna_gain_tx = antenna_gain_tx + offset_tx;
        antenna_gain_rx = antenna_gain_rx + offset_rx;

//        var antenna_out = ( tx_power ) - ( cable_loss_tx ) + ( antenna_gain_tx );

//        var antenna_in = antenna_out - pathloss ;

//        var rx_in = antenna_in - cable_loss_rx ;

        pathloss = tx_power - rx_power - cable_loss_tx - cable_loss_rx + antenna_gain_tx + antenna_gain_rx ;
        pathloss = Math.round ( pathloss * 1000) / 1000 ;
        
        var distance = Math.exp( ( pathloss - 32.44 - 20 * Math.log(freq)/2.302585093 )/20 *2.302585093 ) ;
        distance = distance * 1000 ; //meter
        
        var arr = [ distance.toString() ];
        console.log( "distance="+distance );
        
        //if distance = 1 meter
        pathloss = 32.44 + 20 * Math.log(freq)/2.302585093 + 20 * Math.log(0.001)/2.302585093 ;
        pathloss = Math.round ( pathloss * 1000) / 1000 ;
        
        var initRssi = Math.round (100*(tx_power - pathloss - cable_loss_tx - cable_loss_rx + antenna_gain_tx + antenna_gain_rx ))/100;
        
        arr[arr.length] = initRssi.toString();
        
        console.log( "initRssi="+initRssi );
        
        return arr;
        
        
}
        
function arraySearch(arr,val) {
    for (var i=0; i<arr.length; i++)
        if (arr[i] === val)                    
            return i;
    return false;
}

function openProject(jsonObject_unpack, imagePath){
    console.log( jsonObject_unpack );
    console.log( imagePath );
    
    initParameters();
    if(imagePath!==""){
        $.imgZoom = jsonObject_unpack.imgZoom;
        imgInitCanvasForUrl(imagePath);
    }
    else{
        //need to add
        $.imgZoom = 1;
    }
    
    $.drawRequirementAreaPolygonals = jsonObject_unpack.drawRequirementAreaPolygonals;
    drawWhole();
//    $.requirementAreaPixel = getRequirementAreaPixel();
    
    
    //update jsonObject_unpack
    $.drawLines = jsonObject_unpack.drawLines;
    $.drawStraightLines = jsonObject_unpack.drawStraightLines;
    $.drawSquares = jsonObject_unpack.drawSquares;
    $.drawSquaresForElevator = jsonObject_unpack.drawSquaresForElevator;
    $.drawUplinkPoint = jsonObject_unpack.drawUplinkPoint;
    $.drawSensorNode = jsonObject_unpack.drawSensorNode;
    $.drawRegionClassifications = jsonObject_unpack.drawRegionClassifications;
    $.drawRegionClassificationsTemp = jsonObject_unpack.drawRegionClassificationsTemp;
    $.drawRequirementAreaPolygonalsTemp = jsonObject_unpack.drawRequirementAreaPolygonalsTemp;
    drawWhole();
    resetCanvasComponent();
    
    $.deploymentType = jsonObject_unpack.deploymentType;
    
    var deployApType = jsonObject_unpack.deployApType;
    $('[name="apType"][value="'+deployApType+'"]').click();
    $('[id=selectApValue][for='+deployApType+']').val( jsonObject_unpack.ap.range );
    $("[id=inputAPHeight][for="+deployApType+"]").val( jsonObject_unpack.ap.height );
    
    var pos = $("table[for="+deployApType+"]");
    
    
    pos.eq(0).val( jsonObject_unpack.deployPara[0] );
    pos.eq(1).val( jsonObject_unpack.deployPara[1] );
    pos.eq(2).val( jsonObject_unpack.deployPara[2] );
    pos.eq(3).val( jsonObject_unpack.deployPara[3] );
    pos.eq(5).val( jsonObject_unpack.deployPara[4] );
    pos.eq(6).val( jsonObject_unpack.deployPara[5] );
    
    $.imageScale = jsonObject_unpack.scale;
    
    $("#sensorNodeAttr").find("input").eq(1).val( jsonObject_unpack.sensorNode[0] );
    $("#sensorNodeAttr").find("input").eq(2).val( jsonObject_unpack.sensorNode[1] );
    $("#sensorNodeAttr").find("input").eq(3).val( jsonObject_unpack.sensorNode[2] );
//                        sensorNode: JSON.stringify(  ),
//                        
//                    }
    //check show operate list
//     $.each(data.Deployed_AP_pos,function(k,v){
//        if(k>=manuallyDeployNum)
//            addOneUplinkPoint(v.x, v.y, parseFloat($("[id=inputAPHeight][for="+deployApType+"]").val()), $.drawUplinkPoint.length, optTag.attr("image"), optTag.attr("device"))
//    });
    
    $.each($('.listOfComponent[component-type]'),function(k,v){
        autoDisplayList($(v));
    });
    
    
    var arr = [ "1-1", "1-2", "2-1", "2-2", "2-3", "3-1", "4-1", "4-2", "5-1" ];
    var key = arraySearch(arr,jsonObject_unpack.nowPage);
    if(key==0){
        $.nowPage = arr[key];
        go2Steps($.nowPage);
    }
    else{
        $.nowPage = arr[key-1];
        $(".btnNext").eq(0).trigger("click");
    }
}

function showSensorNodeRSSI(e){
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

        var drawOffsetX = drawCanvasOffset.left-$("head").offset().left;
        var drawOffsetY=drawCanvasOffset.top-$("head").offset().top;
        var x=parseInt(e.clientX-drawOffsetX), y=parseInt(e.clientY-drawOffsetY);//+68
        console.log(x ,y );
}

//document.body.onclick = function (e) {
//    var isRightMB;
//    e = e || window.event;
//
//    if ("which" in e)  // Gecko (Firefox), WebKit (Safari/Chrome) & Opera
//        isRightMB = e.which == 3; 
//    else if ("button" in e)  // IE, Opera 
//        isRightMB = e.button == 2; 
//    
//    console.log(isRightMB)
////    alert("Right mouse button " + (isRightMB ? "" : " was not") + "clicked!");
//} 
