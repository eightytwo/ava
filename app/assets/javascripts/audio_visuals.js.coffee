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
      critiqueTab.click -> toggleTabs()
      commentTab.click -> toggleTabs()

    # Set click handler for critique showing/collapsing.
    $('.title').live 'click', (event) -> toggleCritique($(this))

    # Set click handler for the reply links.
    $('.reply_link').live 'click', (event) -> return setupReply($(this))

    # Set click handler for the cancel reply link.
    $('.cancel_reply_link').live 'click', (event) -> return cancelReply($(this))


    # Function to show the content of a tab when clicked.
    toggleTabs = ->
      critiqueTab.toggleClass('active')
      commentTab.toggleClass('active')
      critiqueContainer.toggle()
      commentContainer.toggle()

    # Function to expand and collapse critiques.
    toggleCritique = (critiqueTitle) ->
      critiqueTitle.next().toggle('fast')

    # Shows a reply form inline with the critique component selected
    # for replying.
    setupReply = (replyLink) ->
      componentID = replyLink.attr('id')

      # Hide any existing new reply areas.
      $('.av_critique_category').children('.reply_wrapper.new').hide()
      # Ensure all existing replies are shown.
      $('.reply_wrapper.existing > .reply_content > pre').show()
      
      # Get the reply area and necessary elements associated
      # with the clicked reply link.
      replyWrapper = replyLink.parents('.av_critique_category').children('.reply_wrapper')
      replyContent = replyWrapper.children('.reply_content')
      replyFormWrapper = $('#critique_reply_form_wrapper')
      replyForm = $('#critique_reply_form')
      replyTextBox = $('#txtReplyContent')
      replyExistingContent = replyContent.children('pre')

      # Clear any left over text from the textbox.
      replyTextBox.text("")
      
      # Move the reply form into place and set necessary values.
      $('#hidComponentID').val(componentID)
      if (replyExistingContent.length)
        replyExistingContent.hide()
        replyTextBox.text($.trim(replyExistingContent.text()))

      # Show the form and the containing element.
      replyFormWrapper.appendTo(replyContent).show()
      replyWrapper.show()

      return false;

    # Cancels a reply.
    cancelReply = (cancelLink) ->
      # Get the reply wrapper and show the reply text if it exists.
      replyWrapper = cancelLink.parents('.av_critique_category').children('.reply_wrapper')
      replyWrapper.children('.reply_content').children('pre').show()
      
      # Hide the entire reply wrapper if no reply actually exists.
      replyWrapper.hide() if replyWrapper.hasClass('new')

      # Wipe the content of the text area and hide the form wrapper.
      $('#txtReplyContent').text("")
      $('#critique_reply_form_wrapper').hide()

      return false

    ###
    Ajax functionality
    ###

    $.ajax "/av/1/critiques",
      cache: false,
      success: (html) ->
        critiqueContainer.append(html)