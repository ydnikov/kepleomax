import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/network/websockets/models/rtc_models.dart';
import 'package:kepleomax/core/network/websockets/rtc_web_socket.dart';
import 'package:kepleomax/core/presentation/ellipsis_text_widget.dart';
import 'package:kepleomax/core/presentation/user_image.dart';
import 'package:kepleomax/core/services/calls_notifications_service.dart';
import 'package:kepleomax/core/services/calls_service.dart';
import 'package:kepleomax/features/call/bloc/call_bloc.dart';
import 'package:kepleomax/features/call/bloc/call_state.dart';
import 'package:kepleomax/features/call/widgets/call_stopwatch_widget.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({required this.otherUser, required this.doCall, super.key});

  final User otherUser;
  final bool doCall;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late final CallBloc _callBloc;

  @override
  void initState() {
    final dp = Dependencies.of(context);
    _callBloc = CallBloc(
      rtcWebSocket: dp.read<RtcWebSocket>(),
      callsRepository: dp.callsRepositoryBuilder(),
    )..add(CallEventInit(otherUser: widget.otherUser, doCall: widget.doCall));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _callBloc,
      child: BlocConsumer<CallBloc, CallState>(
        listener: (context, state) {
          if (state is CallStateMessage) {
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_LONG,
            );
          }
          if (state is CallStateExit && context.mounted) {
            AppNavigator.of(context)!.pop();
          }
        },
        buildWhen: (oldState, newState) {
          if (newState is! CallStateBase) return false;

          if (oldState is! CallStateBase) return true;

          final oldData = oldState.data;
          final newData = newState.data;
          return oldData.remoteCameraAvailable != newData.remoteCameraAvailable ||
              oldData.localCameraAvailable != newData.localCameraAvailable;
        },
        builder: (context, state) {
          return AnnotatedRegion(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            child: Scaffold(
              backgroundColor:
                  state is CallStateBase &&
                      (state.data.remoteCameraAvailable ||
                          state.data.localCameraAvailable)
                  ? const Color(0xFF121212)
                  : Colors.blue,
              //appBar: _AppBar(),
              body: _Body(doCall: widget.doCall),
            ),
          );
        },
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.doCall});

  final bool doCall;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool _camerasSwitched = false;
  bool _cameraWasClosedOnForegroundLost = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CallBloc, CallState>(
        buildWhen: (oldState, newState) {
          if (newState is! CallStateBase) return false;

          if (oldState is! CallStateBase) return true;

          final localAvailable = newState.data.localCameraAvailable;
          final oldRemoteAvailable = oldState.data.remoteCameraAvailable;
          final newRemoteAvailable = newState.data.remoteCameraAvailable;
          if (!oldRemoteAvailable && newRemoteAvailable) {
            _camerasSwitched = false;
          } else if (localAvailable && !newRemoteAvailable && !_camerasSwitched) {
            _camerasSwitched = true;
          } else if (!localAvailable && newRemoteAvailable && _camerasSwitched) {
            _camerasSwitched = false;
          }

          return oldState.data != newState.data;
        },
        builder: (context, state) {
          if (state is! CallStateBase) return const SizedBox();
          final data = state.data;

          final RTCVideoView? remoteView = data.remoteCameraAvailable
              ? RTCVideoView(
                  data.remoteRenderer!,
                  mirror: data.remoteCameraStatus.isFront,
                )
              : null;

          final RTCVideoView? localView = data.localCameraAvailable
              ? RTCVideoView(
                  data.localRenderer!,
                  mirror: data.localCameraStatus.isFront,
                )
              : null;

          return FocusDetector(
            onForegroundGained: () {
              if (_cameraWasClosedOnForegroundLost) {
                _cameraWasClosedOnForegroundLost = false;
                context.read<CallBloc>().add(const CallEventToggleCamera());
              }
            },
            onForegroundLost: () {
              if (data.localCameraAvailable) {
                _cameraWasClosedOnForegroundLost = true;
                Fluttertoast.showToast(msg: 'Camera stopped');
                context.read<CallBloc>().add(const CallEventToggleCamera());
              }
            },
            child: Stack(
              children: [
                if ((!_camerasSwitched && data.remoteCameraAvailable) ||
                    (_camerasSwitched && data.localCameraAvailable))
                  _camerasSwitched ? localView! : remoteView!,
                if ((!_camerasSwitched && data.localCameraAvailable) ||
                    (_camerasSwitched && data.remoteCameraAvailable))
                  Positioned(
                    right: 10,
                    bottom: 92,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _camerasSwitched = !_camerasSwitched;
                        });
                      },
                      child: Material(
                        elevation: 6,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 160 * 1.3,
                            width: 90 * 1.3,
                            child: _camerasSwitched ? remoteView : localView,
                          ),
                        ),
                      ),
                    ),
                  ),

                Column(
                  children: [
                    const SizedBox(height: 6),
                    if (data.localCameraAvailable || data.remoteCameraAvailable)
                      if (data.connectionStatus ==
                          RTCPeerConnectionState.RTCPeerConnectionStateConnected)
                        CallStopwatchWidget(
                          callStartedTime: data.callStartedTime!,
                          color: Colors.white70,
                          fontSize: 14,
                        )
                      else
                        EllipsisTextWidget(
                          data.connectionStatus.userString,
                          ellipsis: data.connectionStatus.showEllipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                    if (!data.remoteCameraAvailable &&
                        !data.localCameraAvailable) ...[
                      const SizedBox(height: 80),
                      UserImage(user: data.otherUser, size: 200),
                      const SizedBox(height: 10),
                      Text(
                        data.otherUser.username,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (data.callStartedTime != null) ...[
                        const SizedBox(height: 8),
                        CallStopwatchWidget(callStartedTime: data.callStartedTime!),
                      ],
                    ],
                    const Expanded(child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (data.isCallAccepted) ...[
                            _Button(
                              data.localCameraStatus.isOn
                                  ? 'Stop video'
                                  : 'Start video',
                              icon: data.localCameraStatus.isOn
                                  ? Icons.videocam
                                  : Icons.videocam_off_outlined,
                              iconColor: Colors.blue,
                              color: Colors.white,
                              onPressed: () {
                                context.read<CallBloc>().add(
                                  const CallEventToggleCamera(),
                                );
                              },
                            ),
                            if (data.localCameraStatus.isOn)
                              _Button(
                                'Flip',
                                icon: Icons.cameraswitch,
                                iconColor: Colors.blue,
                                color: Colors.white,
                                onPressed: () {
                                  context.read<CallBloc>().add(
                                    const CallEventFlipCamera(),
                                  );
                                },
                              ),
                            _Button(
                              data.isLocalMicrophoneOn ? 'Mute' : 'Unmute',
                              icon: data.isLocalMicrophoneOn
                                  ? Icons.mic
                                  : Icons.mic_off,
                              iconColor: Colors.blue,
                              color: Colors.white,
                              onPressed: () {
                                context.read<CallBloc>().add(
                                  const CallEventToggleMicrophone(),
                                );
                              },
                            ),
                          ],

                          _Button(
                            data.isCallAccepted
                                ? 'End Call'
                                : widget.doCall
                                ? 'Cancel'
                                : 'Decline',
                            icon: Icons.call_end,
                            iconColor: Colors.white,
                            color: Colors.red,
                            onPressed: () {
                              /// will be handled in bloc.close()
                              AppNavigator.pop(context);
                            },
                          ),
                          if (!data.isCallAccepted && !widget.doCall)
                            _Button(
                              'Accept',
                              icon: Icons.call,
                              iconColor: Colors.white,
                              color: Colors.green,
                              onPressed: () async {
                                // TODO maybe through bloc?
                                await CallsNotificationsService.instance
                                    .hideIncomingNotification(data.callId!);
                                await CallsService.instance.callAcceptEvent(
                                  OfferUpdate(
                                    callId: data.callId!,
                                    otherUserId: data.otherUser.id,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button(
    this.title, {
    required this.icon,
    required this.iconColor,
    required this.color,
    required this.onPressed,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 4,
          shadowColor: Colors.black,
          borderRadius: BorderRadius.circular(100),
          child: IconButton(
            onPressed: onPressed,
            style: IconButton.styleFrom(
              disabledBackgroundColor: Colors.grey.shade300,
              backgroundColor: color,
              minimumSize: const Size(60, 60),
            ),
            icon: Icon(icon, color: iconColor, size: 34),
          ),
        ),
        // const SizedBox(height: 10),
        // Text(
        //   title,
        //   style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        // ),
      ],
    );
  }
}

extension RTCConnectionStateToString on RTCPeerConnectionState {
  String get userString {
    switch (this) {
      case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
        return 'Connecting';
      case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
        return 'Connected';
      case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
        return 'Disconnected';
      case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
        return 'Failed';
      case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
        return 'Closed';
      case RTCPeerConnectionState.RTCPeerConnectionStateNew:
        return 'Waiting';
    }
  }

  bool get showEllipsis =>
      this == RTCPeerConnectionState.RTCPeerConnectionStateNew ||
      this == RTCPeerConnectionState.RTCPeerConnectionStateConnecting;
}
