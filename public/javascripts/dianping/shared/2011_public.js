//大首页index --star--
function tabChange(ulId,liNum,divId,liId,classname){
    var liSum = $("#"+ulId).find("li").size();
    //alert(liSum);
    for(i=1;i<=liSum;i++){
        if(liNum == i){
            $("#"+divId+i).show();
            $("#"+liId+i).addClass(classname).siblings().removeClass(classname);
        }else{
            $("#"+divId+i).hide();
        }
    }
}
//大首页index -- end

//layout
$(function() {

    $(".diyq_listimg").live("mouseover", function() {
        if (!$(".diyq_coupon").is(":animated")) {
            $("#pop_img").attr("src", "http://assets2.image.51hejia.net/" + $(this).attr("data-img"));
            $(".diyq_coupon").show();
        }
    });

    $(".diyq_listimg").live("mouseout", function() {
        $(".diyq_coupon").hide();
    });

    $(".diyq_coupon").mouseover(function() {
        if (!$(".diyq_coupon").is(":animated")) {
            $(".diyq_coupon").show();
        }
    });
    $(".diyq_coupon").mouseout(function() {
        $(".diyq_coupon").hide();
    });
});
//end

//公司列表页index--star
$(document).ready(function(){
    $("#change_order").change(function(){
        location.href = $(this).val();
    });
});
function cns_li_hover(obj,ClassName){
    obj.className=ClassName;
}
//end

//公司终端页activeies
$(function(){
    $(".zxdp2010_txt > div:gt(0)").hide();
    $(".zxdp2011_cur_h3 li:first").addClass("active");
    $(".zxdp2011_cur_h3 li").click(
        function(){
            $(this).addClass("active")
            .siblings().removeClass("active");
            $(".zxdp2010_txt > div").eq($(this).index())
            .siblings().hide().end().show();
        })
})
//公司终端页quoted_prices
$(function(){
    if($("#baojia").find("li").size()>=6){
        $(".baojia_btn").show();
        $("#baojia ul").height(150).css("overflow","hidden");
        $(".baojia_btn a").toggle(
            function () {
                $(".baojia_btn a").html("[隐藏]");
                $("#baojia ul").height("auto");
            },
            function () {
                $(".baojia_btn a").html("[更多]");
                $("#baojia ul").height(150);
            });
    }

})
//公司终端页glory
$(function(){
    $(".zxdp2010_rongyzs ul").height(630);
    $(".rongyzs_btn a").toggle(
        function () {
            $(".rongyzs_btn a").html("[关闭更多证书]");
            $(".zxdp2010_rongyzs ul").height("auto");
        },
        function () {
            $(".rongyzs_btn a").html("[查看更多证书]");
            $(".zxdp2010_rongyzs ul").height(630);
        });
})

//公司下的案例列表页
$(function(){
    $(".zxdp2010_zxallist:gt(0)").hide();
    $(".zxdp2010_altptab dd:first").click(
        function(){
            $(this).addClass("zxdp2010_altptabdd01").removeClass("zxdp2010_altptabdd03")
            .siblings().removeClass("zxdp2010_altptabdd01").addClass("zxdp2010_altptabdd02");
            $(".zxdp2010_zxallist").eq($(this).index())
            .siblings().hide().end().show();
        })
    $(".zxdp2010_altptab dd:last").click(
        function(){
            $(this).addClass("zxdp2010_altptabdd01").removeClass("zxdp2010_altptabdd02")
            .siblings().removeClass("zxdp2010_altptabdd01").addClass("zxdp2010_altptabdd03");
            $(".zxdp2010_zxallist").eq($(this).index())
            .siblings().hide().end().show();
        })
})