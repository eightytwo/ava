//= require swfupload/swfupload

$(function() {
  // Uploader control.
  var swfu;

  var progressContainerWidth,
      uploadTicketId,
      uploadUri,
      uploadFileName,
      ticketUri,
      finishUri;

  // Get the path and identifier for callbacks.
  var callbackPath = $(location).attr('pathname').split('/')[1];
  var callbackID = $('#round_audio_visual_round_id').val();
  
  // Form the ticket and finish uris.
  ticketUri = '/' + callbackPath + '/get_upload_ticket.json'
  finishUri = '/' + callbackPath + '/complete_upload.json'
  if (callbackID != undefined && callbackID != null) {
    ticketUri += '?rid=' + callbackID;
    finishUri += '?rid=' + callbackID;
  }

  /**
   * Validates the form and ensures all text fields have been completed.
   */
  function validateForm() {
    var valid = true;

    $('[type="text"], textarea').each(function() {
      if ($(this).val() == "")
        valid = false;
    });

    return valid;
  }

  /**
   * Handles the file queued event and validates the form before initiating
   * the upload process.
   */
  function fileQueued(file) {
    if (validateForm()) {
      $('.errors').hide();
      uploadFileName = file.name;
      
      try {
        swfu.startUpload();
      } catch(ex) {
      }
    } else {
      $('.errors').show();
      swfu.cancelUpload(null, false);
    }
  }

  /**
   * Handles the upload start event and hides the select files link.
   */
  function uploadStarted(file) {
    // Hide the swf uploader.
    $('#selectFilesLink').hide();
    swfu.setButtonDisabled(true);
    swfu.setButtonCursor(SWFUpload.CURSOR.ARROW);
    swfu.setButtonDimensions(0, 0);
    
    // Prepare the progress bar.
    $('#uploadProgressBarContainer').show();
    progressContainerWidth = $('#uploadProgressBarContainer').width();
    return true;
  }

  /**
   * Handles the upload progress event, rendering a progress bar.
   */
  function uploadProgress(file, bytesLoaded, bytesTotal) {
    try {
      var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);
      var width = progressContainerWidth * (percent / 100);
      $('#uploadProgressLabel').text('Uploaded: ' + percent + '%');
      $('#uploadProgressBar').width(width + 'px');
    } catch (e) {
    }
  }

  /**
   * Handles the upload success event of the file upload process and
   * displays a spinner to indicate further processing by the upload
   * complete event handler.
   */
  function uploadSuccess(file, server_data, receivedResponse) {
    $('#uploadSpinner').show();
  }

  /**
   * Handles the completion of the file upload process by sending
   * a finish upload request to the server.
   */
  function uploadCompleted(file) {
    var uri = finishUri;
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

  /**
   * Retrieves an upload ticket and configures the swf uploader.
   */
  function init() {
    $('#uploadSpinner').hide();

    var buttonWidth = $('#selectFilesLink').width();
    var buttonHeight = $('#selectFilesLink').height();

    $.get(ticketUri, function(data) {
      // Sanity check the response data.
      if (data != null &&
          data.ticket != null &&
          data.ticket.id != undefined &&
          data.ticket.id != null) {

        // Extract the upload uri, initialise the uploader and display
        // the controls.
        uploadTicketId = data.ticket.id;
        uploadUri = data.ticket.endpoint;
       
        swfu = new SWFUpload({
          upload_url: uploadUri,
          flash_url: $('#hidSwfPath').val(),
          file_post_name: "file_data",
          file_queue_limit: 1,
          
          file_queued_handler: fileQueued,
          upload_start_handler: uploadStarted,
          upload_progress_handler: uploadProgress,
          upload_success_handler: uploadSuccess,
          upload_complete_handler: uploadCompleted,

          button_cursor: SWFUpload.CURSOR.HAND,
          button_height: buttonHeight,
          button_placeholder_id: 'uploadContainer',
          button_width: buttonWidth,
          button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT
        });

        // Move the select files link on top of the swf uploader.
        $('#selectFilesLink').position().top = $('#SWFUpload_0').position().top;
      }
    });
  }

  // Kick off the swf uploader initialization.
  init();
});