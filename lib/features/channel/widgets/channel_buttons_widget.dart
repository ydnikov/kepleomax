part of '../channel_screen.dart';

class _ChannelButtonsWidget extends StatelessWidget {
  const _ChannelButtonsWidget({
    required this.channelData,
    required this.isLoading,
    required this.isConnected,
  });

  final ChannelData channelData;
  final bool isLoading;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    final role = channelData.userRole;

    return Row(
      children: [
        if (role.isOwner && !isLoading) ...[
          Expanded(
            child: KlmTextButton(
              onPressed: isConnected ? () {
                AppNavigator.push(
                  context,
                  ChannelEditorPage(channelData: channelData),
                );
              } : null,
              text: 'Edit',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: KlmTextButton(
              onPressed: isConnected ? () {
                AppNavigator.showGeneralDialog(
                  context,
                  (_) => _DeleteChannelDialog(
                    onDelete: () {
                      context.read<ChannelBloc>().add(const ChannelEventDelete());
                    },
                  ),
                  barrierDismissible: true,
                );
              } : null,
              text: 'Delete',
              backgroundColor: Colors.red,
            ),
          ),
        ] else if (role.isSubscriber)
          Expanded(
            child: KlmTextButton(
              onPressed: isConnected ? () {
                context.read<ChannelBloc>().add(const ChannelEventUnsubscribe());
              } : null,
              isLoading: isLoading,
              text: 'Leave',
              backgroundColor: Colors.red,
            ),
          )
        else
          Expanded(
            child: KlmTextButton(
              onPressed: isConnected ? () {
                context.read<ChannelBloc>().add(const ChannelEventSubscribe());
              } : null,
              isLoading: isLoading,
              text: 'Subscribe',
              backgroundColor: Colors.blue,
            ),
          ),
      ],
    );
  }
}
