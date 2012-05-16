module SignHelper
  def sign_in(user)
    post user_session_path,
         {
           :user => {
             :email    => user.email,
             :password => user.password
           }
         }
  end
end