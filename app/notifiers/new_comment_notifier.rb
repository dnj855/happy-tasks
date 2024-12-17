class NewCommentNotifier < Noticed::Event
  deliver_by :email, mailer: "CommentMailer", method: :new_comment_email

  def new_comment_email
    CommentMailer.new_comment_email(record.user, record)
  end
end
