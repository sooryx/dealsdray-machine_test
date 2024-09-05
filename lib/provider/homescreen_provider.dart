import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:machine_test/model/homescreen_model.dart';

class HomescreenProvider with ChangeNotifier {
  HomeScreenModel? _homeScreenModel;
  bool _isLoading = false;

  HomeScreenModel? get homeScreenModel => _homeScreenModel;
  bool get isLoading => _isLoading;

  // Lists to store banner URLs
  List<String> bannerOneUrls = [];
  List<String> bannerTwoUrls = [];
  List<String> bannerThreeUrls = [];

  Future<void> getHomescreenData() async {
    _setLoading(true);
    final url = Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(response.body);
        final data = json.decode(response.body);
        _homeScreenModel = HomeScreenModel.fromJson(data);


        bannerOneUrls = _homeScreenModel?.data.bannerOne.map((banner) => banner.banner).toList() ?? [];
        bannerTwoUrls = _homeScreenModel?.data.bannerTwo.map((banner) => banner.banner).toList() ?? [];
        bannerThreeUrls = _homeScreenModel?.data.bannerThree.map((banner) => banner.banner).toList() ?? [];
        notifyListeners();
      } else {
        throw Exception('Failed to load home screen data');
      }
    } catch (error) {
      print('Error: $error');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
