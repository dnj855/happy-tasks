# app/helpers/meta_tags_helper.rb
module MetaTagsHelper
  def meta_title
  content_for?(:meta_title) ? content_for(:meta_title) : DEFAULT_META["Happy Tasks - The best task management app for neuroatypical children"]
  end

  def meta_description
  content_for?(:meta_description) ? content_for(:meta_description) : DEFAULT_META["Happy Tasks: The ultimate task management app designed for neuroatypical children. Empower routines, build focus, and make organizing fun and accessible for every child!"]
  end

  def meta_image
  meta_image = (content_for?(:meta_image) ? content_for(:meta_image) : DEFAULT_META["happyTasks-neurodiverse.png"])
  # little twist to make it work equally with an asset or a url
  meta_image.starts_with?(“http”) ? meta_image : image_url(meta_image)
  end
end
