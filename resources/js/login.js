
$("document").ready(function() {
        
        if( isEmpty( getCookie( "III_Token" ) ) ){
            var lang = isEmpty( getCookie( "IIITranslate" ) ) ? "en-us" : getCookie( "IIITranslate" );
            if(lang==="en-us"){
                swal("Please Login. Jump To Page After Three Seconds","","error");
            }
            else{
                swal("未登入，三秒後轉跳到登入","","error");
            }
            setTimeout( function(){ location.href = "../"; }, 3000);
        }
        else{
            checkLogin();
        }
        
});

function checkLogin(){
        $.ajax({
            type:"POST",
            dataType: "text",
            url: "jsp/account.jsp",
            data: {
                "func": "loginByToken",
                "token": getCookie( "III_Token" )
            },
            success: function(data){
                console.log(data);
                data = JSON.parse(data);
                if( data.success ) {
                        
                }
                else 
                {
                        var lang = isEmpty( getCookie( "IIITranslate" ) ) ? "en-us" : getCookie( "IIITranslate" );
//                        swal($.globalLang[lang]["PLEASE_LOGIN"],"","error");
                        if(lang==="en-us"){
                            swal("Please Login. Jump To Page After Three Seconds","","error");
                        }
                        else{
                            swal("未登入，三秒後轉跳到登入","","error");
                        }
                        setTimeout( function(){ location.href = "../"; }, 3000);
                } 
            },
            error:function(xhr, ajaxOptions, thrownError){ 
                console.log(xhr.status); 
                console.log(thrownError); 
            }
        });
}
