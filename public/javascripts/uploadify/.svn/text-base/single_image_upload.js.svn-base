jQuery(document).ready(function($) {

  function parseXml(xml) {
    if (window.DOMParser){
      parser=new DOMParser();
      xmlDoc=parser.parseFromString(xml,"text/xml");
    }else{
      // Internet Explorer
      xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
      xmlDoc.async="false";
      xmlDoc.loadXML(xml);
    }
    return xmlDoc;
  };

  set_image($('#image_thumb'), $('.image_attr'));

  // Main Function Load
  // [image_upload_button]  The style of the upload_image_button
  // [upload_form]  The style of the form
  // [upload_form]  An attribute of the form
  $("#image_upload_button").uploadify({
    auto            : true, // IsAuto Upload 
    script          : $(".upload_form").attr("data-uploadurl"),
    uploader        : '/swf/uploadify.swf', // Upload File falsh
    expressInstall  : 'swf/expressInstall.swf',
    cancelImg       : 'img/cancel.png', // Cancel Image 
    scriptData      : {
      'resize'    : ("'"+ $('#image_thumb').attr('size') + "'")
      // 'watermark': '4c060a2d86869711c20004bb'
    },

    fileDataName    : 'file', // An File Attribute For Form

    fileDesc        : 'Image files', // File Description 
    fileExt         : '*.jpg;*.png;*.gif', // File Ext

    //sizeLimit       : size_limit, 
    sizeLimit       : 1024 * 1024, // byte size（byte 500Kb）
    simUploadLimit  : 1,  

    buttonText      : 'Upload', // upload Botton TEXT 
    buttonImg       : 'http://js.51hejia.com/img/upload.png', // Upload Botton Image 
    width           : 80,
    height          : 25,

    // Select One Function 
    onSelect: fileQueuedHandler,
    // Success Function 
    onComplete: uploadSuccessHandler,
    // Error Function 
    onError:    uploadErrorHandler,
    // Uploading Function 
    onProgress: uploadProgressHandler,
    // Success For Queue 
    onAllComplete: uploadCompleteHandler
  });

  // Error Function 
  // [image_thumb] SHOW IMAGE DOM_ID
  function uploadErrorHandler(event, id, file, error) {
    set_defualt($("#image_thumb"));
    alert("[ERROR]:" + error.type + "_" + error.info);
  }
  
  // Upload Success Function  
  // [image_attr] An attribute the Style for Form 
  // [image_thumb] SHOW IMAGE DOM_ID
  // [image_upload_button] Upload Botton ID
  function uploadSuccessHandler(event, id, file, response, data) {
    var ext = file.name.split('.');
    ext = ext[ext.length - 1];
    var image_id = $(parseXml(response)).find("id").text();
    var image_md5 =$(parseXml(response)).find("md5").text();
    var img_path = image_id + '-' + image_md5 +  '.' + ext;
    $(".image_attr").val(img_path);
    set_image($("#image_thumb"), $(".image_attr"));
    $("#image_upload_button").attr('disabled', null);  // UnLock Unload Botton
  }

  // Uploading... 
  function uploadProgressHandler(event, id, file, data) {

  }
  
  // Upload Success Function 
  function uploadCompleteHandler() {
    $('#image_upload_button').uploadifyClearQueue();
  };


  // Uploading ... 
  function fileQueuedHandler(event, id, file) {
    $("#image_upload_button").attr('disabled', 'disabled');  // lock Upload Botton
    return false;
  }

  // Set Default Image
  function set_image(image_obj, obj){
    var src = 'http://js.51hejia.com/img/nil.gif';
    if ($.trim(obj.val()) != ''){
      src = ($(".upload_form").attr("data-assetsurl") + obj.val()).replace(".com//",".com/");
    }
    image_obj.attr('src', src);
  }

});
