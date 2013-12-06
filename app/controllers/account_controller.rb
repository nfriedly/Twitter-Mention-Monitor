class AccountController < ApplicationController
  
  def index
    render
  end
  
  def complete
    render
  end
  
  def signup
    # instantiate twitter without an account
    client = TwitterOAuth::Client.new(
      :consumer_key => TWITTER_KEY,
      :consumer_secret => TWITTER_SECRET
    )
    
    # create a new request token
    # twitter_oauth_url is defined in routes and points to the twitter_oauth function here
    request_token = client.request_token( :oauth_callback => twitter_oauth_url )
    
    #store the token for when the user returns
    session[:request_token] = request_token
    
    #send the user on to twitter
    redirect_to request_token.authorize_url
  end
  
  def signout
    session.clear
    redirect_to '/'
  end
  
  def destroy
    @user = User.find session[:id]
    @user.destroy
    signout
  end
  
  # users are sent here after successful authentication with twitter
  def twitter_oauth
    
    
    # grab our request token from the signup function.
    # todo: if it doesn't exist, set a flash notice and send the user somewhere else
    request_token = session[:request_token];
  
    # first figure out who the twitter user is
    @client = TwitterOAuth::Client.new(
        :consumer_key => TWITTER_KEY,
        :consumer_secret => TWITTER_SECRET
    )
    begin # wrap this part in a try/catch and start over if anything fails (usualy do to refreshes and back-buttons)
      @access_token = @client.authorize(
        request_token.token,
        request_token.secret,
        :oauth_verifier => params[:oauth_verifier]
      )
      @account = @client.info
    rescue
        redirect_to '/account/signup'
        return
    end
  
    begin
      # find the user if they already exist
      @user = User.find @account['id']
      # if we already have that user, update their tokens and send them on their merry way
      _set_session
      redirect_to '/account'
    rescue
      # otherwise create a new one
      _create_user
      _set_session
      redirect_to '/account/complete'
    end
  end
  
  private
  def _set_session
    @user.oauth_token = @access_token.token
    @user.oauth_secret = @access_token.secret      
    session[:id] = @account['id']
    session[:username] = @account['screen_name']
    @user.save()
  end
    
  def _create_user
    @user = User.new()
    
    @user.id = @account['id']
    @user.username = @account['screen_name']
    
    # lookup the user's most recent mention id and save that in the database
    @mention = @client.mentions( {:count => 1} )
    if(@mention[0])
      @user.last_mention_id =  @mention[0]['id']
      session[:mention] = @mention[0]
    else
      @user.last_mention_id = 0
    end
    # follow both the your_mentions account and the mentionmonitor account
    @user.follow(MM_USERNAME, @client)
    @user.follow(MM_NEWS_USERNAME, @client)
    # run _set_session to save the user
  end
  
end
