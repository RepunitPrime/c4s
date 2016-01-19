class WelcomeController < ApplicationController

  def index
  end
  
  def about_us
  	@names = ["bilal","muctadir","chen","manpriya","rasmus"]
    @updatedByNames = ["John Jack","Neetha","Sharath","Atezaz","Salman"]
  end

end
