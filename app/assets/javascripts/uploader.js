/**
 * This JavaScript file handles the uploader control which
 * leverages Yahoo's YUI toolkit.
 */

YUI({
  gallery: 'gallery-2011.02.09-21-32'
}).use('uploader', 'gallery-progress-bar', function(Y) {
  var uploader,
      uploadTicketId,
      uploadUri,
      uploadFileName,
      selectedFiles = {};

  function init() {
    var overlayRegion = Y.one("#selectFilesLink").get('region');
    Y.one("#uploaderOverlay").set("offsetWidth", overlayRegion.width);
    Y.one("#uploaderOverlay").set("offsetHeight", overlayRegion.height);
 
    var swfURL = Y.Env.cdn + "uploader/assets/uploader.swf";

    if (Y.UA.ie >= 6) {
      swfURL += "?t=" + Y.guid();
    }

    uploader = new Y.Uploader({
      boundingBox: "#uploaderOverlay", 
      swfURL: swfURL
    }); 

    uploader.on("uploaderReady", setupUploader);
    uploader.on("fileselect", fileSelect);
    uploader.on("uploadprogress", updateProgress);
    uploader.on("uploadcomplete", uploadComplete);
    uploader.on("uploadcompletedata", uploadCompleteData);
  }

  Y.on("domready", function() {
    // Hide the upload controls until the upload endpoint has been fetched.
    $('#uploaderWrapper').css('visibility', 'hidden');
    $('#uploadSpinner').hide();

    $.get('/rav/get_ticket.json?rid=' + $('#round_audio_visual_round_id').val(), function(data) {
      // Sanity check the response data.
      if (data != null &&
          data.ticket != null &&
          data.ticket.id != undefined &&
          data.ticket.id != null) {

        // Extract the upload uri, initialise the uploader and display
        // the controls.
        uploadTicketId = data.ticket.id;
        uploadUri = data.ticket.endpoint;
        init();
        $('#uploaderWrapper').css('visibility', 'visible');
      }
    });
  });

  function setupUploader(event) {
    uploader.set("multiFiles", false);
    uploader.set("simLimit", 1);
    uploader.set("log", true);
  
    var fileFilters = new Array({
      description: "Videos",
      extensions: "*.avi;*.mov;*.mpg;*.mp4"
    }); 
  
    uploader.set("fileFilters", fileFilters); 
  }

  function fileSelect(event) {
    var fileData = event.fileList;  
    
    for (var key in fileData) {
      if (!selectedFiles[fileData[key].id]) {
        Y.one("#files").append(
          "<div id='div_" + fileData[key].id + "' class='progressbars'></div>"
        );
        
        var progressBar = new Y.ProgressBar({
          id: "pb_" + fileData[key].id,
          layout: '<div class="{labelClass}"></div><div class="{sliderClass}"></div>'
        });
   
        progressBar.render("#div_" + fileData[key].id);
        progressBar.set("progress", 0);
               
        selectedFiles[fileData[key].id] = true;
        uploadFileName = fileData[key].name;
      }
    }

    // Hide the SWF container.
    Y.one('#selectFilesLink').hide();
    
    // Call the file upload function.
    uploadFiles();
  }

  function updateProgress(event) {
    var pb = Y.Widget.getByNode("#pb_" + event.id);
    pb.set("progress", Math.round(100 * event.bytesLoaded / event.bytesTotal));
  }

  function uploadComplete(event) {
    $('#uploadSpinner').show();
    var pb = Y.Widget.getByNode("#pb_" + event.id);
    pb.set("progress", 100);
  }

  function uploadCompleteData(event) {
    var uri = '/rav/upload_complete?';
    uri += 'rid=' + $('#round_audio_visual_round_id').val();
    uri += '&ticket_id=' + uploadTicketId;
    uri += '&filename=' + uploadFileName;

    $.get(uri, function(data) {
      if (data.stat == "ok") {
        $('#hidExternalReference').val(data.ticket.video_id);
        $('form').submit();
      } else {
        // Notify the user of an issue.
      }
    });
  }

  function uploadFiles(event) {
    uploader.uploadAll(
      uploadUri,
      "POST",
      {},
      "file_data"
    );
  }

  Y.one("#uploadFilesLink").on("click", uploadFiles);
});