/*
Created at the FTNE Hackathon on June 5-7, 2020.
================================================
This is the main NodeEJS file for web scraping of ingredients available at a certain store.
We input them into the stores database, and then determine recipes based on available ingredients.
These recipes are generated using the Spoonacular API.
*/


//--- FIREBASE CLOUD FIRESTORE IMPORTS AND INITIATION ---
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccount.json');

//--- initialize admin SDK using serviceAcountKey ---
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();



//--- WEB SCRAPING AND AUTOMATION IMPORTS ---
const puppeteer = require('puppeteer');
const selectorForLoadMoreButton = 'div.col-xs-12.col-sm-12.col-md-12.bloom-load-wrapper';


//--- HTTPS REQUEST FOR SPOONACULAR API ---
const axios = require('axios');
const API_KEY = "a5c36fbf6d7045ed8d49a148ee6b2d0d";


//--- VARIABLES TO BE CHANGED ---
const supermarketName = 'Safeway 570 N Shoreline Blvd';
const supermarketurl = 'https://www.safeway.com/shop/aisles/fruits-vegetables/fresh-vegetables-herbs.2948.html';
const latitude = '37.403186';
const longitude = '-122.079275';            
const type = 'safeway';
const imageUrl = 'https://fastly.4sqi.net/img/general/600x600/yfql9tJL2FClw6qtOAKLjUvITgeufKQtVqazxlbYsR4.jpg';
const logoUrl = 'https://i.pinimg.com/280x280_RS/4c/c6/62/4cc66218af7e525656c6784822e343f9.jpg';


(async () => {
  // Starting browser for scraping web data from the website
  const browser = await puppeteer.launch({ headless: false });
  const page = await browser.newPage();

  //Not loading images and fonts to save time
  await page.setRequestInterception(true);
  page.on('request', (request) => {
    if (['image', 'font'].indexOf(request.resourceType()) !== -1) {
      request.abort();
    } else {
      request.continue();
    }
  });

  //Setting the window for the page to maintain a good viewport
  await page.setViewport({ width: 1366, height: 1366 })

  //Going to the safeway site(Fresh Vegetables & Herbs for the example)
  await page.goto(supermarketurl);
  await page.$eval('button[id=onboardingCloseButton]', el => el.click());

  //Determine if the "Load More button is visible"
  const isElementVisible = async (page, cssSelector) => {
    let visible = true;
    await page
      .waitForSelector(cssSelector, { visible: true, timeout: 2000 })
      .catch(() => {
        visible = false;
      });
    return visible;
  };

  //Continue pressing the "Load More" button until it isn't visible
  let loadMoreVisible = await isElementVisible(page, selectorForLoadMoreButton);
  while (loadMoreVisible) {
    await page
      .click(selectorForLoadMoreButton)
      .catch(() => { });
    loadMoreVisible = await isElementVisible(page, selectorForLoadMoreButton);

  }

  //Take all the titles of the products and create a array
  const textsArray = await page.evaluate(
    () => [...document.querySelectorAll('.product-title')].map(elem => elem.innerText)
  );
  
  //Request recipes from the Spoonacular API related to ingredients in list
  let requestString = "https://api.spoonacular.com/recipes/findByIngredients?apiKey=" + API_KEY + "&number=3&ranking=1&ingredients=";

  const ingredientsString = textsArray.map(ingredient => ingredient.replace(/\s/g,'+') + '+');

  requestString = requestString + ingredientsString;
  console.log(requestString);
 
   //Inputting the title of products and recipes relevant to each store into the firebase database
  await axios.get(requestString).then(value => {
    console.log(value.data);
    getDialogue().then(result => {
      const obj = result;
      const quoteData = {
        recipes: obj.recipes,
        ingredients: obj.ingredients,
        type: obj.type,
        latitude: obj.latitude,
        longitude: obj.longitude,
        imageUrl: obj.imageUrl,
        logoUrl: obj.logoUrl,
      };
      return db.collection('stores').doc(supermarketName)
        .set(quoteData).then(() =>
          console.log('new Dialogue written to database'));
    });

    function getDialogue() {
      return new Promise(function (resolve, reject) {
        resolve({
          "recipes": value.data,
          "ingredients": textsArray,
          "type": type,
          "latitude": latitude,
          "longitude": longitude,
          "imageUrl": imageUrl,
          "logoUrl": logoUrl,
        });
      })
    }
  });




  //Close the chromium browser
  await browser.close();

})();

