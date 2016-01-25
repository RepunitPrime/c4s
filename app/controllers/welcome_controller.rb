class WelcomeController < ApplicationController

  def index
  end
  
  def about_us
    @Names = ["John Jack","Neetha","Sharath","Atezaz","Salman"]
  end

end
