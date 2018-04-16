/* global Vue, VueRouter, axios */

var HomePage = {
  template: "#home-page",
  data: function() {
    return {
      message: "Welcome to the T-Shirt Store!",
      products: []
    };
  },
  created: function() {
    axios.get("/v1/products").then(
      function(response) {
        this.products = response.data;
      }.bind(this)
    );
  },
  methods: {
    time: function() {
      var date = new Date();
      var dateTime = date.toLocaleString();
      return dateTime;
    }
  },
  computed: {
    threeProductGroups: function() {
      var groupsArray = [[]];
      var index = 0;
      this.products.forEach(
        function(product) {
          if (groupsArray[index].length < 3) {
            groupsArray[index].push(product);
          } else {
            groupsArray.push([]);
            index += 1;
            groupsArray[index].push(product);
          }
        }.bind(this)
      );
      return groupsArray;
    }
  }
};

var NewProductsPage = {
  template: "#new-products-page",
  data: function() {
    return {
      errors: "",
      name: "",
      size: "",
      price: "",
      description: "",
      inStock: "",
      supplierID: ""
    };
  },
  methods: {
    submit: function() {
      var params = {
        name: this.name,
        size: this.size,
        price: this.price,
        description: this.description,
        in_stock: this.inStock,
        supplier_id: this.supplierID
      };
      axios
        .post("/v1/products", params)
        .then(
          function(response) {
            this.products.push(response.data.product);
            console.log(response);
            console.log(response.data);
            console.log(response.data.product);
            router.push("/");
          }.bind(this)
        )
        .catch(
          function(error) {
            this.errors = error.response.data.errors;
            console.log(error);
            this.name = "";
            this.size = "";
            this.price = "";
            this.description = "";
            this.inStock = "";
            this.supplierID = "";
          }.bind(this)
        );
    }
  }
};

var ShoppingCart = {
  template: "#shopping-cart-page",
  data: function() {
    return {
      message: "Your Shopping Cart",
      cart: [],
      total: { quantities: 0, total: 0 }
    };
  },
  created: function() {
    axios.get("/v1/cartedproducts").then(
      function(response) {
        this.cart = response.data;
        var quantity = 0;
        var total = 0;
        this.cart.forEach(
          function(item) {
            quantity += item.quantity;
            total += item.quantity * item.price;
          }.bind(this)
        );
        this.total.quantities = quantity;
        this.total.total = total;
      }.bind(this)
    );
  },
  methods: {
    time: function() {
      var date = new Date();
      var dateTime = date.toLocaleString();
      return dateTime;
    }
  },
  computed: {}
};

var OrderHistory = {
  template: "#order-history-page",
  data: function() {
    return {
      message: "Your Order History",
      orders: []
    };
  },
  created: function() {
    axios.get("/v1/orders").then(
      function(response) {
        this.orders = response.data;
        console.log(this.orders);
      }.bind(this)
    );
  },
  methods: {
    time: function() {
      var date = new Date();
      var dateTime = date.toLocaleString();
      return dateTime;
    }
  },
  computed: {}
};

var SignupPage = {
  template: "#signup-page",
  data: function() {
    return {
      first_name: "",
      last_name: "",
      email: "",
      password: "",
      passwordConfirmation: "",
      errors: []
    };
  },
  methods: {
    submit: function() {
      var params = {
        first_name: this.first_name,
        last_name: this.last_name,
        email: this.email,
        password: this.password,
        password_confirmation: this.passwordConfirmation
      };
      axios
        .post("/v1/users", params)
        .then(function(response) {
          router.push("/login");
        })
        .catch(
          function(error) {
            this.errors = error.response.data.errors;
          }.bind(this)
        );
    }
  }
};

var LoginPage = {
  template: "#login-page",
  data: function() {
    return {
      email: "",
      password: "",
      errors: []
    };
  },
  methods: {
    submit: function() {
      var params = {
        auth: { email: this.email, password: this.password }
      };
      axios
        .post("/user_token", params)
        .then(function(response) {
          axios.defaults.headers.common["Authorization"] =
            "Bearer " + response.data.jwt;
          localStorage.setItem("jwt", response.data.jwt);
          router.push("/");
        })
        .catch(
          function(error) {
            this.errors = ["Invalid email or password."];
            this.email = "";
            this.password = "";
          }.bind(this)
        );
    }
  }
};

var LogoutPage = {
  template: "<h1>Logout</h1>",
  created: function() {
    axios.defaults.headers.common["Authorization"] = undefined;
    localStorage.removeItem("jwt");
    router.push("/");
  }
};

var router = new VueRouter({
  routes: [
    { path: "/", component: HomePage },
    { path: "/products/new", component: NewProductsPage },
    { path: "/cart", component: ShoppingCart },
    { path: "/orderhistory", component: OrderHistory },
    { path: "/signup", component: SignupPage },
    { path: "/login", component: LoginPage },
    { path: "/logout", component: LogoutPage }
  ],
  scrollBehavior: function(to, from, savedPosition) {
    return { x: 0, y: 0 };
  }
});

var app = new Vue({
  el: "#vue-app",
  router: router,
  created: function() {
    var jwt = localStorage.getItem("jwt");
    if (jwt) {
      axios.defaults.headers.common["Authorization"] = jwt;
    }
  }
});
