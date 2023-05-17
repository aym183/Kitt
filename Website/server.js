const express = require("express");
const cors = require("cors");
const path = require('path');
var admin = require("firebase-admin");
var credentials = require("./config.json");
const app = express();

app.use(express.static("public"));
app.use(express.json());
app.use(cors());
app.set("view engine", "ejs");


// EDIT WHEN IN PROD ENV
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});
admin.initializeApp({
  credential: admin.credential.cert(credentials),
  storageBucket: 'mishki-36266.appspot.com'
});

const db = admin.firestore()
const bucket = admin.storage().bucket();

const getLinks = async (link) => {

  try {
    const linksRef = db.collection("links").doc(link);
    const response = await linksRef.get();
    const valuesArr = Object.values(response.data());
    
    var responseArr = []
    for (const obj of valuesArr) {
      responseArr.push([obj.name, obj.url])
    }
    return responseArr
    
  } catch(error) {
    console.log(error)
  }
}

const getProducts = async (product) => {
  try {
    const productsRef = db.collection("products").doc(product);
    const response = await productsRef.get();
    const valuesArr = Object.values(response.data());
    
    var responseArr = []
    for (const obj of valuesArr) {
      var image = await getImageFromPath(obj.image)
      responseArr.push([obj.name, obj.description, obj.price, image])
    }
    return responseArr
    
  } catch(error) {
    console.log(error)
  }
}

const getImageFromPath = async (path) => {
  try {
    const file = bucket.file(path);
    const fileExists = await file.exists();
    if (!fileExists[0]) {
      throw new Error(`File ${path} not found`);
    }
    const [url] = await file.getSignedUrl({
      action: 'read',
      expires: '03-01-2500',
    });
    return url;
  } catch (error) {
    console.error(`Error getting image from storage: ${error}`);
    return null;
  }
}

app.get("/index.html", async (req, res) => {
  // const filePath = path.join(__dirname, 'index.html');
  // res.sendFile(filePath);
  try {
    const userRef = db.collection("users");
    const response = await userRef.where("username", "==", "aym1302").get();
    let responseArr = []
    
    response.forEach(doc => {
      responseArr.push(doc.data());
    });
    
    const [linksResponse, productsResponse, profileImageResponse] = await Promise.all([
      getLinks(responseArr[0].links),
      getProducts(responseArr[0].products),
      getImageFromPath(responseArr[0].profile_image)
    ]);
    // var linksResponse = await getLinks(responseArr[0].links)
    // var productsResponse = await getLinks(responseArr[0].links)
                                       
   
    res.render("index", { links: linksResponse, products: productsResponse, profile_image: profileImageResponse });
  } catch(error) {
    console.log(error)
  }

});

app.post('/get-details', async (req, res) => {
  
  const items = req.body

  try {
    const userRef = db.collection("users");
    const response = await userRef.where("username", "==", items.username).get();
    let responseArr = []
    
    response.forEach(doc => {
      responseArr.push(doc.data());
    });
    
    const [linksResponse, productsResponse, profileImageResponse] = await Promise.all([
      getLinks(responseArr[0].links),
      getProducts(responseArr[0].products),
      getImageFromPath(responseArr[0].profile_image)
    ]);
    // var linksResponse = await getLinks(responseArr[0].links)
    // var productsResponse = await getLinks(responseArr[0].links)
                                       
    res.send({
      links: linksResponse,
      products: productsResponse,
      profile_image: profileImageResponse
    });
  } catch(error) {
    console.log(error)
  }
});


app.listen(8091, () => console.log("Node server listening on port 8091!"));