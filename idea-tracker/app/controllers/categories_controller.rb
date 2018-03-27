
class CategoriesController < ApplicationController


  get '/categories' do
    erb :'categories/index'
  end

  get '/categories/new' do
    if logged_in?
      erb :'categories/new'
    else
      redirect '/loggin'
    end
  end

  post '/categories' do
    category = Category.create(params)
    if category.save
      redirect '/categories'
    else
      flash[:notice] = category.errors.full_messages
      redirect '/categories/new'
    end
  end


  get '/categories/:id' do
    @category = Category.find_by(id: params[:id])
    erb :'categories/show'
  end


  get '/categories/:id/edit' do
    @category = Category.find_by(id: params[:id])
    if logged_in? && current_user.categories.include?(@category)
      erb :'categories/edit'
    else
      flash[:notice] = "Must add this Category to An Idea in order to edit"
      redirect "/categories/#{@category.id}"
    end
  end

  patch '/categories/:id' do
    @category = Category.find_by(id: params[:id])
    if !params[:name].empty?
      @category.update(name: params[:name])
      redirect "/categories/#{@category.id}"
    else
      redirect "/categories/#{@category.id}/edit"
    end
  end

  delete '/categories/:id/delete' do
    @category = Category.find_by(id: params[:id])
    if logged_in? && @category.users.include?(current_user)
      ideas = Idea.where(user: current_user, category: @category)

      ideas.each do |idea|
        idea.category_id = nil
        idea.save
      end

    else
      flash[:notice] = "Must add this Category to An Idea in order to remove"
      redirect "/categories/#{@category.id}"
    end
    redirect "/ideas"
  end


end
