module ApplicationHelper

  def is_under? url_piece
    request.original_url.include?("/"+url_piece)
  end

  def error_explanation obj
    render partial: 'shared/error_explanation', locals: {obj: obj}
  end

end
