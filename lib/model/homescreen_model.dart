import 'dart:convert';

// Convert JSON string to HomeScreenModel
HomeScreenModel homeScreenModelFromJson(String str) =>
    HomeScreenModel.fromJson(json.decode(str));

// Convert HomeScreenModel to JSON string
String homeScreenModelToJson(HomeScreenModel data) => json.encode(data.toJson());

class HomeScreenModel {
  int status;
  Data data;

  HomeScreenModel({
    required this.status,
    required this.data,
  });

  factory HomeScreenModel.fromJson(Map<String, dynamic> json) => HomeScreenModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  List<Banner> bannerOne;
  List<Category> category;
  List<Product> products;
  List<Banner> bannerTwo;
  List<BrandListing> newArrivals;
  List<Banner> bannerThree;
  List<BrandListing> categoriesListing;
  List<TopBrand> topBrands;
  List<BrandListing> brandListing;
  List<Category> topSellingProducts;
  List<BrandListing> featuredLaptop;
  List<TopBrand> upcomingLaptops;
  List<BrandListing> unboxedDeals;
  List<BrandListing> myBrowsingHistory;

  Data({
    required this.bannerOne,
    required this.category,
    required this.products,
    required this.bannerTwo,
    required this.newArrivals,
    required this.bannerThree,
    required this.categoriesListing,
    required this.topBrands,
    required this.brandListing,
    required this.topSellingProducts,
    required this.featuredLaptop,
    required this.upcomingLaptops,
    required this.unboxedDeals,
    required this.myBrowsingHistory,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    bannerOne: List<Banner>.from(json["banner_one"].map((x) => Banner.fromJson(x))),
    category: List<Category>.from(json["category"].map((x) => Category.fromJson(x))),
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    bannerTwo: List<Banner>.from(json["banner_two"].map((x) => Banner.fromJson(x))),
    newArrivals: List<BrandListing>.from(json["new_arrivals"].map((x) => BrandListing.fromJson(x))),
    bannerThree: List<Banner>.from(json["banner_three"].map((x) => Banner.fromJson(x))),
    categoriesListing: List<BrandListing>.from(json["categories_listing"].map((x) => BrandListing.fromJson(x))),
    topBrands: List<TopBrand>.from(json["top_brands"].map((x) => TopBrand.fromJson(x))),
    brandListing: List<BrandListing>.from(json["brand_listing"].map((x) => BrandListing.fromJson(x))),
    topSellingProducts: List<Category>.from(json["top_selling_products"].map((x) => Category.fromJson(x))),
    featuredLaptop: List<BrandListing>.from(json["featured_laptop"].map((x) => BrandListing.fromJson(x))),
    upcomingLaptops: List<TopBrand>.from(json["upcoming_laptops"].map((x) => TopBrand.fromJson(x))),
    unboxedDeals: List<BrandListing>.from(json["unboxed_deals"].map((x) => BrandListing.fromJson(x))),
    myBrowsingHistory: List<BrandListing>.from(json["my_browsing_history"].map((x) => BrandListing.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "banner_one": List<dynamic>.from(bannerOne.map((x) => x.toJson())),
    "category": List<dynamic>.from(category.map((x) => x.toJson())),
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "banner_two": List<dynamic>.from(bannerTwo.map((x) => x.toJson())),
    "new_arrivals": List<dynamic>.from(newArrivals.map((x) => x.toJson())),
    "banner_three": List<dynamic>.from(bannerThree.map((x) => x.toJson())),
    "categories_listing": List<dynamic>.from(categoriesListing.map((x) => x.toJson())),
    "top_brands": List<dynamic>.from(topBrands.map((x) => x.toJson())),
    "brand_listing": List<dynamic>.from(brandListing.map((x) => x.toJson())),
    "top_selling_products": List<dynamic>.from(topSellingProducts.map((x) => x.toJson())),
    "featured_laptop": List<dynamic>.from(featuredLaptop.map((x) => x.toJson())),
    "upcoming_laptops": List<dynamic>.from(upcomingLaptops.map((x) => x.toJson())),
    "unboxed_deals": List<dynamic>.from(unboxedDeals.map((x) => x.toJson())),
    "my_browsing_history": List<dynamic>.from(myBrowsingHistory.map((x) => x.toJson())),
  };
}

class Banner {
  String banner;

  Banner({
    required this.banner,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    banner: json["banner"],
  );

  Map<String, dynamic> toJson() => {
    "banner": banner,
  };
}

class BrandListing {
  String icon;
  Offer? offer;
  String? brandIcon;
  String label;
  String? price;

  BrandListing({
    required this.icon,
    this.offer,
    this.brandIcon,
    required this.label,
    this.price,
  });

  factory BrandListing.fromJson(Map<String, dynamic> json) => BrandListing(
    icon: json["icon"],
    offer: json["offer"] != null ? offerValues.map[json["offer"]] : null,
    brandIcon: json["brandIcon"],
    label: json["label"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "offer": offer != null ? offerValues.reverse[offer] : null,
    "brandIcon": brandIcon,
    "label": label,
    "price": price,
  };
}

enum Offer {
  THE_14,
  THE_21,
  THE_32
}

final offerValues = EnumValues({
  "14%": Offer.THE_14,
  "21%": Offer.THE_21,
  "32%": Offer.THE_32
});

class Category {
  String label;
  String icon;

  Category({
    required this.label,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    label: json["label"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "icon": icon,
  };
}

class Product {
  String icon;
  String offer;
  String label;
  String? subLabel;
  String? sublabel;

  Product({
    required this.icon,
    required this.offer,
    required this.label,
    this.subLabel,
    this.sublabel,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    icon: json["icon"],
    offer: json["offer"],
    label: json["label"],
    subLabel: json["SubLabel"],
    sublabel: json["Sublabel"],
  );

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "offer": offer,
    "label": label,
    "SubLabel": subLabel,
    "Sublabel": sublabel,
  };
}

class TopBrand {
  String icon;

  TopBrand({
    required this.icon,
  });

  factory TopBrand.fromJson(Map<String, dynamic> json) => TopBrand(
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "icon": icon,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
