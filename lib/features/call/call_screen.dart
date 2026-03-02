import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/presentation/user_image.dart';
import 'package:kepleomax/features/call/bloc/call_bloc.dart';
import 'package:kepleomax/features/call/bloc/call_state.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({
    required this.otherUser,
    required this.doCall,
    this.offer,
    super.key,
  });

  final User otherUser;
  final bool doCall;
  final RTCSessionDescription? offer;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late final CallBloc _callBloc;

  @override
  void initState() {
    final dp = Dependencies.of(context);
    _callBloc =
        CallBloc(
          webRtcWebSocket: dp.rtcWebSocket,
          callsRepository: dp.callsRepository,
        )..add(
          CallEventInit(
            otherUser: widget.otherUser,
            doCall: widget.doCall,
            offer: widget.offer,
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _callBloc,
      child: Scaffold(
        backgroundColor: Colors.blue,
        //appBar: _AppBar(),
        body: _Body(doCall: widget.doCall),
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<CallBloc, CallState>(
        listener: (context, state) {
          if (state is CallStateExit) {
            AppNavigator.of(context)!.pop();
          }
        },
        buildWhen: (oldState, newState) {
          if (newState is! CallStateBase) return false;

          if (oldState is! CallStateBase) return true;

          return oldState.data != newState.data;
        },
        builder: (context, state) {
          if (state is! CallStateBase) return const SizedBox();
          final data = state.data;

          return Stack(
            children: [
              if (data.remoteRenderer != null) RTCVideoView(data.remoteRenderer!),
              if (data.localRenderer != null)
                Positioned(
                  right: 10,
                  bottom: 150,
                  child: SizedBox(
                    height: 160 * 1.3,
                    width: 90 * 1.3,
                    child: RTCVideoView(data.localRenderer!),
                  ),
                ),

              Column(
                children: [
                  if (data.remoteRenderer == null) ...[
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
                  ],
                  const Expanded(child: SizedBox()),
                  // Text(
                  //   'status: ${_mapStatus(data.status)}',
                  //   textAlign: TextAlign.center,
                  //   style: const TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  // Text(
                  //   'connection state: ${_mapConnectionState(data.connectionState)}',
                  //   textAlign: TextAlign.center,
                  //   style: const TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (data.isCallAccepted) ...[
                        _Button(
                          'Start video',
                          icon: Icons.videocam_off_outlined,
                          iconColor: Colors.blue,
                          color: Colors.white,
                          onPressed: () {},
                        ),
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
                          'Mute',
                          icon: Icons.mic,
                          iconColor: Colors.blue,
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ],

                      _Button(
                        data.isCallAccepted ? 'End Call' : 'Decline',
                        icon: Icons.call_end,
                        iconColor: Colors.white,
                        color: Colors.red,
                        onPressed: () {
                          AppNavigator.pop(context);
                        },
                      ),
                      if (!data.isCallAccepted && !widget.doCall)
                        _Button(
                          'Accept',
                          icon: Icons.call,
                          iconColor: Colors.white,
                          color: Colors.green,
                          onPressed: () {
                            context.read<CallBloc>().add(
                              const CallEventAcceptCall(),
                            );
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  String _mapConnectionState(RTCPeerConnectionState state) {
    switch (state) {
      case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
        return 'Closed';
      case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
        return 'Connecting';
      case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
        return 'Connected';
      case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
        return 'Disconnected';
      case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
        return 'Failed';
      case RTCPeerConnectionState.RTCPeerConnectionStateNew:
        return 'New';
    }
  }

  // String _mapStatus(CallStatus state) {
  //   switch (state) {
  //     case CallStatus.waitingForResponse:
  //       return 'Waiting for the response';
  //     case CallStatus.waitingForYourResponse:
  //       return '';
  //     case CallStatus.accepted:
  //       return 'Accepted';
  //     case CallStatus.disconnected:
  //       return 'Disconnected';
  //     case CallStatus.cancelledDueToTimeout:
  //       return 'Cancelled due to timeout';
  //
  //     /// TODO change to otherUser.username
  //     case CallStatus.otherUserEndedCall:
  //       return 'Other user ended call';
  //     case CallStatus.none:
  //       return '';
  //   }
  // }
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
        IconButton(
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: color,
            minimumSize: const Size(70, 70),
          ),
          icon: Icon(icon, color: iconColor, size: 34),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}