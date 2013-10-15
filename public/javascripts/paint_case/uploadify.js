jQuery(document).ready(function($) {
    var img_num = $("#pictures li").length + 1;
    function parseXml(xml) {
        if (window.DOMParser)
        {
            parser=new DOMParser();
            xmlDoc=parser.parseFromString(xml,"text/xml");
        }
        else // Internet Explorer
        {
            xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
            xmlDoc.async="false";
            xmlDoc.loadXML(xml);
        }
        return xmlDoc;
    };

    $(".delete_picture").live('click',function() {
        if ($(this).attr("id").length>0) {
            var $this = $(this);
            $(this).text("正在删除");
            $.ajax({
                type: "POST",
                url:'/paint_admin/paint_cases/delete_picture',
                dataType:"script",
                data: {
                    id:$(this).attr("id")
                },
                success: function(data, textStatus, xhr) {
                    $this.parents("li").remove();
                }

            });
        }else {
            $(this).parents("li").remove();
        };
        return false;
    });


    function file_item(id) {
        var tr_id = 'f' + id;
        var item = $('#' + tr_id);
        if (item.size() < 1) {
            var number = $("#pictures li").length
            if(number < 4)
                {
                    item = $('<li/>').attr('id', tr_id).attr("class", "line").appendTo('#pictures');
                }
        }
        return item;
    }

    function uploadErrorHandler(event, id, file, error) {
        if (error.type=="File Size") {
            file_item(id).eq(0).text(file.name + "上传失败,因为图片尺寸超过200K");
        }else{
            file_item(id).eq(0).text(error.type + "," + error.info);
        };

        return false;
    }

    function uploadSuccessHandler(event, id, file, response, data) {
        img_num ++;
        var ext = file.name.split('.');
        ext = ext[ext.length - 1];
        var image_id = $(parseXml(response)).find("id").text();
        var image_md5 =$(parseXml(response)).find("md5").text();
        var img_path = image_id + '-' + image_md5 +  '.' + ext;
        var file_name = file.name;
        var img_path_with_domain = $('#item_form').attr("data-assetsurl") + img_path ;
        file_item(id).eq(0).html('<img src="'+ img_path_with_domain +
            '"><p><a href="#" target="_self" title="删除" class="delete_picture">删除</a>' +
            '<input name="" type="button" value="预览大图"></p>' +
            '<p><span style="float: left;font-size: 12px;line-height: 25px;padding-left: 10px;">' +
            '名称：</span><input type="text" value="" name="pictures[][name]" id="pictures__name"></p>' +
            '<input type="hidden" name="pictures[][image_id]"  value = "'+image_id+'"/>' +
            '<input type="hidden" name="pictures[][image_md5]"  value = "'+ image_md5 +'"/>' +
            '<input type="hidden" name="pictures[][image_ext]"  value = "'+ ext +'"/>' +
            '<input type="hidden" name="pictures[][file_name]"  value = "'+ file_name +'"/>' +
            '<input type="hidden" name="pictures[][id]" value = "" class="image_id"/>' +
            '<span class="scrj_czt02_jdt"><label style="width:155px;"></label></span>');
    }

    $.fn.showPic = function() {

    };

    function uploadProgressHandler(event, id, file, data) {
        file_item(id).eq(0).text(data.percentage + '%(' + data.speed + ')');
    }

    function fileQueuedHandler(event, id, file) {
        file_item(id).eq(0).text(file.name).end().
        eq(1).text('等待上传');
        this.startUpload(file.id);
        return false;
    }

    function onCancel() {
        return false
    }
    
    function uploadCompleteHandler() {
        $('#swfupload_button').uploadifyClearQueue();
    };

    function log(msg) {
        if(console) console.log(msg);
    }

    $("#swfupload_button").uploadify({
        auto        : true, // 自动开始上传文件
        // 路径
        script         : $("#item_form").attr("data-uploadurl"), // 处理上传的地址
        uploader       : '/swf/uploadify.swf', // 上传文件falsh
        expressInstall : 'swf/expressInstall.swf',
        cancelImg      : 'img/cancel.png', // 取消上传的按钮图片
        scriptData	:{
            "resize": '500x375',
            'watermark': '4c060a2d86869711c20004bb'
        },
        fileDataName: 'file', // 文件在POST中的参数名字

        fileDesc    : 'Image files', // 可选文件的描述
        fileExt     : '*.jpg;*.png;*.gif', // 可选文件的扩展名

        queueID     : 'fileQueue', // 文件列表的dom id

        sizeLimit   : 200 * 1024, // 上传文件的大小控制（字节，这里表示200Kb）
        multi       : true, // 允许上传多个文件
        simUploadLimit : 1, // 允许同时进行上传的文件数

        //buttonText  : '上传', // 上传按钮的文字
        buttonImg   : 'http://js.51hejia.com/img/upload.png', // 上传按钮图片
        rollover    : true, // 是否使用sprint图片（一张图片多张小图）－没有swfupload流畅
        width       : 80,
        height      : 28,

        // 选择了文件时
        onSelect: fileQueuedHandler,
        // 单个文件上传成功的处理函数
        onComplete: uploadSuccessHandler,
        // 文件上传失败的处理函数
        onError:    uploadErrorHandler,
        // 处理文件上传进度的函数
        onProgress: uploadProgressHandler,
        //上传失败处理
        onAllComplete:uploadCompleteHandler
    });

    $('#clean_queue').click(function(event) {
        event.preventDefault();
        $('#swfupload_button').uploadifyClearQueue()
        return false;
    });
});
