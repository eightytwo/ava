/**
 * Anonymous function which executes once the page has finished loading.
 */
$(function() {
  // Indicates the account drop down menu has mouse focus.
  var accountDropDownHasFocus = false;


  /**
   * Toggles the visibility of the account drop down menu.
   */
  function toggleAccountDropDown() {
    $('#account_dropdown_menu').toggle();
  }

  /**
   * Determines if the account drop down menu should be hidden
   * and if so hides it.
   */
  function checkHideAccountDropDown() {
    if (!accountDropDownHasFocus)
      $('#account_dropdown_menu').hide();
  }

  /**
   * Handles the click event of the body of the document.
   */
  $(document).click(function() {
    checkHideAccountDropDown();
  });

  /**
   * Handles the click event of the account drop down menu button.
   */
  $('#account_dropdown_button').click(function() {
    toggleAccountDropDown();
  });

  /**
   * Handles the hover event for the account drop down menu.
   */
  $('#account_dropdown').hover(function() {
    accountDropDownHasFocus = true;
  }, function() {
    accountDropDownHasFocus = false;
  });
});