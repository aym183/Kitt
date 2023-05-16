function getLinks() {

    const data = {
        username: 'aym1302'
    };

    fetch('https://plastic-forest-gallon.glitch.me/get-details', 
    { method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    }
    )
    .then(response => response.json())
    .then(data => {
        console.log(data)

        var profileView = document.querySelector('.profile-view');
        var profileImage = document.createElement('img');
        profileImage.classList.add('profile-image');
        profileImage.src = data.profile_image;
        profileImage.alt = 'profile image';
        profileView.appendChild(profileImage);

        var username = document.createElement('h1');
        username.textContent = '@aali183';
        profileView.appendChild(username);

        var linksList = document.getElementsByClassName("links-list")[0];
        for (var i = 0; i < data.links.length; i++) {
            var a = document.createElement("a");
            a.setAttribute("href", data.links[i][1]);
            var div = document.createElement("div");
            div.setAttribute("class", "links");
            var p = document.createElement("h3");
            p.innerHTML = data.links[i][0];
            div.appendChild(p);
            a.appendChild(div);
            linksList.appendChild(a);
        }

        var productsList = document.getElementsByClassName("products-list")[0];
        for (var i = 0; i < data.products.length; i++) {
            var product = document.createElement("div");
            product.setAttribute("class", "products");

            var img = document.createElement("img");
            img.setAttribute("src", data.products[i][3]);
            img.setAttribute("class", "product-image");
            img.setAttribute("alt", "your image description");
            product.appendChild(img);

            var p = document.createElement("p");
            p.setAttribute("class", "product-title");
            p.innerHTML = data.products[i][0];
            product.appendChild(p);

            var div = document.createElement("div");
            div.setAttribute("class", "product-horizontal-row");

            var price = document.createElement("p");
            price.innerHTML = `<b>${data.products[i][2]} AED</b>`;
            div.appendChild(price);

            var button = document.createElement("button");
            button.setAttribute("type", "button");
            button.innerHTML = "Buy Now";
            div.appendChild(button);

            product.appendChild(div);

            productsList.appendChild(product);
        }
    })
    .catch(error => console.error(error));

}
