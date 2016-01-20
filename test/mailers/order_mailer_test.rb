require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test "send_payment_message" do
    mail = OrderMailer.send_payment_message
    assert_equal "Send payment message", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
