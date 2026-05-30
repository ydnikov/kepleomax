part of '../channel_screen.dart';

class _ChannelButtonsWidget extends StatelessWidget {
  const _ChannelButtonsWidget({required this.channelData, required this.isLoading});

  final ChannelData channelData;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final role = channelData.userRole;

    return Row(
      children: [
        if (role.isOwner && !isLoading) ...[
          Expanded(
            child: KlmTextButton(
              onPressed: () {
                AppNavigator.push(
                  context,
                  ChannelEditorPage(channelData: channelData),
                );
              },
              text: 'Edit',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: KlmTextButton(
              onPressed: () {
                AppNavigator.showGeneralDialog(
                  context,
                  const DeleteChannelDialog(),
                  barrierDismissible: true,
                );
              },
              text: 'Delete',
              backgroundColor: Colors.red,
            ),
          ),
        ] else if (role.isSubscriber)
          Expanded(
            child: KlmTextButton(
              onPressed: () {
                context.read<ChannelBloc>().add(const ChannelEventUnsubscribe());
              },
              isLoading: isLoading,
              text: 'Leave',
              backgroundColor: Colors.red,
            ),
          )
        else
          Expanded(
            child: KlmTextButton(
              onPressed: () {
                context.read<ChannelBloc>().add(const ChannelEventSubscribe());
              },
              isLoading: isLoading,
              text: 'Subscribe',
              backgroundColor: Colors.blue,
            ),
          ),
      ],
    );
  }
}
