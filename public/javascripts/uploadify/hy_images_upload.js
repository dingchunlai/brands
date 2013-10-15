jQuery(document).ready(function($) {
    $.fn._hySetImage = function(src) {
          $(this).attr("src", src);
    };

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
    }

    /// 针对网页图片的函数处理 start
    // 上传错误时,调用函数
    function uploadErrorHandler(event, id, file, error) {
        $("#upload_notice").text("");
        $('#image_thumb')._hySetImage("http://js.51hejia.com/img/nil.gif");
        if (error.type.toString() == "File Size") {
            alert("图片大小不能超过200K");
        } else {
            alert("[ERROR]" + error.type + "_" + error.info);
        }
    }

    // 上传成功时,调用函数
    function uploadSuccessHandler(event, id, file, response, data) {
        var ext = file.name.split('.');
        ext = ext[ext.length - 1];
        var image_id = $(parseXml(response)).find("id").text();
        var image_md5 =$(parseXml(response)).find("md5").text();
        var img_path = image_id + '-' + image_md5 +  '.' + ext;
        $("#distributor_upload_picture_image_url").val(img_path);
        // 放置图片的DOMID，图片的URL
        $('#image_thumb')._hySetImage("http://assets1.image.51hejia.net/" + img_path);
        $("#upload_notice").text("");
        $("#image_upload_button").attr('disabled', null);  //上传按钮解锁
    }

    //上传过程提示
    function uploadProgressHandler(event, id, file, data) {

    }

    // 上传完成时,调用函数
    function uploadCompleteHandler() {
      $("#upload_notice").text("");
      $('#image_upload_button').uploadifyClearQueue();
    }


    //上传等待过程
    function fileQueuedHandler(event, id, file) {
        $("#upload_notice").text("正在上传图片，请稍后 ...");
        $("#image_upload_button").attr('disabled', 'disabled');  //锁定上传按钮
        return false;
    }

    // 主函数加载
    // 图片button 的ID
    // FORM_ID
    // 显示图片的IMG
    // 存贮生成图片地址的字段
    $("#image_upload_button").uploadify({
        auto        : true, // 自动开始上传文件
        script         : $("#hy_upload_pic_form").attr("data-uploadurl"),
        uploader       : '/swf/uploadify.swf', // 上传文件falsh
        expressInstall : 'swf/expressInstall.swf',
        cancelImg      : 'img/cancel.png', // 取消上传的按钮图片
        scriptData     : {
            'watermark': '4c060a2d86869711c20004bb'
        },
        fileDataName: 'file', // 文件在POST中的参数名字

        fileDesc    : 'Image files', // 可选文件的描述
        fileExt     : '*.jpg;*.png;*.gif', // 可选文件的扩展名

        sizeLimit   : 200 * 1024, // 上传文件的大小控制（字节，这里表示200Kb）
        simUploadLimit : 1, // 允许同时进行上传的文件数

        buttonText  : '上传', // 上传按钮的文字
        buttonImg   : 'http://js.51hejia.com/img/upload.png', // 上传按钮图片
        rollover    : true, // 是否使用sprint图片（一张图片多张小图）－没有swfupload流畅
        width       : 90,
        height      : 25,

        // 选择了文件时
        onSelect: fileQueuedHandler,
        // 单个文件上传成功的处理函数
        onComplete: uploadSuccessHandler,
        // 文件上传失败的处理函数
        onError:    uploadErrorHandler,
        // 处理文件上传进度的函数
        onProgress: uploadProgressHandler,
        // 一个队列上传完成
        onAllComplete: uploadCompleteHandler
    });
    /// 针对网页图片的函数处理 end
});
