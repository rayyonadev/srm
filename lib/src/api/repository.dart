import '../model/http_model.dart';
import 'api_provider.dart';

class Repository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<HttResult> register(data) async => await _apiProvider.register(data);

  Future<HttResult> login(data) async => await _apiProvider.login(data);

  Future<HttResult> logout(data) async => await _apiProvider.logout(data);

  Future<HttResult> profileGet() async => await _apiProvider.profileGet();

  Future<HttResult> profilePut(body) async =>
      await _apiProvider.profilePut(body);

  Future<HttResult> profilePatch(body) async =>
      await _apiProvider.profilePatch(body);

  Future<HttResult> refresh(data) async => await _apiProvider.refresh(data);

  Future<HttResult> attendance() async => await _apiProvider.attendance();

  Future<HttResult> checkIn(data) async => await _apiProvider.checkIn(data);

  Future<HttResult> checkInMultipart({
    required String photoPath,
    required double latitude,
    required double longitude,
  }) async =>
      await _apiProvider.checkInMultipart(
        photoPath: photoPath,
        latitude: latitude,
        longitude: longitude,
      );

  Future<HttResult> create(data) async => await _apiProvider.create(data);

  Future<HttResult> zonesGet() async => await _apiProvider.zonesGet();

  Future<HttResult> zonesPost(data) async => await _apiProvider.zonesPost(data);
}

Repository repository = Repository();
