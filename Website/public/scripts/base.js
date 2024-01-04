function handlePay(event, file, username, price, creator_full_name, profile_image, auth_uuid, fcm_token, product_image, full_description) {
    console.log("Clicked");
    const productTitle = event.target.closest('.product-area').querySelector('.product-title').textContent;
    const productImage = event.target.closest('.product-area').querySelector('.product-image').getAttribute('src');

    fetch("https://mishki-36266.web.app/create-checkout-session", {
        method: "POST",
        headers: {
        "Content-Type": "application/json",
        },
        body: JSON.stringify({
        items: [{price: price, title: productTitle, description: full_description, image: productImage, file: file, username: username, creator_full_name: creator_full_name, profile_image: profile_image, auth_uuid: auth_uuid, fcm_token: fcm_token, product_image: product_image}],
        }),
    })
        .then(res => {
        if (res.ok) return res.json()
        return res.json().then(json => Promise.reject(json))
        })
        .then(({ url }) => {
            window.location = url;
        })
        .catch(e => {
            console.error(`${e.error} This is an error`);
        })

}

function handleImageClick() {
    console.log("Image Clicked");
}