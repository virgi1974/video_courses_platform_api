# frozen_string_literal: true

module Like
  extend ActiveSupport::Concern

  def likes
    get_likes.size
  end
end
