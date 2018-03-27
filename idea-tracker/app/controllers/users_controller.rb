
class UsersController < ApplicationController

  get '/signup' do
    erb :'users/signup'
  end

  post '/signup' do
    params[:username].strip!
    @user = User.create(params)
    if @user.save
      session[:user_id] = @user.id
      redirect '/ideas'
    else
      redirect '/signup'
    end
  end


  get '/login' do
    erb :'users/login'
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if !!@user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/ideas'
    else
      # erb :'users/login'
      flash[:notice] = "Check input fields"
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end




end
