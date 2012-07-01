class BaseMailer < ActionMailer::Base
  default to: "admin@null.net"
  default from: "notifications@audiovisualarcade.com"
end
