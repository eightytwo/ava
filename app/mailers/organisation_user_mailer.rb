class OrganisationUserMailer < BaseMailer
  layout 'mailer'

  def new_organisation_user(organisation_user)
    @recipient = organisation_user.user
    @organisation = organisation_user.organisation
    
    mail(to: @recipient.email,
         subject: I18n.t("mailer.subjects.organisation_user.new"))
  end
end
