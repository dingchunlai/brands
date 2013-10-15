jQuery(document).ready(function($) {

  var img_num = $("#picyl tr").length + 1;

  function parseXml(xml) {
    if (window.DOMParser) {
      parser=new DOMParser();
      xmlDoc=parser.parseFromString(xml,"text/xml");
    } else {
      // Internet Explorer
      xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
      xmlDoc.async="false";
      xmlDoc.loadXML(xml);
    }
    return xmlDoc;
  };

  $(".insert_img_to_editor").live('click',function() {
    KE.insertHtml("cke_editor", '<img src="' + $(this).attr("href") + '" />');
    return false;
  });

  $(".delete_picture").live('click',function() {
    $(this).parent().parent().remove(); 
    return false;
  });

  $('.preview_pic').live("mouseover",function() {
    $(this).next().show();
  }).live("mouseout",function() {
    $(this).next().hide();
  });

  function file_item(id) {
    var tr_id = 'f' + id;
    var item = $('#' + tr_id);
    if (item.size() < 1) {
      item = $('<tr />').attr('id', tr_id).attr('class', "queued").appendTo('#picyl tbody');
      for(var i = 0; i < 4; i++) $('<td />').appendTo(item);
    }
    return item;
  }
  
  function uploading_item() {
    return $("#picyl tbody tr.queued:first");
  };

  function uploadErrorHandler(event, id, file, error) {
    if (error.type=="File Size") {
      file_item(id).find('td').eq(1).text(file.name + "上传失败").end().eq(2).text("因为图片尺寸超过200K");
    }else{
      file_item(id).find('td').eq(1).text(error.type).end().eq(2).text(error.info);
    };
  }

  function uploadSuccessHandler(event, id, file, response, data) {
    var ext = file.name.split('.');
        ext = ext[ext.length - 1];
    var image_id = $(parseXml(response)).find("id").text();
    var image_md5 =$(parseXml(response)).find("md5").text();
    var data_index = $("#picyl").attr("data_index");
    var image_prefix = $(".upload_form").attr("data-assetsurl");
    var img_path = image_id + '-' + image_md5 +  '.' + ext;
    var file_name = file.name;
    var img_path_with_domain = (image_prefix + img_path).replace(".com//",".com/");
    img_num++;

    var data = {
      img_path_with_domain : img_path_with_domain,
      img_num : img_num,
      file_name : file_name,
      image_id : image_id,
      image_md5 : image_md5,
      image_ext : ext
    }

    $("#picyl tbody tr:last").remove();

    file_item(id).html($("#pic_list_template").tmpl( data ));
  }

  // Upload Progress 
  function uploadProgressHandler(event, id, file, data) {
    file_item(id).find('td').eq(2).text(data.percentage + '%(' + data.speed + ')');
  }

  // Upload Queue 
  function fileQueuedHandler(event, id, file) {
    file_item(id).find('td').eq(0).text(file.name).end().eq(1).text(' Waiting ... ');
    this.startUpload(file.id);
    return false;
  }
  
  // Upload CompleteHandler
  function uploadCompleteHandler() {
    $('#swfupload_button').uploadifyClearQueue();
  };

  // Cancel Upload 
  function onCancel() { return false }

  function log(msg) {
    if(console) console.log(msg);
  }

  // Upload Function
  $("#swfupload_button").uploadify({
    auto            : true, 
    script          : $(".upload_form").attr("data-uploadurl"),
    uploader        : '/swf/uploadify.swf', 
    expressInstall  : 'swf/expressInstall.swf',
    cancelImg       : 'img/cancel.png', 
    scriptData	    : { "resize": '500x375', 'watermark': '4c060a2d86869711c20004bb'},
    fileDataName    : 'file', 

    fileDesc        : 'Image files', 
    fileExt         : '*.jpg;*.png;*.gif', // File Ext 

    queueID         : 'fileQueue', // File Queue dom id

    sizeLimit       : 200 * 1024, 
    multi           : true, 
    simUploadLimit  : 1, 

    buttonText      : 'Upload',
    buttonImg       : '/images/icons/upload.png', 
    rollover        : true, 
    width           : 75,
    height          : 25,

    // Select File Funcation 
    onSelect: fileQueuedHandler,
    // An File Seccess 
    onComplete: uploadSuccessHandler,
    // Upload File Error 
    onError:    uploadErrorHandler,
    // Uoload Progress Function 
    onProgress: uploadProgressHandler,
    // An Queue Complete 
    onAllComplete:uploadCompleteHandler
  });

  $('#clean_queue').click(function(event) {
    event.preventDefault();
    $('#swfupload_button').uploadifyClearQueue()
    return false;
  });

})
