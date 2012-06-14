###
Anonymous function which executes once the page has finished loading.
###
jQuery ->
  if $('#av_feedback').length
    # Get a reference to the critique and comment content regions.
    critiqueContainer = $('#av_critiques')
    commentContainer = $('#av_comments')

    # Check if the audio visual can be critiqued and/or commented.
    critiquable = critiqueContainer.length
    commentable = commentContainer.length
    
    # Get a reference to the critique and comment tabs.
    critiqueTab = $('#av_tab_critique')
    commentTab = $('#av_tab_comment')

    # Activate one of the tabs and show its content.
    if (critiquable and commentable) or (critiquable and not commentable)
      critiqueTab.toggleClass('active')
      critiqueContainer.toggle()
    else
      commentTab.toggleClass('active')
      commentContainer.toggle()


    ###
    Event handlers
    ###

    # Set click handlers for the tabs.
    if critiquable and commentable
      critiqueTab.click -> showCritiques() if !critiqueTab.hasClass('active')
      commentTab.click -> showComments() if !commentTab.hasClass('active')

    # Set click handler for critique showing/collapsing.
    $('.critique_title').live 'click', (event) ->
      return toggleCritique($(this))

    # Set click handler for the reply links.
    $('.component_reply_link').live 'click', (event) ->
      return setupReply($(this))

    # Set click handler for the cancel reply link.
    $('.cancel_reply_link').live 'click', (event) ->
      return cancelReply($(this))


    # Functions to show the content of a tab when clicked. These are split out
    # into two functions (as opposed to using toggle) to avoid the page
    # jumping to the top when the visible div is hidden before the other is
    # shown.
    showCritiques = ->
      critiqueTab.toggleClass('active')
      commentTab.toggleClass('active')
      critiqueContainer.show()
      commentContainer.hide()
      return false

    showComments = ->
      critiqueTab.toggleClass('active')
      commentTab.toggleClass('active')
      commentContainer.show()
      critiqueContainer.hide()
      return false

    # Function to expand and collapse critiques.
    toggleCritique = (critiqueTitle) ->
      critiqueTitle.next().toggle('fast')

    # Shows a reply form inline with the critique component or comment
    # selected for replying.
    setupReply = (replyLink) ->
      componentID = replyLink.attr('data-id')
      replyFormWrapper = $('#component_reply_form_wrapper')

      # Get the component element in which the reply form is currently
      # embedded (if any).
      oldComponent = replyFormWrapper.parents('.component_reply_wrapper')
      if oldComponent.length
        oldComponent.hide() if oldComponent.hasClass('new')
        oldComponent.find('pre').show() if oldComponent.hasClass('existing')

      # Get the reply wrapper and content elements associated with the
      # clicked reply link. This is where the reply form will be moved to.
      replyWrapper = replyLink.parents('.component_wrapper')
                              .find('.component_reply_wrapper')
      replyContent = replyWrapper.find('.component_reply_content')
      existingReplyText = replyContent.find('pre')

      # Update the content of the form.
      $('#hidComponentID').val(componentID)
      if existingReplyText.length
        existingReplyText.hide()
        $('#txtReplyContent').text(existingReplyText.text())
      else
        $('#txtReplyContent').text("")

      # Insert the reply form into the component being replied to and make
      # it visible. Finally, show its parent.
      replyFormWrapper.appendTo(replyContent).show()
      replyWrapper.show()

      return false

    # Cancels a reply to a critique component or comment.
    cancelReply = (cancelLink) ->
      replyFormWrapper = $('#component_reply_form_wrapper')

      # Get the reply wrapper and show the reply text if it exists.
      replyWrapper = replyFormWrapper.parents('.component_reply_wrapper')
      existingReplyText = replyWrapper.find('pre')
      if existingReplyText.length
        existingReplyText.show()
      
      # Hide the entire reply wrapper if no reply actually exists.
      replyWrapper.hide() if replyWrapper.hasClass('new')

      # Wipe the content of the text area and hide the form wrapper.
      $('#txtReplyContent').text("")
      replyFormWrapper.hide()

      return false

    ###
    Ajax related functionality
    ###

    # Make asynchronous html content fetches.
    $("div[data-format='html']").each ->
      path = $(this).attr('data-load')
      $(this).load path

    # Make asynchronous js content fetches.
    $("div[data-format='js']").each ->
      path = $(this).attr('data-load')
      $.getScript path

    # Setup spinner for replying to a critique component.
    $('#component_reply_form')
      .live 'ajax:before', ->
        $('#component_reply_spinner').show()
        $('#btnAddReply').hide()
        $('#component_reply_cancel').hide()
      .live 'ajax:complete', ->
        $('#component_reply_spinner').hide()
        $('#btnAddReply').show()
        $('#component_reply_cancel').show()
