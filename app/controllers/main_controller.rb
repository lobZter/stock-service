class MainController < ApplicationController
    def index
        @companies = Company.all
        @stockholders = Stockholder.all
    end
end
