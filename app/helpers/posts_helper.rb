module PostsHelper
  def post_name post
    if post.email.present?
      mail_to(post.email, h(post.name)).html_safe
    else
      post.name
    end
  end
end
