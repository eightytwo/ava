###
Anonymous function which executes once the page has finished loading.
###
jQuery ->
  ###
  Set the width of the account drop down menu to the width of the
  drop down button (containing the variable length username). This
  is required because the position of the menu is absolute and is
  therefore does not receive the parent div's width. The absolute
  position is required because the menu jumps around when animated
  if relative.
  ###
  $('#account_dd_menu').css width: $('#account_dd_button').width() + 'px';

  ###
  Toggles the visibility of the account drop down menu when clicked.
  ###
  $('#account_dd_arrow').click -> $('#account_dd_menu').slideToggle('fast')


  ###
  Displays a given slide, hiding the active slide. The slide indicator
  clicked to fire this event is passed into this function.
  ###
  changeToSlide = (indicator) ->
    return false if indicator.hasClass('active')

    activeIndicator = indicator.parent().children('.active')
    activeIndicator.toggleClass('active')
    indicator.toggleClass('active')

    $('.slide').eq(activeIndicator.index()).fadeOut('slow', () ->
      $('.slide').eq(indicator.index()).fadeIn('slow')
    )

    return false

  # If there are slides present for transitioning display the first
  # and setup the transition event.
  if $('.slide').length
    $('.slide').first().show()
    $('#slideshowFooter > ul > li > a').click -> changeToSlide($(this).parent())
