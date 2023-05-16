function addProducts(num) {
    // var productsList = document.getElementsByClassName("links-list")[0];
    // for (var i = 0; i < num; i++) {
    //   var a = document.createElement("a");
    //   a.setAttribute("href", "https://www.google.com");
    //   var div = document.createElement("div");
    //   div.setAttribute("class", "links");
    //   var p = document.createElement("p");
    //   p.innerHTML = "Test Link";
    //   div.appendChild(p);
    //   a.appendChild(div);
    //   productsList.appendChild(a);
    // }


    const url = 'https://plastic-forest-gallon.glitch.me/get-payment-details'; // replace with your endpoint URL

    const data = {
    name: 'John Doe',
    age: 30,
    email: 'john@example.com'
    }; // replace with your data object

    fetch(url, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json'
    },
    body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(data => console.log(data))
    .catch(error => console.error(error));
}
