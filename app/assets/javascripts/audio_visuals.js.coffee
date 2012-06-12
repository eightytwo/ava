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

    # Set click handlers for the tabs.
    if critiquable and commentable
      critiqueTab.click -> toggleTabs()
      commentTab.click -> toggleTabs()

    # Set click handler for critique showing/collapsing.
    $('.title').live 'click', (event) -> toggleCritique($(this))

    ###
    Event handlers
    ###

    # Function to show the content of a tab when clicked.
    toggleTabs = ->
      critiqueTab.toggleClass('active')
      commentTab.toggleClass('active')
      critiqueContainer.toggle()
      commentContainer.toggle()

    toggleCritique = (critiqueTitle) ->
      critiqueTitle.next().toggle('fast')


    ###
    Data loads
    ###

    $.ajax "/av/1/critiques",
      cache: false,
      success: (html) ->
        critiqueContainer.append(html)