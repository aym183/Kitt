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

    const data = {
        username: 'aali183'
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
	    console.log(data);
    })
    .catch(error => console.error(error));
}
