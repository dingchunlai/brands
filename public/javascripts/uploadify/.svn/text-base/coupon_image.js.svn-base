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
    
    /// 针对网页图片的函数处理 start
    // 上传错误时,调用函数
    function uploadErrorHandler(event, id, file, error) {
        set_defualt($('#image_thumb'));
        alert("[ERROR]" + error.type + "_" + error.info);
    }
    
    // 上传成功时,调用函数
    function uploadSuccessHandler(event, id, file, response, data) {
        var ext = file.name.split('.');
        ext = ext[ext.length - 1];
        var image_id = $(parseXml(response)).find("id").text();
        var image_md5 =$(parseXml(response)).find("md5").text();
        var img_path = image_id + '-' + image_md5 +  '.' + ext;
        $("#coupon_image_url").val("/" + img_path);
        // 放置图片的DOMID，图片的URL
        set_image($('#image_thumb'), $('#coupon_image_url'));
        $("#image_upload_button").attr('disabled', null);  //上传按钮解锁
    }

    //上传过程提示
    function uploadProgressHandler(event, id, file, data) {

    }
    
    // 上传完成时,调用函数
    function uploadCompleteHandler() {
      $('#image_upload_button').uploadifyClearQueue();
    };


    //上传等待过程
    function fileQueuedHandler(event, id, file) {
        //$("#upload_notice").text("正在上传图片，请稍后 ...");
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
        script         : $("#coupon_form").attr("data-uploadurl"),
        uploader       : '/swf/uploadify.swf', // 上传文件falsh
        expressInstall : 'swf/expressInstall.swf',
        cancelImg      : 'img/cancel.png', // 取消上传的按钮图片
        scriptData     : {
            "resize": '317x233'
        //    'watermark': '4c060a2d86869711c20004bb'
        },
        fileDataName: 'file', // 文件在POST中的参数名字

        fileDesc    : 'Image files', // 可选文件的描述
        fileExt     : '*.jpg;*.png;*.gif', // 可选文件的扩展名

        sizeLimit   : 500 * 1024, // 上传文件的大小控制（字节，这里表示500Kb）
        simUploadLimit : 1, // 允许同时进行上传的文件数

        buttonText  : '上传', // 上传按钮的文字
        buttonImg   : 'http://js.51hejia.com/img/upload.png', // 上传按钮图片
        rollover    : true, // 是否使用sprint图片（一张图片多张小图）－没有swfupload流畅
        width       : 65,
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

    /// 针对打印图片的函数处理 start
    // 打印图片函数加载
    $("#print_image_upload_button").uploadify({
        auto        : true, // 自动开始上传文件
        script         : $("#coupon_form").attr("data-uploadurl"),
        uploader       : '/swf/uploadify.swf', // 上传文件falsh
        expressInstall : 'swf/expressInstall.swf',
        cancelImg      : 'img/cancel.png', // 取消上传的按钮图片
        scriptData     : {
            "resize": '290x213'
            //'watermark': '4c060a2d86869711c20004bb'
        },
        fileDataName: 'file', // 文件在POST中的参数名字

        fileDesc    : 'Image files', // 可选文件的描述
        fileExt     : '*.jpg;*.png;*.gif', // 可选文件的扩展名

        sizeLimit   : 1024 * 1024, // 上传文件的大小控制（字节，这里表示500Kb）
        simUploadLimit : 1, // 允许同时进行上传的文件数

        buttonText  : '上传', // 上传按钮的文字
        buttonImg   : 'http://js.51hejia.com/img/upload.png', // 上传按钮图片
        width       : 65,
        height      : 25,

        // 选择了文件时
        onSelect: filePrintQueuedHandler,
        // 单个文件上传成功的处理函数
        onComplete: uploadPrintSuccessHandler,
        // 文件上传失败的处理函数
        onError:    uploadPrintErrorHandler,
        // 处理文件上传进度的函数
        onProgress: uploadPrintProgressHandler,
        // 一个队列上传完成
        onAllComplete: uploadPrintCompleteHandler
    });

    // 上传错误时,调用函数
    function uploadPrintErrorHandler(event, id, file, error) {
        set_defualt($("#print_image_thumb"));
        alert("[ERROR]:" + error.type + "_" + error.info);
    }
    
    // 上传成功时,调用函数
    // img_id => print_image_url_thumb
    // button_id => print_image_url_upload_button
    function uploadPrintSuccessHandler(event, id, file, response, data) {
        var ext = file.name.split('.');
        ext = ext[ext.length - 1];
        var image_id = $(parseXml(response)).find("id").text();
        var image_md5 =$(parseXml(response)).find("md5").text();
        var img_path = image_id + '-' + image_md5 +  '.' + ext;
        $("#coupon_print_image_url").val("/" + img_path);
        set_image($("#print_image_thumb"), $("#coupon_print_image_url"));
        $("#print_image_upload_button").attr('disabled', null);  //上传按钮解锁
    }

    //上传过程提示
    function uploadPrintProgressHandler(event, id, file, data) {

    }
    
    // 上传完成时,调用函数
    function uploadPrintCompleteHandler() {
      $('#print_image_upload_button').uploadifyClearQueue();
    };


    //上传等待过程
    function filePrintQueuedHandler(event, id, file) {
        //$("#upload_notice").text("正在上传图片，请稍后 ...");
        $("#print_image_upload_button").attr('disabled', 'disabled');  //锁定上传按钮
        return false;
    }
    /// 针对网页图片的函数处理 end 
 
});
