/* global axios */

var productTemplate = document.querySelector("#listed-product");
var productContainer = document.querySelector(".card-deck");

axios.get("http://localhost:3000/v1/products").then(function(response) {
  var products = response.data;
  console.log(products);

  products.forEach(function(product) {
    var productClone = productTemplate.content.cloneNode(true);
    productClone.querySelector(".name").innerText = product.name;
    productClone.querySelector(".text").innerText = product.description;
    productClone.querySelector(".image").src = product.images[0]["url"];
    productContainer.appendChild(productClone);
  });
});
// productContainer.appendChild(productTemplate.content.cloneNode(true));
// productContainer.appendChild(productTemplate.content.cloneNode(true));
// productContainer.appendChild(productTemplate.content.cloneNode(true));
// productContainer.appendChild(productTemplate.content.cloneNode(true));
// productContainer.appendChild(productTemplate.content.cloneNode(true));
// productContainer.appendChild(productTemplate.content.cloneNode(true));
