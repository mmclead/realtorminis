module ProfileHelper

  def prepare_small_profile_pic_and_logo profile
    content_for :small_profile_pic do
      image_tag profile.profile_pic.url, alt: "#{profile.name} Profile Picture", class: 'profile-pic img-rounded', id: 'user_profile_pic'
    end
    content_for :small_logo do
      image_tag profile.logo.url, alt: "#{profile.name} Logo", class: 'logo img-rounded', id: 'user_logo'
    end
  end

end