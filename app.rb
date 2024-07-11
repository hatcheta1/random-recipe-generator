require "sinatra"
require "sinatra/reloader"

get("/") do
  erb(:homepage)
end

get("/type_of_recipe") do
  erb(:recipe_page)
end
