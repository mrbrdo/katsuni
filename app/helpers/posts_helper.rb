# encoding: UTF-8
module PostsHelper
  def post_name post
    post_name = post.name.present? ? h(post.name) : "Anonimnež"
    if post.email.present?
      mail_to(post.email, post_name).html_safe
    else
      post_name
    end
  end

  def post_comment post
    simple_format(Rinku::auto_link(h(post.comment))).html_safe
  end
end
