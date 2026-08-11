import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/data/user_repository.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/user_profile.dart';
import 'package:kepleomax/core/network/websockets/messenger_web_socket.dart';
import 'package:kepleomax/core/network/websockets/models/online_status_update.dart';
import 'package:kepleomax/core/presentation/user_error_message.dart';
import 'package:kepleomax/features/user/bloc/user_states.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required UserRepository userRepository,
    required MessengerWebSocket messengerWebSocket,
    required int userId,
  }) : _userRepository = userRepository,
       _messengerWebSocket = messengerWebSocket,
       _userId = userId,
       super(UserStateBase.initial()) {
    on<UserEvent>(
      (event, emit) => switch (event) {
        final UserEventLoad event => _onLoad(event, emit),
        final UserEventUpdateProfile event => _onUpdateProfile(event, emit),
        final _UserEventUpdateOnlineStatus event => _onUpdateOnlineStatus(
          event,
          emit,
        ),
        _ => () {},
      },
      transformer: sequential(),
    );
    _messengerWebSocket.subscribeOnOnlineStatusUpdatesIfNot([_userId]);
    _onlineUpdatesSub = _messengerWebSocket.onlineUpdatesStream.listen((update) {
      if (update.userId == userId) {
        add(_UserEventUpdateOnlineStatus(update));
      }
    });
  }

  final UserRepository _userRepository;
  final MessengerWebSocket _messengerWebSocket;

  final int _userId;
  late UserData _data = UserData.initial();
  late final StreamSubscription<void> _onlineUpdatesSub;

  Future<void> _onLoad(UserEventLoad event, Emitter<UserState> emit) async {
    _data = _data.copyWith(isLoading: true, profile: null);
    emit(UserStateBase(data: _data));

    UserProfile? profile;

    try {
      profile = await _userRepository.getUserProfile(_userId);
    } catch (e, st) {
      logger.e(e, stackTrace: st);

      emit(UserStateMessage(message: e.userErrorMessage, isError: true));
    } finally {
      _data = _data.copyWith(profile: profile, isLoading: false);
      emit(UserStateBase(data: _data));
    }
  }

  Future<void> _onUpdateProfile(
    UserEventUpdateProfile event,
    Emitter<UserState> emit,
  ) async {
    final oldProfile = _data.profile;
    final newProfile = event.newProfile;
    /// can't check using oldProfile == newProfile cause during editing
    /// user.lastActivityTime and user.isOnline can change
    if (oldProfile?.description == newProfile.description &&
        oldProfile?.user.username == newProfile.user.username &&
        oldProfile?.user.profileImage == newProfile.user.profileImage) {
      return;
    }

    _data = _data.copyWith(isLoading: true);
    emit(UserStateBase(data: _data));

    try {
      final newProfile = await _userRepository.updateProfile(
        event.newProfile,
        updateImage:
            _data.profile!.user.profileImage != event.newProfile.user.profileImage,
      );

      _data = _data.copyWith(profile: newProfile);
      emit(UserStateUpdateUser(user: newProfile.user));
      emit(const UserStateMessage(message: 'Changes saved'));
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      emit(UserStateMessage(message: e.userErrorMessage, isError: true));
    } finally {
      _data = _data.copyWith(isLoading: false);
      emit(UserStateBase(data: _data));
    }
  }

  void _onUpdateOnlineStatus(
    _UserEventUpdateOnlineStatus event,
    Emitter<UserState> emit,
  ) {
    _data = _data.copyWith(
      profile: _data.profile?.copyWith(
        user: _data.profile!.user.copyWith(
          isOnline: event.update.isOnline,
          lastActivityTime: event.update.lastActivityTime,
        ),
      ),
    );
    emit(UserStateBase(data: _data));
  }

  @override
  Future<void> close() {
    _onlineUpdatesSub.cancel();
    return super.close();
  }
}

/// Events
abstract class UserEvent {}

class UserEventLoad implements UserEvent {
  const UserEventLoad();
}

class UserEventUpdateProfile implements UserEvent {
  const UserEventUpdateProfile({required this.newProfile});

  final UserProfile newProfile;
}

class _UserEventUpdateOnlineStatus implements UserEvent {
  _UserEventUpdateOnlineStatus(this.update);

  final OnlineStatusUpdate update;
}
