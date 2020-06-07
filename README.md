# recipeapp
See all available recipes in a single supermarket, preventing you from wasting easily avoided time, effort, and energy!

# NodeJS WebScrapper
In order to create a database of recipes that relate to the inventory of each store, our nodejs program involves the use of web scraping and automation with puppeteer, and the use of a food recipe api, called spoonacular, and a cloud firestore database.

Puppeteer, a chromium automation plugin for NodeJS, first accesses the Safeway page, clicks all the load more buttons, and uses CSS selector to get the titles of the products.

We then insert the titles of these products into a findRecipeByProduct query with the Spoonacular API,  Our implementation of this step is currently not perfect because of the fact that some branded product titles are not detected as ingredients. In the future we will use AI in order to find generic product names, given branded product titles. 

Finally we insert the result of this query, along with other information about the store into the Cloud Firebase database, in the stores collection.

# Flutter-based app
Users first create an account and logs into the app. With flutter’s efficent and easy integration with Firebase, we are able to easily implement Firebase features. We use firebase authentication to ensure that our user’s accounts and passwords are encrypted when they enter our server. This will also allow us to implement email/phone verification for accounts in the near future.

After they login, they will be greeted with a welcome screen, that will display stores nearby. This information is retrieved from the store collection in the Cloud Firestore database. They can then select a nearby supermarket that they have decided to go to. The app will then display recipes that can be made from the ingredients from that one selected supermarket. The app uses tracked current store inventory data, so the all needed ingredients are guaranteed to be available at the selected store. 

[](app/flutter_01.png)

