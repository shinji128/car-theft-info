class ImagesController < ApplicationController
  def destroy
    @image = Image.find(params[:id])
    @image.destroy! if current_user.posts.ids.include?(@image.post_id)
  end
end
