import 'package:flutter/material.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/models/chat.dart';

class EmptyChatWidget extends StatelessWidget {
  const EmptyChatWidget({required this.channelRole, super.key});

  final UserChannelRole? channelRole;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _TechMessage(
        key: const Key('no_messages_widget'),
        text: channelRole == null
            ? 'No messages here yet...\n\nWrite something'
            : channelRole!.isOwner
            ? 'This is your channel\n\nWrite something'
            : channelRole!.isSubscriber
            ? 'You are subscribed\n\nNo messages yet'
            : 'This is a channel\n\nNo messages yet',
      ),
    );
  }
}

class _TechMessage extends StatelessWidget {
  const _TechMessage({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(80),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      margin: const EdgeInsets.only(bottom: 6, top: 6),
      child: Text(
        '\n$text\n',
        textAlign: TextAlign.center,
        style: context.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
