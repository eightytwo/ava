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
    $('.critique_title').live 'click', (event) -> return toggleCritique($(this))

    # Set click handler for the reply links.
    $('.critique_reply_link').live 'click', (event) -> return setupCritiqueReply($(this))

    # Set click handler for the cancel reply link.
    $('.cancel_critique_reply_link').live 'click', (event) -> return cancelCritiqueReply($(this))


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
      return false

    # Shows a reply form inline with the critique component selected
    # for replying.
    setupCritiqueReply = (replyLink) ->
      componentID = replyLink.attr('id')

      # Hide any existing new reply areas.
      $('.critique_category').children('.critique_reply_wrapper.new').hide()
      # Ensure all existing replies are shown.
      $('.critique_reply_wrapper.existing > .critique_reply_content > pre').show()
      
      # Get the reply area and necessary elements associated
      # with the clicked reply link.
      replyWrapper = replyLink.parents('.critique_category').children('.critique_reply_wrapper')
      replyContent = replyWrapper.children('.critique_reply_content')
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

      return false

    # Cancels a reply to a critique component.
    cancelCritiqueReply = (cancelLink) ->
      # Get the reply wrapper and show the reply text if it exists.
      replyWrapper = cancelLink.parents('.critique_category').children('.critique_reply_wrapper')
      replyWrapper.children('.critique_reply_content').children('pre').show()
      
      # Hide the entire reply wrapper if no reply actually exists.
      replyWrapper.hide() if replyWrapper.hasClass('new')

      # Wipe the content of the text area and hide the form wrapper.
      $('#txtReplyContent').text("")
      $('#critique_reply_form_wrapper').hide()

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
    $('#critique_reply_form')
      .live 'ajax:before', ->
        $('#critique_reply_spinner').show()
        $('#btnAddReply').hide()
        $('#critique_reply_cancel').hide()
      .live 'ajax:complete', ->
        $('#critique_reply_spinner').hide()
        $('#btnAddReply').show()
        $('#critique_reply_cancel').show()
