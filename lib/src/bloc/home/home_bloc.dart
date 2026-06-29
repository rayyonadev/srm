import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/repository.dart';
import '../../model/profile_model.dart';
import '../../utilis/cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Repository repository;

  HomeBloc({required this.repository}) : super(HomeInitialState()) {
    on<FetchProfileEvent>((event, emit) async {
      emit(HomeLoadingState());
      try {
        final result = await repository.profileGet();
        if (result.isSuccess) {
          final dynamic rawResult = result.result;
          Map<String, dynamic> data = {};
          
          if (rawResult is String) {
            data = jsonDecode(rawResult);
          } else if (rawResult is Map) {
            data = Map<String, dynamic>.from(rawResult);
          }
          
          final profile = ProfileModel.fromJson(data);

          // Update local cache with latest profile data
          CacheService.saveUserFirstName(profile.firstName);
          CacheService.saveUserLastName(profile.lastName);
          if (profile.id != null) {
            await CacheService.saveUserId(profile.id!.toString());
          }
          if (profile.role != null) {
            await CacheService.saveUserRole(profile.role!);
          }
          if (profile.balance != null) {
            CacheService.saveBalance(profile.balance!.toInt());
          }

          // Fetch attendance status for today
          bool isCheckedInToday = false;
          try {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            final String todayStr = DateTime.now().toString().split(' ').first;
            final String lastCheckInDate = prefs.getString('last_check_in_date') ?? '';
            if (lastCheckInDate == todayStr) {
              isCheckedInToday = true;
            }
          } catch (e) {
            print("Error checking local check-in cache: $e");
          }

          try {
            final attendanceResult = await repository.attendance();
            print("ATTENDANCE API RESPONSE: ${attendanceResult.statusCode} -> ${attendanceResult.result}");

            if (attendanceResult.isSuccess) {
              final dynamic rawAttendance = attendanceResult.result;
              dynamic attendanceData;
              if (rawAttendance is String) {
                attendanceData = jsonDecode(rawAttendance);
              } else {
                attendanceData = rawAttendance;
              }

              final todayStr = DateTime.now().toString().split(' ').first; // e.g. "2026-06-24"

              if (attendanceData is List) {
                for (var item in attendanceData) {
                  if (item is Map) {
                    final String? date = item['date'] ?? item['created_at']?.toString().split('T').first;
                    if (date == todayStr) {
                      isCheckedInToday = true;
                      break;
                    }
                  }
                }
              } else if (attendanceData is Map && attendanceData['results'] is List) {
                for (var item in attendanceData['results']) {
                  if (item is Map) {
                    final String? date = item['date'] ?? item['created_at']?.toString().split('T').first;
                    if (date == todayStr) {
                      isCheckedInToday = true;
                      break;
                    }
                  }
                }
              }
            }
          } catch (e) {
            print("Error parsing attendance: $e");
          }

          emit(HomeSuccessState(profile: profile, isCheckedInToday: isCheckedInToday));
        } else {
          emit(HomeErrorState(message: 'Xatolik: ${result.statusCode}'));
        }
      } catch (e) {
        emit(HomeErrorState(message: e.toString()));
      }
    });
  }
}
