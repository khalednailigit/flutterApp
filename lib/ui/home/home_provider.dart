import 'package:flutter/material.dart';
import 'package:flutterapp/data/api_helper.dart';
import 'package:flutterapp/model/pageable_users.dart';

enum UserFetchingState { Loading, Success, Failed }

class UserData {
  PageableUsers pageableUsers;
  UserFetchingState state;
  bool isLastpage = false;
  Exception exception;

  UserData(
      {@required this.state,
      @required this.pageableUsers,
      @required this.exception});
}

class HomeProvider with ChangeNotifier {
  ApiHelper _apiHelper = ApiHelper();
  UserData userData = UserData(
      state: UserFetchingState.Loading, pageableUsers: null, exception: null);
  int _pageNumber = 1;

  void fetchUsers() async {
    try {
      final response = await _apiHelper.getUsersList(page: _pageNumber);
      final pageableUsers = PageableUsers.fromJson(response.data);
      userData = userData
        ..state = UserFetchingState.Success
        ..pageableUsers = pageableUsers
        ..isLastpage = pageableUsers.data.isEmpty;
      notifyListeners();
    } catch (e) {
      userData = userData
        ..state = UserFetchingState.Failed
        ..exception = e;
      notifyListeners();
    }
  }

  void paginate() async {
    _pageNumber += 1;
    try {
      if (!userData.isLastpage) {
        final response = await _apiHelper.getUsersList(page: _pageNumber);

        final pageableUsers = PageableUsers.fromJson(response.data);
        userData.pageableUsers.data.addAll(pageableUsers.data);
        userData = userData
          ..state = UserFetchingState.Success
          ..isLastpage = pageableUsers.data.isEmpty;
        notifyListeners();
      }
    } catch (e) {
      userData = userData
        ..state = UserFetchingState.Failed
        ..exception = e;
      notifyListeners();
    }
  }
}
