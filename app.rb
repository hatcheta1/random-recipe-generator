require "sinatra"
require "sinatra/reloader"

get("/") do
  erb(:homepage)
end

get("/generate_recipe") do
  @type_of_recipe = params.fetch(:type_of_recipe)

  erb(:recipe_page)
end
