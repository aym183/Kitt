const functions = require("firebase-functions");
require('dotenv').config();
const express = require("express");
const cors = require("cors");
const bodyparser = require("body-parser");
const path = require('path');
var admin = require("firebase-admin");
const nodemailer = require('nodemailer');
var credentials = require("./config.json");
const app = express();
const stripe = require('stripe')(process.env.STRIPE_PRIVATE_KEY);
var files_dict = {};
var images_dict = {};
const storeItemsPrice = new Map([])
app.use(express.static("public"));
app.use(express.json());
app.use(cors());
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "/views"));
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

admin.initializeApp({
  credential: admin.credential.cert(credentials),
  storageBucket: 'mishki-36266.appspot.com',
  databaseURL: 'https://mishki-36266-default-rtdb.europe-west1.firebasedatabase.app/'
});
const db = admin.firestore()
const rt_db = admin.database()
const bucket = admin.storage().bucket();

const getLinks = async (link) => {
  try {
    const linksRef = db.collection("links").doc(link);
    const response = await linksRef.get();
    if (typeof response.data() === 'undefined') {
      return []
    } else {
      const valuesArr = Object.values(response.data());
    
      var responseArr = []
      for (const obj of valuesArr) {
        responseArr.push([obj.name, obj.url])
      }
      return responseArr
    }
    
  } catch(error) {
    console.log(error)
  }
}

async function addToDict(object, path, value) {
  return object[path] = value;
}

async function getKeyByValue(object, value) {
  for (const [key, val] of Object.entries(object)) {
    if (val === value) {
      return key;
    }
  }
  return null;
}

const getProducts = async (product) => {
  try {
    const productsRef = db.collection("products").doc(product);
    const response = await productsRef.get();
    if (typeof response.data() === 'undefined') {
      return []
    } else {
      const valuesArr = Object.values(response.data());
      var responseArr = []
      for (const [index, obj] of valuesArr.entries()) {
        if (obj.description != null) {
          var image = await getImageFromPath(obj.image);
          console.log(`${obj.file} file from getProducts`);
          var file = await getFileFromPath(obj.file)  ;
          responseArr.push({name: obj.name, description: `${obj.description.substring(0, 100)}...`, price: obj.price, image: image, file: file, index: obj.index, full_description: obj.description.trim()});
          storeItemsPrice.set(obj.name, {price: obj.price, description: obj.description.trim(), file: file, image: obj.image});
        } else {
          responseArr.push({name: obj.name, url: obj.url, index: obj.index})
        }
      }
      global_logo = await getLogoFromPath("kitt_app_logo.png");
      responseArr.sort((a, b) => parseInt(a.index) - parseInt(b.index));
      return responseArr
    }
  } catch(error) {
    console.log(error)
  }
}


const getClasses = async (input) => {
  try {
    const classesRef = db.collection("classes").doc(input);
    const response = await classesRef.get();
    if (typeof response.data() === 'undefined') {
      return []
    } else {
      const valuesArr = Object.values(response.data());
      var responseArr = []
      for (const [index, obj] of valuesArr.entries()) {
        var image = await getImageFromPath(obj.image)
        responseArr.push([obj.name, obj.description, obj.price, image, obj.seats, obj.location, obj.duration])
      }
      return responseArr
    }
  } catch(error) {
    console.log(error)
  }
}

