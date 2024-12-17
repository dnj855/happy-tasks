class CommentMailer < ApplicationMailer
  def new_comment_email(user, comment)
    @user = user
    @comment = comment
    mail(to: @user.email, subject: 'Un nouveau commentaire a été posté')
  end
end
