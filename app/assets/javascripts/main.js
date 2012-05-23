/**
 * Anonymous function which executes once the page has finished loading.
 */
$(function() {
  // Set the width of the account drop down menu to the width of the
  // drop down button (containing the variable length username). This
  // is required because the position of the menu is absolute and is
  // therefore does not receive the parent div's width. The absolute
  // position is required because the menu jumps around when animated
  // if relative.
  $('#account_dd_menu').css('width', $('#account_dd_button').width() + 'px');

  /**
   * Toggles the visibility of the account drop down menu.
   */
  function toggleAccountDropDown() {
    $('#account_dd_menu').slideToggle('fast');
  }


  /**
   * Handles the click event of the account drop down menu button.
   */
  $('#account_dd_arrow').click(function() {
    toggleAccountDropDown();
  });

  $('.site_caption_tip').hover(function() {
    toggleSiteTip();
  });
});