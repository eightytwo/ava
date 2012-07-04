class ContactController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def new
    @message = Contact.new(params[:contact])
  end

  def create
    @message = Contact.new(params[:contact])

    if @message.valid?
      ContactMailer.new_message(@message).deliver
      redirect_to root_url, notice: I18n.t("contact.new_message.success")
    else
      render :new
    end
  end
end
