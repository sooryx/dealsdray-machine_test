import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:machine_test/model/homescreen_model.dart' as modelbanner;
import 'package:machine_test/model/homescreen_model.dart';
import 'package:machine_test/provider/homescreen_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        label: const Text(
          'Chat',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        icon: Image.asset(
          'assets/icons/chat.png',
          height: 30,
          width: 30,
          color: Colors.white,
        ),
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      backgroundColor: Colors.white,
      body: Consumer<HomescreenProvider>(
        builder: (context, value, child) {
          return value.isLoading
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    _buildAppbar(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildHeaderCarousel(
                                imageUrls:
                                    value.homeScreenModel?.data.bannerOne ??
                                        []),
                            SizedBox(
                              height: 10.h,
                            ),
                            _buildKycCard(),
                            SizedBox(
                              height: 10.h,
                            ),
                            SizedBox(
                              height: 100.h,
                              child: ListView.builder(
                                itemCount:
                                    value.homeScreenModel?.data.category.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  Category? category = value
                                      .homeScreenModel?.data.category[index];
                                  return _buildIconWithText(
                                      category?.label ?? "",
                                      category?.icon ?? "");
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            buildBlogView(
                                products: value.homeScreenModel?.data
                                        .categoriesListing ??
                                    [])
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildIconWithText(String text, String icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60.w,
          height: 60.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(icon), fit: BoxFit.cover)),
        ),
        Text(text,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget _buildHeaderCarousel({required List<modelbanner.Banner> imageUrls}) {
    return CarouselSlider(
      items: imageUrls
          .map((item) => ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                item.banner,
                fit: BoxFit.cover,
              )))
          .toList(),
      options: CarouselOptions(
        autoPlay: true,
        height: 180.h,
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 2),
        viewportFraction: 0.8,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
        pageSnapping: true,
        enlargeFactor: 0.3,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
      ),
    );
  }

  Widget buildBlogView({required List<BrandListing> products}) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(31, 200, 247, 0.929),
          Color.fromRGBO(141, 209, 228, 0.922)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "EXCLUSIVE FOR YOU",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 30,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 350.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  Map<Offer, String> offerStringValues = {
                    Offer.THE_14: "14%",
                    Offer.THE_21: "21%",
                    Offer.THE_32: "32%"
                  };
                  final data = products[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 240,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 28, left: 8, right: 8),
                              child: Center(
                                child: Image.network(
                                  data.icon,
                                  width: 200,
                                  height: 225,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Positioned(
                                top: 10.h,
                                right: 1.w,
                                child: Container(
                                    padding: EdgeInsets.all(5.dg),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.green),
                                    child: Center(
                                        child: Text(
                                      offerStringValues[data.offer] ?? "",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold),
                                    ))))
                          ]),
                          // const SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.all(8.dg),
                            child: Text(
                              data.label,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getData() async {
    final homescreenProvider =
        Provider.of<HomescreenProvider>(context, listen: false);
    await homescreenProvider.getHomescreenData();
  }

  Widget _buildAppbar() {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.white70, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Add padding around the Row
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(Icons.menu),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[500]!.withOpacity(0.2),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/logo.jpeg',
                        height: 30,
                      ),
                    ),

                    hintText: 'Search Here',
                    suffixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide
                            .none), // Add border for better visibility
                  ),
                ),
              ),
            ),
            const Icon(Icons.notifications_none_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildKycCard() {
    return Padding(
      padding: EdgeInsets.all(10.dg),
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadiusDirectional.circular(10),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFF0000FF).withOpacity(0.45),
                  const Color(0xFF0000FF).withOpacity(0.55),
                  const Color(0xFF0000FF).withOpacity(0.57),
                  const Color(0xFF0000FF).withOpacity(0.60),

                  // Colors.transparent,
                ])),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'KYC Pending',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'You need to provide the required',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'documents for your account activation.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.white))),
                child: const Text(
                  'Click Here',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
