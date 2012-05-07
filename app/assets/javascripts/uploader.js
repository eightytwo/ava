/**
 * This JavaScript file handles the uploader control which
 * leverages Yahoo's YUI toolkit.
 */

YUI({
  filter:"raw",
  gallery: 'gallery-2011.02.09-21-32'
}).use("uploader", 'gallery-progress-bar', function(Y) {
  var uploader,
      uploadTicketId,
      uploadUri,
      uploadFileName,
      selectedFiles = {};

  function init() {
    var overlayRegion = Y.one("#selectLink").get('region');
    Y.one("#uploaderOverlay").set("offsetWidth", overlayRegion.width);
    Y.one("#uploaderOverlay").set("offsetHeight", overlayRegion.height);
 
    var swfURL = Y.Env.cdn + "uploader/assets/uploader.swf";

    if (Y.UA.ie >= 6) {
      swfURL += "?t=" + Y.guid();
    }

    uploader = new Y.Uploader({
      boundingBox:"#uploaderOverlay", 
      swfURL: swfURL
    });	

    uploader.on("uploaderReady", setupUploader);
    uploader.on("fileselect", fileSelect);
    uploader.on("uploadprogress", updateProgress);
    uploader.on("uploadcomplete", uploadComplete);
    uploader.on("uploadcompletedata", uploadCompleteData);
  }

  Y.on("domready", function() {
    // Hide the upload controls until the upload endpoint has been
    // fetched.
    $('#uploaderWrapper').css('visibility', 'hidden');

    $.get('/rpc?action=get_upload_ticket', function(data) {
      var obj = JSON.parse(data);

      // Sanity check the response data.
      if (obj != null &&
          obj.ticket_id != undefined &&
          obj.ticket_id != null) {

        // Extract the upload uri, initialise the uploader and display
        // the controls.
        uploadTicketId = obj.ticket_id;
        uploadUri = obj.upload_uri;
        init();
        $('#uploaderWrapper').css('visibility', 'visible');
      }
    });
  });

  function setupUploader(event) {
    uploader.set("multiFiles", true);
    uploader.set("simLimit", 3);
    uploader.set("log", true);
  
    var fileFilters = new Array({
      description:"Videos",
      extensions:"*.avi;*.mov;*.mpg;*.mp4"
    }); 
  
    uploader.set("fileFilters", fileFilters); 
  }

  function fileSelect(event) {
    var fileData = event.fileList;	
    
    for (var key in fileData) {
      if (!selectedFiles[fileData[key].id]) {
        var output = "<tr><td>" + fileData[key].name + "</td><td>" + 
                     fileData[key].size + "</td><td><div id='div_" + 
                     fileData[key].id + "' class='progressbars'></div></td></tr>";
               
        Y.one("#filenames tbody").append(output);
        
        var progressBar = new Y.ProgressBar({
          id:"pb_" + fileData[key].id,
          layout : '<div class="{labelClass}"></div><div class="{sliderClass}"></div>'
        });
   
        progressBar.render("#div_" + fileData[key].id);
        progressBar.set("progress", 0);
               
        selectedFiles[fileData[key].id] = true;
        uploadFileName = fileData[key].name;
      }
    }
  }

  function updateProgress(event) {
    var pb = Y.Widget.getByNode("#pb_" + event.id);
    pb.set("progress", Math.round(100 * event.bytesLoaded / event.bytesTotal));
  }

  function uploadComplete(event) {
    var pb = Y.Widget.getByNode("#pb_" + event.id);
    pb.set("progress", 100);
  }

  function uploadCompleteData(event) {
    var uri = '/rpc?action=complete_upload';
    uri += '&arg0=' + encodeURIComponent(JSON.stringify(uploadTicketId));
    uri += '&arg1=' + encodeURIComponent(JSON.stringify(uploadFileName));

    console.log(uri);
    $.get(uri, function(data) {
      // TODO: if success, route to the video page, otherwise display message.
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
