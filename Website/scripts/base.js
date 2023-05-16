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
        var productsList = document.getElementsByClassName("links-list")[0];
        for (var i = 0; i < data.links.length; i++) {
            var a = document.createElement("a");
            a.setAttribute("href", data.links[i][1]);
            var div = document.createElement("div");
            div.setAttribute("class", "links");
            var p = document.createElement("h3");
            p.innerHTML = data.links[i][0];
            div.appendChild(p);
            a.appendChild(div);
            productsList.appendChild(a);
        }
    })
    .catch(error => console.error(error));

}
