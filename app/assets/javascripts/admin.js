$(function() {

  /**
   * Adds a new member.
   */
  function addMember() {
    var body = {
      action: 'add_member',
      alias: $('#add_member_alias').val(),
      email: $('#add_member_email').val(),
      site_role: $('#add_member_site_role').val(),
      organisation: $('#add_member_organisation').val(),
      password: $('#add_member_password').val(),
      password_confirm: $('#add_member_password_confirm').val()
    };

    $.post('/rpc', JSON.stringify(body), function(data) {
      console.log(data);
    });
  }

  /**
   * Click handler for the add member button.
   */
  $('#add_member_submit').click(function() {
    addMember();
  });
});
