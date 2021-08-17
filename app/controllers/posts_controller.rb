class PostsController < ApplicationController
  def new
    @form = PostForm.new
  end

  def create
    @form = PostForm.new(post_params)
    if @form.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def post_params
    params.require(:post_form).permit(:car_name, :car_model, :car_number, :stole_time,
                                      :stole_location, :contact, { images: [] })
          .merge(user_id: current_user.id)
  end
end
