function addProducts(num) {
    var productsList = document.getElementsByClassName("links-list")[0];
    for (var i = 0; i < num; i++) {
      var a = document.createElement("a");
      a.setAttribute("href", "https://www.google.com");
      var div = document.createElement("div");
      div.setAttribute("class", "links");
      var p = document.createElement("p");
      p.innerHTML = "Test Link";
      div.appendChild(p);
      a.appendChild(div);
      productsList.appendChild(a);
    }
  }