const addSale = async (input) => {
  try {
    const salesRef = db.collection("sales").doc(input["auth_uuid"]);
    const response = await salesRef.get();
    const saleId = db.collection("sales").doc().id;
    const currentDate = new Date();
    const currentTime = currentDate.toLocaleTimeString();

    const documentData = {
      [saleId]: {
        "name": input["name"],
        "date": currentDate,
        "time": currentTime,
        "image": input["product_image"],
        "price": input["price"],
        "email": input["email"],
      }
    };

    const message = {
      notification: {
          title: 'You have a new sale! 🥳',
          body: `${input["name"].trim()} has sold for ${input["price"]} AED`,
      },
      token: input["fcm_token"],
      data: {
        image: global_logo
    }
  };

    if (!response.exists) {
      await salesRef.set(documentData);
      await rt_db.ref("sales").child(input["auth_uuid"]).child(saleId).set({
        "name": input["name"],
        "date": `${currentDate}`,
        "time": currentTime,
        "image": input["product_image"],
        "price": input["price"],
        "email": input["email"],
      })
      const notification_response = await admin.messaging().send(message);
      console.log('Notification sent:', notification_response);
    }

    const valuesArr = Object.values(response.data());
    const sales_number = valuesArr.length;
    console.log(`${sales_number} is the number of sales`);

    if (sales_number !== 0) {
      await salesRef.update(documentData);
      await rt_db.ref("sales").child(input["auth_uuid"]).child(saleId).update({
        "name": input["name"],
        "date": `${currentDate}`,
        "time": currentTime,
        "image": input["product_image"],
        "price": input["price"],
        "email": input["email"],
      })
      const notification_response = await admin.messaging().send(message);
      console.log('Notification sent:', notification_response);
    } else {
      await salesRef.set(documentData);
      await rt_db.ref("sales").child(input["auth_uuid"]).child(saleId).set({
        "name": input["name"],
        "date": `${currentDate}`,
        "time": currentTime,
        "image": input["product_image"],
        "price": input["price"],
        "email": input["email"],
      })
      const notification_response = await admin.messaging().send(message);
      console.log('Notification sent:', notification_response);
    }

  } catch (error) {
    console.error("Error adding sale:", error);
  }
}

const getLogoFromPath = async (path) => {
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
    await addToDict(images_dict, path, url);
    if (images_dict[path] == url) {
      console.log("logo added");
    }
    return url;
  } catch (error) {
    console.error(`Error getting image from storage: ${error}`);
    return null;
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
    await addToDict(images_dict, path, url);
    if (images_dict[path] == url) {
      console.log("image added");
    }
    return url;
  } catch (error) {
    console.error(`Error getting image from storage: ${error}`);
    return null;
  }
}

const getFileFromPath = async (path) => {
  try {
    const fileRef = bucket.file(path);
    const fileExists = await fileRef.exists();
    if (!fileExists) {
      throw new Error(`File ${path} not found`);
    }
    const [url] = await fileRef.getSignedUrl({
      action: 'read',
      expires: '03-01-2500',
    });
    await addToDict(files_dict, path, url);
    if (files_dict[path] == url) {
      console.log("file added");
    }
    return url;
  } catch (error) {
    console.error(`Error getting file from storage: ${error}`);
    return null;
  }
};

app.get("/:username/success", async (req, res) => {
  res.render("success", {username: req.params.username});
});

app.get("/:username", async (req, res) => {

  console.log(path.resolve(__dirname));
  const username = req.params.username;
  console.log(`The user entered: ${username}`);
  try {
    const userRef = db.collection("users");
    const response = await userRef.where("metadata.username", "==", username).get();
    let responseArr = []
    response.forEach(doc => {
      responseArr.push(doc.data());
    });

    if (responseArr.length == 0) {
      res.render("404");
    } else {
      global_username = username;
      global_full_name = responseArr[0].metadata.full_name;
      global_auth_uuid = responseArr[0].auth_uuid;
      global_fcm = responseArr[0].fcm_token
      const [productsResponse, profileImageResponse] = await Promise.all([
        getProducts(responseArr[0].metadata.products),
        getImageFromPath(responseArr[0].metadata.profile_image)
      ]);

      global_profile_image = profileImageResponse;
      res.render("home", { full_name: responseArr[0].metadata.full_name, username: responseArr[0].metadata.username, bio: responseArr[0].metadata.bio, products: productsResponse, profile_image: profileImageResponse, instagram: responseArr[0].metadata.instagram, tiktok: responseArr[0].metadata.tiktok, youtube: responseArr[0].metadata.youtube, facebook: responseArr[0].metadata.facebook, website: responseArr[0].metadata.website, social_email: responseArr[0].metadata.social_email, auth_uuid: responseArr[0].auth_uuid, fcm_token: responseArr[0].fcm_token});
    }

  } catch(error) {
    console.log(error)
  }

});

app.post("/create-payment-intent", async (req, res) => {
  const { items } = req.body;
  const paymentIntent = await stripe.paymentIntents.create({
    amount: calculateOrderAmount(items),
    currency: "aed",
    automatic_payment_methods: {
      enabled: true,
    },
  });
  res.send({
    clientSecret: paymentIntent.client_secret,
  });
});

