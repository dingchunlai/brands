jQuery(document).ready(function($) {

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

    function file_item(id) {
        var tr_id = 'f' + id;
        var item = $('#' + tr_id);
        if (item.size() < 1) {
            item = $('<tr/>').attr('id', tr_id).appendTo('#picyl tbody');
            for(var i = 0; i < 4; i++) $('<td/>').appendTo(item);
        }
        return item;
    }

    function uploadErrorHandler(event, id, file, error) {
        alert("[ERROR]" + error.type + "_" + error.info);
        return false;
    }

    function uploadSuccessHandler(event, id, file, response, data) {
        var ext = file.name.split('.');
        ext = ext[ext.length - 1];
        var image_id = $(parseXml(response)).find("id").text();
        var image_md5 =$(parseXml(response)).find("md5").text();
        var img_path = image_id + '-' + image_md5 +  '.' + ext;
        $("#resource_image_url").val("/" + img_path);
        set_main_image();
        $("main_image_upload_button").attr('disabled', null);  //上传按钮解锁
    }

    //上传过程提示
    function uploadProgressHandler(event, id, file, data) {

    }

    //上传等待过程
    function fileQueuedHandler(event, id, file) {
        //$("#upload_notice").text("正在上传图片，请稍后 ...");
        $("main_image_upload_button").attr('disabled', 'disabled');  //锁定上传按钮
        return false;
    }

    function onCancel() {
        return false
    }

    //如果没有手动选择主图。默认第一张为图片主图
 

    function log(msg) {
        if(console) console.log(msg);
    }

    $("#main_image_upload_button").uploadify({
        auto        : true, // 自动开始上传文件
        script         : $("#item_form").attr("data-uploadurl"),
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

        sizeLimit   : 200 * 1024, // 上传文件的大小控制（字节，这里表示500Kb）
        multi       : true, // 允许上传多个文件
        simUploadLimit : 1, // 允许同时进行上传的文件数

        buttonText  : '上传', // 上传按钮的文字
        buttonImg   : 'http://js.51hejia.com/img/upload.png', // 上传按钮图片
        rollover    : true, // 是否使用sprint图片（一张图片多张小图）－没有swfupload流畅
        width       : 61,
        height      : 28,

        // 选择了文件时
        onSelect: fileQueuedHandler,
        // 单个文件上传成功的处理函数
        onComplete: uploadSuccessHandler,
        // 文件上传失败的处理函数
        onError:    uploadErrorHandler,
        // 处理文件上传进度的函数
        onProgress: uploadProgressHandler
    });

    $('#clean_queue').click(function(event) {
        event.preventDefault();
        $('#main_image_upload_button').uploadifyClearQueue()
        return false;
    });
});