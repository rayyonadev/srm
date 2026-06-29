import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/http_model.dart';

class ApiProvider {
  final String _baseUrl = "http://45.92.173.35/";
  /// Get request --> Get sorov yuborish uchun
  _getRequest(url)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('access')??'';
    try {
      http.Response response = await http.get(headers: {
        "Accept":"application/json",
        "Authorization":"Bearer $token"
      }, Uri.parse(url));
      return await _result(response);
    } catch (e) {
      print("GET REQUEST ERROR ($url): $e");
      return HttResult(
        statusCode: 500,
        isSuccess: false,
        result: jsonEncode({"message": "Tarmoqqa ulanishda xatolik yuz berdi: $e"}),
      );
    }
  }
  /// Post request --> Post sorov yuborish uchun baza malumotlarni yozadi
  _postRequest(url,body)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("access")??"";
    
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    if (token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    print("---------------- API POST CALL ----------------");
    print("URL: $url");
    print("BODY: $body");
    print("-----------------------------------------------");

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body
      );
      print("RESPONSE STATUS: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");
      print("-----------------------------------------------");
      return await _result(response);
    } catch (e) {
      print("POST REQUEST ERROR ($url): $e");
      print("-----------------------------------------------");
      return HttResult(
        statusCode: 500,
        isSuccess: false,
        result: jsonEncode({"message": "Tarmoqqa ulanishda xatolik yuz berdi: $e"}),
      );
    }
  }
  /// Delete request --> Delete sorov yuborish uchun bazadan malumotlarni ochiradi
  _deleteRequest(url,body)async{
    http.Response response = await http.delete(
      headers: {"Accept":"application/json"},
      Uri.parse(url),
      body: body,
    );
    return await _result(response);
  }
  /// Put request --> Put sorov yuborish uchun ma'lum bir malumotni yangilaydi
  _putRequest(url,body)async{
    http.Response response = await http.put(
        headers: {"Accept":"application/json"},
        Uri.parse(url),
        body: body
    );
    return await _result(response);

  }
  /// Patch request --> Patch sorov yuborish uchun Bu ham ma'lum bir ma'lumotni yangilaydi
  _patchRequest(url,body)async{
    http.Response response = await http.patch(
        headers: {"Accept":"application/json"},
        Uri.parse(url),
        body: body
    );
    return await _result(response);
  }
  /// _result funkisyasi apidan kelgan responsalrni tekshiradi va HttpResult modeliga saqlaydi
  Future<HttResult> _result(http.Response response)async{
    print(response.request);
    print(response.body);
    if(response.statusCode >=200 && response.statusCode <299){
      return HttResult(
          statusCode: response.statusCode,
          isSuccess: true,
          result: utf8.decode(response.bodyBytes)
      );
    }else{
      return HttResult(
          statusCode: response.statusCode,
          isSuccess: false,
          result: utf8.decode(response.bodyBytes)
      );
    }
  }
  // Accounts
  Future<HttResult> register(data)async{
    String url = "${_baseUrl}account/register/";
    return await _postRequest(url, data);
  }
  Future<HttResult> login(data)async{
    String url = "${_baseUrl}account/login/";
    return await _postRequest(url, data);
  }
  Future<HttResult> logout(data)async{
    String url = "${_baseUrl}account/logout/";
    return await _postRequest(url, data);
  }
  Future<HttResult> profileGet()async{
    String url = "${_baseUrl}account/profile/";
    return await _getRequest(url);
  }
  Future<HttResult> profilePut(body)async{
    String url = "${_baseUrl}account/profile/";
    return await _putRequest(url, body);
  }
  Future<HttResult> profilePatch(body)async{
    String url = "${_baseUrl}account/profile/";
    return await _patchRequest(url, body);
  }
  // Refresh token
  Future<HttResult> refresh(data)async{
    String url = "${_baseUrl}account/token/refresh/";
    return await _postRequest(url, data);
  }
  // Inspection-Attendance
  Future<HttResult> attendance()async{
    String url = "${_baseUrl}api/inspection/attendances/";
    return await _getRequest(url);
  }
  Future<HttResult> checkIn(data) async {
    String url = "${_baseUrl}api/inspection/check-in/";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("access") ?? "";
    
    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    if (token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    // DEBUG PRINTS FOR DEVELOPER
    print("---------------- CHECK-IN API CALL ----------------");
    print("URL: $url");
    print("HEADERS: $headers");
    print("REQUEST BODY: ${jsonEncode(data)}");
    print("---------------------------------------------------");

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      print("RESPONSE STATUS: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");
      print("---------------------------------------------------");

      return await _result(response);
    } catch (e) {
      print("CHECK-IN ERROR: $e");
      print("---------------------------------------------------");
      return HttResult(
        statusCode: 500,
        isSuccess: false,
        result: e.toString(),
      );
    }
  }
  Future<HttResult> checkInMultipart({
    required String photoPath,
    required double latitude,
    required double longitude,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("access") ?? "";
    print("CHECKIN REQUEST: token='$token', lat=$latitude, lon=$longitude, photoPath=$photoPath");

    final urls = [
      "http://45.92.173.35:8000/api/inspection/check-in/",
      "http://45.92.173.35/api/inspection/check-in/",
    ];
    final fileFields = ['photo', 'image'];

    HttResult? lastResult;

    for (var url in urls) {
      for (var fileField in fileFields) {
        print("CHECKIN TRYING: url='$url', fileField='$fileField'");
        try {
          var request = http.MultipartRequest('POST', Uri.parse(url));
          request.headers.addAll({
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          });

          request.fields['latitude'] = latitude.toString();
          request.fields['longitude'] = longitude.toString();

          request.files.add(
            await http.MultipartFile.fromPath(
              fileField,
              photoPath,
            ),
          );

          var streamedResponse = await request.send().timeout(const Duration(seconds: 8));
          var response = await http.Response.fromStream(streamedResponse);
          
          print("CHECKIN RESPONSE for $url ($fileField): status=${response.statusCode}, body=${response.body}");
          
          lastResult = await _result(response);
          if (lastResult.isSuccess) {
            return lastResult;
          }
          
          // If the server explicitly responded with validation or authorization errors,
          // it means this is the correct endpoint, so we return the result directly.
          if (response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 403) {
            return lastResult;
          }
        } catch (e) {
          print("CHECKIN ERROR for $url ($fileField): $e");
          lastResult = HttResult(
            statusCode: 500,
            isSuccess: false,
            result: jsonEncode({"message": "Ulanish xatoligi: $e"}),
          );
        }
      }
    }

    return lastResult ?? HttResult(
      statusCode: 500,
      isSuccess: false,
      result: jsonEncode({"message": "Serverga ulanib bo'lmadi."}),
    );
  }
// Inspection-Workers
  Future<HttResult> create(data)async{
    String url = "${_baseUrl}api/inspection/workers/create/";
    return await _postRequest(url, data);
  }
// Inspection-Work Zones
  Future<HttResult> zonesGet()async{
    String url = "${_baseUrl}api/inspection/zones/";
    return await _getRequest(url);
  }
  Future<HttResult> zonesPost(data)async{
    String url = "${_baseUrl}api/inspection/zones/";
    return await _postRequest(url, data);
  }
}