class BaseMailer < ActionMailer::Base
  default to: "admin@null.net"
  default from: '"AVA Notifications" <notifications@avarcade.herokuapp.com>'
end
