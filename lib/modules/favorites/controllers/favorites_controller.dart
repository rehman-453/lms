import 'dart:convert';

import 'package:get/get.dart';
import 'package:lms/core/network/api_endpoints.dart';
import 'package:lms/core/network/api_services.dart';
import 'package:lms/modules/favorites/models/favorite_model.dart';

class FavoritesController extends GetxController {
  final ApiServices _apiServices = ApiServices();

  final RxList<FavoriteModel> favoritesList = <FavoriteModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiServices.getMethod(
        ApiEndpoints.studentFavoritesUrl,
        true,
      );

      final decodedResponse = jsonDecode(response);

      if (decodedResponse['success'] == true) {
        final List<dynamic> favorites = decodedResponse['data']['data'] ?? [];

        favoritesList.assignAll(
          favorites.map(
            (item) => FavoriteModel.fromJson(Map<String, dynamic>.from(item)),
          ),
        );
      } else {
        errorMessage.value =
            decodedResponse['message'] ?? 'Unable to load favorites.';
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addFavorite(int courseId) async {
    return _updateFavorite(courseId: courseId, isAdding: true);
  }

  Future<bool> removeFavorite(int courseId) async {
    return _updateFavorite(courseId: courseId, isAdding: false);
  }

  Future<bool> _updateFavorite({
    required int courseId,
    required bool isAdding,
  }) async {
    try {
      isUpdating.value = true;

      final url = isAdding
          ? ApiEndpoints.addCourseFavoriteUrl(courseId)
          : ApiEndpoints.removeCourseFavoriteUrl(courseId);

      final response = isAdding
          ? await _apiServices.postMethod(url, {}, true)
          : await _apiServices.deleteMethod(url, true);

      final decodedResponse = jsonDecode(response);

      if (decodedResponse['success'] == true) {
        await fetchFavorites();
        return true;
      }

      return false;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  bool isFavorite(int courseId) {
    return favoritesList.any((favorite) => favorite.courseId == courseId);
  }
}
