require 'test_helper'

class RecordMailerTest < ActionMailer::TestCase
  test "notify_remit_info" do
    mail = RecordMailer.notify_remit_info
    assert_equal "Notify remit info", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
