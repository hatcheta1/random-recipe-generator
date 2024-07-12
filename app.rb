require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do
  erb(:homepage)
end

get("/generate_recipe") do
  @type_of_recipe = params.fetch(:type_of_recipe)

  # If the recipe is an entrée, randomly select a type of entree and display the recipe
  if @type_of_recipe == "entrée"
    rand_entree = ["Beef", "Chicken", "Lamb", "Pasta", "Pork", "Seafood", "Goat", "Vegan", "Vegetarian"].sample
    entree_url = "https://www.themealdb.com/api/json/v1/1/filter.php?c=#{rand_entree}"

  # If the recipe is anything other than an entrée, select a random dish from that category
  else
    entree_url = "https://www.themealdb.com/api/json/v1/1/filter.php?c=#{@type_of_recipe.capitalize}"
  end
  
  # Acess the informtion from the URL
  raw_response_category = HTTP.get(entree_url).to_s
  parsed_data_category = JSON.parse(raw_response_category)
  
  meal = parsed_data_category.fetch("meals").sample # Get a random meal from the selected category
  meal_id = meal.fetch("idMeal") # Access the meal ID for the url to access the full recipe

  meal_url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{meal_id}"

  raw_response_meal = HTTP.get(meal_url).to_s
  parsed_data_meal = JSON.parse(raw_response_meal)
  @meal_info = parsed_data_meal.fetch("meals").at(0)

  # Access the recipe's photo
  @photo = @meal_info.fetch("strImageSource")
  
  # Access a list of the recipe's ingredients
  ingredients = []

  (1..20).each do |num|
    ingredient = @meal_info.fetch("strIngredient#{num}")
    measurement = @meal_info.fetch("strMeasure#{num}")
    break if ingredient.strip.empty? || ingredient.nil?

    ingredients.push("#{measurement} #{ingredient}")
  end

  @ingredients = ingredients

  # Access the recipe's instructions
  @instructions = @meal_info.fetch("strInstructions")

  # Access the recipe's original source
  @source = @meal_info.fetch("strSource")

  erb(:recipe_page)
end
