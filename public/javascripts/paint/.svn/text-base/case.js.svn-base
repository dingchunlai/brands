jQuery(document).ready(function($) {

    $('#paint_case_submit').click(function() {
        $(".errorFlag").remove();
        validates_presence_of($("#paint_case_title") );
        validates_presence_of($("#paint_case_customer_name") );
        validates_presence_of($("#paint_case_customer_tel") );
        validates_presence_of($("#paint_case_customer_address") );
        validates_presence_of($("#paint_case_emulsion_paint") );
        var error_num = $("#item_form .errorFlag").length;
        if ( error_num > 0 ) {
            alert("有"+error_num+"处错误,请更正后提交");
        }else{
            $("#item_form").save(0);
        };
        return false;
    });
  
    $.fn.save = function(button) {
        disable_buttons();
        //$("#content_editor").val(CKEDITOR.instances.content_editor.getData());
        $.ajax({
            type: "POST",
            url: "/paint_admin/paint_cases/save",
            dataType:"json",
            data: $("#item_form").serialize() +"&status=" + button ,
            success: function(data){
                if (button == 2) {
                    $('#save_time_tip').text(data["time"]);
                    $('#id').val(data["id"]);
                }else{
                    alert("案例发表成功,请等待管理员审核");
                    self.location.replace('/paint_admin/paint_cases');
                };
            
            }
        });
        enable_buttons();
    };

    // 检查空格
    function validates_presence_of(field) {
        if (field.val().length == 0 && field.next("em").length == 0 ) {
            field.setError("不能为空");
        }else{
            field.cleanError();
        };
    };
  
    // 检查只能为数字
    function validates_numbericality_of(field) {
        var patrn = /\d+$/;
        if (!patrn.exec(field.val())) {
            field.setError("只能为数字");
        }else{
            field.cleanError();
        };
    };
  
    $("#t_province").change(function(){
        if ($("#t_province").val().length == 0) {
            $("#t_city").empty();
            $("<option value=''>请选择</option>").appendTo("#t_city");
        }else {
            $.getJSON("/public/get_city_json",{
                province: $("#t_province").val()
                }, function(data){
                $("#t_city").empty();
                $("<option value=''>请选择</option>").appendTo("#t_city");
                $.each(data,function(i){
                    $("<option value='"+ data[i][0] +"'>"+ data[i][1] +"</option>").appendTo("#t_city");
                });
            });
        }
    });
  
  
    //控制样式
    jQuery.fn.setError=function(text){
        $(this).css("border-color","#FF0000");
        var tip = "<em class='errorFlag'>"+ text +"</em>"
        $(this).after(tip);
    };
  
    jQuery.fn.cleanError=function(){
        $(this).next("em").remove();
        $(this).css("border-color",'');
    };
  
});
