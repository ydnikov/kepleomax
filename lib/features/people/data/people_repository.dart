import 'dart:async';

import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/data/data_sources/users_api_data_source.dart';
import 'package:kepleomax/core/data/local_data_sources/users_local_data_source.dart';
import 'package:kepleomax/core/data/models/users_collection.dart';
import 'package:kepleomax/core/models/user.dart';

abstract class PeopleRepository {
  Stream<UsersCollection> get usersStream;

  Future<void> loadSearch({required String search});

  Future<void> loadMore();
}

class PeopleRepositoryImpl implements PeopleRepository {
  PeopleRepositoryImpl({
    required UsersApiDataSource userApiDataSource,
    required UsersLocalDataSource usersLocalDataSource,
  }) : _usersLocalSource = usersLocalDataSource,
       _usersApiSource = userApiDataSource;

  final UsersApiDataSource _usersApiSource;
  final UsersLocalDataSource _usersLocalSource;

  final _usersController = StreamController<UsersCollection>.broadcast();
  UsersCollection _lastUsersCollection = const UsersCollection(users: []);
  String _cachedSearch = '';

  void _emitUsersCollection(UsersCollection collection) {
    _lastUsersCollection = collection;
    _usersController.add(collection);
  }

  @override
  Future<void> loadSearch({required String search}) async {
    _cachedSearch = search;

    final newUserDtos = await _usersApiSource.searchUsers(
      search: search,
      limit: AppConstants.peoplePagingLimit,
      cursor: null,
    );

    unawaited(_usersLocalSource.insertAll(newUserDtos));
    _emitUsersCollection(
      UsersCollection(
        users: newUserDtos.map(User.fromDto),
        allUsersLoaded: newUserDtos.length < AppConstants.peoplePagingLimit,
      ),
    );
  }

  @override
  Future<void> loadMore() async {
    final newUserDtos = await _usersApiSource.searchUsers(
      search: _cachedSearch,
      limit: AppConstants.peoplePagingLimit,
      cursor: _lastUsersCollection.users.last.id,
    );

    unawaited(_usersLocalSource.insertAll(newUserDtos));
    _emitUsersCollection(
      UsersCollection(
        users: [..._lastUsersCollection.users, ...newUserDtos.map(User.fromDto)],
        allUsersLoaded: newUserDtos.length < AppConstants.peoplePagingLimit,
      ),
    );
  }

  @override
  Stream<UsersCollection> get usersStream => _usersController.stream;
}
