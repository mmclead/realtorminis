module ApplicationHelper

  def is_under? url_piece
    request.original_url.include?("/"+url_piece)
  end
end