app.post("/create-checkout-session", async (req, res) => {
  try {
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ["card"],
      mode: "payment",
      line_items: req.body.items.map(item => {
        return {
          price_data: {
            currency: "aed",
            product_data: {
              name: item.title,
              description: item.description,
            },
            unit_amount: parseInt(item.price)*100,
          },
          quantity: 1,
        }
      }),
      success_url: `${process.env.SERVER_URL}/${req.body.items[0].username}/success`,
      cancel_url: `${process.env.SERVER_URL}/${req.body.items[0].username}`,
      metadata: {
        username: req.body.items[0].username,
        name: req.body.items[0].title,
        description: req.body.items[0].description,
        price: req.body.items[0].price,
        file:`${await getKeyByValue(files_dict, req.body.items[0].file)}`,
        creator: req.body.items[0].creator_full_name,
        profile_image: `${await getKeyByValue(images_dict, req.body.items[0].profile_image)}`,
        auth_uuid: req.body.items[0].auth_uuid,
        fcm_token: req.body.items[0].fcm_token,
        product_image: `${await getKeyByValue(images_dict, req.body.items[0].product_image)}`
      },
    })
    res.json({ url: session.url })
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

app.post("/checkout_webhook_production", bodyparser.raw({type: "application/json"}) , async (req, res) => {

  let transporter = await nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 465,
    secure: true,
    auth: {
      user: `${process.env.EMAIL_USER}`,
      pass: `${process.env.EMAIL_PASS}`, 
    },
  });

  if (req.body.type == 'checkout.session.completed') {
    const email = req.body.data['object']['customer_details']['email'];
    const name = req.body.data['object']['customer_details']['name'];
    const creator = req.body.data['object']['metadata']['creator'];
    const product_name = req.body.data['object']['metadata']['name'];
    const meta_file = req.body.data['object']['metadata']['file'];
    const meta_profile_image = req.body.data['object']['metadata']['profile_image'];
    const meta_auth = req.body.data['object']['metadata']['auth_uuid'];
    const meta_fcm = req.body.data['object']['metadata']['fcm_token'];
    const meta_price = req.body.data['object']['metadata']['price'];
    const meta_product_image = req.body.data['object']['metadata']['product_image'];

    await transporter.sendMail({
      from: 'Kitt App',
      to: email,
      subject: `Here's your order from ${creator.split(' ')[0]}'s store`,
      html: `
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office" style="font-family:arial, 'helvetica neue', helvetica, sans-serif">
 <head>
  <meta charset="UTF-8">
  <meta content="width=device-width, initial-scale=1" name="viewport">
  <meta name="x-apple-disable-message-reformatting">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta content="telephone=no" name="format-detection">
  <title>New message</title><!--[if (mso 16)]>
    <style type="text/css">
    a {text-decoration: none;}
    </style>
    <![endif]--><!--[if gte mso 9]><style>sup { font-size: 100% !important; }</style><![endif]--><!--[if gte mso 9]>
<xml>
    <o:OfficeDocumentSettings>
    <o:AllowPNG></o:AllowPNG>
    <o:PixelsPerInch>96</o:PixelsPerInch>
    </o:OfficeDocumentSettings>
</xml>
<![endif]--><!--[if !mso]><!-- -->
  <link href="https://fonts.googleapis.com/css2?family=Imprima&display=swap" rel="stylesheet"><!--<![endif]--><!--[if !mso]><!-- -->
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:400,400i,700,700i" rel="stylesheet"><!--<![endif]-->
  <style type="text/css">
#outlook a {
	padding:0;
}
.es-button {
	mso-style-priority:100!important;
	text-decoration:none!important;
}
a[x-apple-data-detectors] {
	color:inherit!important;
	text-decoration:none!important;
	font-size:inherit!important;
	font-family:inherit!important;
	font-weight:inherit!important;
	line-height:inherit!important;
}
.es-desk-hidden {
	display:none;
	float:left;
	overflow:hidden;
	width:0;
	max-height:0;
	line-height:0;
	mso-hide:all;
}
@media only screen and (max-width:600px) {p, ul li, ol li, a { line-height:150%!important } h1, h2, h3, h1 a, h2 a, h3 a { line-height:120% } h1 { font-size:30px!important; text-align:left } h2 { font-size:24px!important; text-align:left } h3 { font-size:20px!important; text-align:left } .es-header-body h1 a, .es-content-body h1 a, .es-footer-body h1 a { font-size:30px!important; text-align:left } .es-header-body h2 a, .es-content-body h2 a, .es-footer-body h2 a { font-size:24px!important; text-align:left } .es-header-body h3 a, .es-content-body h3 a, .es-footer-body h3 a { font-size:20px!important; text-align:left } .es-menu td a { font-size:14px!important } .es-header-body p, .es-header-body ul li, .es-header-body ol li, .es-header-body a { font-size:14px!important } .es-content-body p, .es-content-body ul li, .es-content-body ol li, .es-content-body a { font-size:14px!important } .es-footer-body p, .es-footer-body ul li, .es-footer-body ol li, .es-footer-body a { font-size:14px!important } .es-infoblock p, .es-infoblock ul li, .es-infoblock ol li, .es-infoblock a { font-size:12px!important } *[class="gmail-fix"] { display:none!important } .es-m-txt-c, .es-m-txt-c h1, .es-m-txt-c h2, .es-m-txt-c h3 { text-align:center!important } .es-m-txt-r, .es-m-txt-r h1, .es-m-txt-r h2, .es-m-txt-r h3 { text-align:right!important } .es-m-txt-l, .es-m-txt-l h1, .es-m-txt-l h2, .es-m-txt-l h3 { text-align:left!important } .es-m-txt-r img, .es-m-txt-c img, .es-m-txt-l img { display:inline!important } .es-button-border { display:block!important } a.es-button, button.es-button { font-size:18px!important; display:block!important; border-right-width:0px!important; border-left-width:0px!important; border-top-width:15px!important; border-bottom-width:15px!important } .es-adaptive table, .es-left, .es-right { width:100%!important } .es-content table, .es-header table, .es-footer table, .es-content, .es-footer, .es-header { width:100%!important; max-width:600px!important } .es-adapt-td { display:block!important; width:100%!important } .adapt-img { width:100%!important; height:auto!important } .es-m-p0 { padding:0px!important } .es-m-p0r { padding-right:0px!important } .es-m-p0l { padding-left:0px!important } .es-m-p0t { padding-top:0px!important } .es-m-p0b { padding-bottom:0!important } .es-m-p20b { padding-bottom:20px!important } .es-mobile-hidden, .es-hidden { display:none!important } tr.es-desk-hidden, td.es-desk-hidden, table.es-desk-hidden { width:auto!important; overflow:visible!important; float:none!important; max-height:inherit!important; line-height:inherit!important } tr.es-desk-hidden { display:table-row!important } table.es-desk-hidden { display:table!important } td.es-desk-menu-hidden { display:table-cell!important } .es-menu td { width:1%!important } table.es-table-not-adapt, .esd-block-html table { width:auto!important } table.es-social { display:inline-block!important } table.es-social td { display:inline-block!important } .es-desk-hidden { display:table-row!important; width:auto!important; overflow:visible!important; max-height:inherit!important } }
</style>
 </head>
 <body data-new-gr-c-s-loaded="14.1112.0" style="width:100%;font-family:arial, 'helvetica neue', helvetica, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0">
  <div class="es-wrapper-color" style="background-color:#FFFFFF"><!--[if gte mso 9]>
			<v:background xmlns:v="urn:schemas-microsoft-com:vml" fill="t">
				<v:fill type="tile" color="#ffffff"></v:fill>
			</v:background>
		<![endif]-->
   <table class="es-wrapper" width="100%" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;padding:0;Margin:0;width:100%;height:100%;background-repeat:repeat;background-position:center top;background-color:#FFFFFF">
     <tr>
      <td valign="top" style="padding:0;Margin:0">
       <table cellpadding="0" cellspacing="0" class="es-footer" align="center" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top">
         <tr>
          <td align="center" style="padding:0;Margin:0">
           <table bgcolor="#bcb8b1" class="es-footer-body" align="center" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;width:600px">
             <tr>
              <td align="left" style="Margin:0;padding-top:20px;padding-bottom:20px;padding-left:40px;padding-right:40px">
               <table cellpadding="0" cellspacing="0" width="100%" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">
                 <tr>
                  <td align="center" valign="top" style="padding:0;Margin:0;width:520px">
                   <table cellpadding="0" cellspacing="0" width="100%" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">
                     <tr>
                      <td align="center" style="padding:0;Margin:0;display:none"></td>
                     </tr>
                   </table></td>
                 </tr>
               </table></td>
             </tr>
           </table></td>
         </tr>
       </table>
       <table cellpadding="0" cellspacing="0" class="es-content" align="center" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%">
         <tr>
          <td align="center" style="padding:0;Margin:0">
           <table bgcolor="#efefef" class="es-content-body" align="center" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#EFEFEF;border-radius:20px 20px 0 0;width:600px">
             <tr>
              <td align="left" bgcolor="#f5f5f5" style="padding:0;Margin:0;padding-top:40px;padding-left:40px;padding-right:40px;background-color:#f5f5f5">
               <table cellpadding="0" cellspacing="0" width="100%" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">
                 <tr>
                  <td align="center" valign="top" style="padding:0;Margin:0;width:520px">
                   <table cellpadding="0" cellspacing="0" width="100%" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">
                     <tr>
                      <td align="center" class="es-m-txt-c" style="padding:0;Margin:0;font-size:0px"><a target="_blank" href="https://viewstripo.email" style="-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;text-decoration:underline;color:#2D3142;font-size:18px"><img src="${images_dict[meta_profile_image]}" alt="Confirm email" style="display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;border-radius:50%;width:80px;height:80px;overflow:hidden;object-fit:cover;margin-bottom:-20px" title="Confirm email"></a></td>
                     </tr>
                     <tr>
                      <td align="center" style="padding:0;Margin:0"><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:'open sans', 'helvetica neue', helvetica, arial, sans-serif;line-height:23px;color:#2D3142;font-size:15px"><b>${creator}<b></p></td>
                     </tr>
                   </table></td>
                 </tr>
               </table></td>
             </tr>
             <tr>
              <td align="left" bgcolor="#f5f5f5" style="padding:0;Margin:0;padding-top:20px;padding-left:40px;padding-right:40px;background-color:#f5f5f5">
               <table cellpadding="0" cellspacing="0" width="100%" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">
                 <tr>
                  <td align="center" valign="top" style="padding:0;Margin:0;width:520px">
                   <table cellpadding="0" cellspacing="0" width="100%" bgcolor="#fafafa" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:separate;border-spacing:0px;background-color:#fafafa;border-radius:10px" role="presentation">
                     <tr>
                      <td align="center" bgcolor="#f5f5f5" style="padding:20px;Margin:0"><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:'open sans', 'helvetica neue', helvetica, arial, sans-serif;line-height:30px;color:#2D3142;font-size:20px"><i>"Thank you for purchasing from my store! Please download the attachment in this email. Enjoy! 😊"</i></p></td>
                     </tr>
                   </table></td>
                 </tr>
               </table></td>
             </tr>
           </table></td>
         </tr>
       </table>
       <table cellpadding="0" cellspacing="0" class="es-content" align="center" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%">
         <tr>
          <td align="center" style="padding:0;Margin:0">
           <table bgcolor="#f5f5f5" class="es-content-body" align="center" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#f5f5f5;width:600px">
             <tr>
              <td align="left" style="padding:0;Margin:0;padding-left:40px;padding-right:40px">
               <table cellpadding="0" cellspacing="0" width="100%" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">
                 <tr>
                  <td align="center" valign="top" style="padding:0;Margin:0;width:520px">
                   <table cellpadding="0" cellspacing="0" width="100%" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">
                     <tr>
                      <td align="center" style="padding:0;Margin:0;padding-top:10px;padding-bottom:10px;font-size:0">
                       <table border="0" width="100%" height="100%" cellpadding="0" cellspacing="0" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">
                         <tr>
                          <td style="padding:0;Margin:0;border-bottom:1px solid #666666;background:unset;height:1px;width:100%;margin:0px"></td>
                         </tr>
                       </table></td>
                     </tr>
                   </table></td>
                 </tr>
               </table></td>
             </tr>
           </table></td>
         </tr>
       </table>
       <table cellpadding="0" cellspacing="0" class="es-content" align="center" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%">
         <tr>
          <td align="center" style="padding:0;Margin:0">
           <table bgcolor="#efefef" class="es-content-body" align="center" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#EFEFEF;border-radius:0 0 20px 20px;width:600px">
             <tr>
              <td class="esdev-adapt-off" align="left" bgcolor="#f5f5f5" style="Margin:0;padding-top:5px;padding-bottom:20px;padding-left:40px;padding-right:40px;background-color:#f5f5f5">
               <table cellpadding="0" cellspacing="0" width="100%" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">
                 <tr>
                  <td align="center" valign="top" style="padding:0;Margin:0;width:520px">
                   <table cellpadding="0" cellspacing="0" width="100%" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">
                     <tr>
                      <td align="center" style="padding:0;Margin:0"><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:'open sans', 'helvetica neue', helvetica, arial, sans-serif;line-height:21px;color:#a9a9a9;font-size:14px">Contact hello@kitt.bio if you need any help with your order.</p></td>
                     </tr>
                   </table></td>
                 </tr>
               </table></td>
             </tr>
           </table></td>
         </tr>
       </table>
       <table cellpadding="0" cellspacing="0" class="es-footer" align="center" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top">
         <tr>
          <td align="center" style="padding:0;Margin:0">
           <table bgcolor="#bcb8b1" class="es-footer-body" align="center" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;width:600px">
             <tr>
              <td align="left" style="Margin:0;padding-left:20px;padding-right:20px;padding-bottom:30px;padding-top:40px">
               <table cellpadding="0" cellspacing="0" width="100%" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">
                 <tr>
                  <td align="left" style="padding:0;Margin:0;width:560px">
                   <table cellpadding="0" cellspacing="0" width="100%" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">
                    <tr>
                      <td align="center" class="es-m-txt-c" style="padding:0;Margin:0;padding-bottom:20px;font-size:0px"><img src="${global_logo}" alt="Logo" style="display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;border-radius:50%;width:48px;height:48px;overflow:hidden;object-fit:cover;" title="Logo"></td>
                    </tr>
                     <tr>
                      <td align="center" style="padding:0;Margin:0"><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:'open sans', 'helvetica neue', helvetica, arial, sans-serif;line-height:23px;color:#2D3142;font-size:15px">Powered by Kitt</p><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:'open sans', 'helvetica neue', helvetica, arial, sans-serif;line-height:23px;color:#2D3142;font-size:15px">Create your own store at <a href="https://kitt.bio">kitt.bio</a></p></td>
                     </tr>
                   </table></td>
                 </tr>
               </table></td>
             </tr>
           </table></td>
         </tr>
       </table>
       <table cellpadding="0" cellspacing="0" class="es-footer" align="center" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top">
         <tr>
          <td align="center" style="padding:0;Margin:0">
           <table bgcolor="#ffffff" class="es-footer-body" align="center" cellpadding="0" cellspacing="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;width:600px">
             <tr>
              <td align="left" style="padding:20px;Margin:0">
               <table cellpadding="0" cellspacing="0" width="100%" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">
                 <tr>
                  <td align="left" style="padding:0;Margin:0;width:560px">
                   <table cellpadding="0" cellspacing="0" width="100%" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px">
                     <tr>
                      <td align="center" style="padding:0;Margin:0;display:none"></td>
                     </tr>
                   </table></td>
                 </tr>
               </table></td>
             </tr>
           </table></td>
         </tr>
       </table></td>
     </tr>
   </table>
  </div>
 </body>
</html>
      `,
      attachments: [{
        filename: `${creator.split(' ')[0]}'s ${product_name}`,
        path: files_dict[meta_file],
        contentType: 'application/pdf'
      }],
    });

    await addSale({"email": email, "name": product_name, "price": meta_price, "auth_uuid": meta_auth, "fcm_token": meta_fcm, "product_image": meta_product_image});

    res.json({ status: "true" });
  } else {
    console.log("Failure in webhook");
    res.json({ status: "false" });
  }
})

exports.app = functions.https.onRequest(app);