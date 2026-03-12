import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/navigation/pages.dart';
import 'package:kepleomax/core/presentation/app_bar_loading_action.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/presentation/klm_app_bar.dart';
import 'package:kepleomax/core/presentation/klm_textfield.dart';
import 'package:kepleomax/core/presentation/user_image.dart';
import 'package:kepleomax/features/chats/chats_screen_navigator.dart';
import 'package:kepleomax/features/people/bloc/people_bloc.dart';
import 'package:kepleomax/features/people/bloc/people_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'widgets/user_card.dart';

/// screen
class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PeopleBloc>(
      create: (context) => PeopleBloc(
        peopleRepository: Dependencies.of(context).peopleRepositoryBuilder(),
      )..add(const PeopleEventInstantLoad()),
      child: const Scaffold(
        appBar: _AppBar(key: Key('people_app_bar')),
        body: _Body(key: Key('people_body')),
      ),
    );
  }
}

/// body
class _Body extends StatefulWidget {
  const _Body({super.key});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  /// callbacks
  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return _PagingListener(
      key: const Key('people_paging_listener'),
      scrollController: _scrollController,
      child: BlocConsumer<PeopleBloc, PeopleState>(
        buildWhen: (oldState, newState) {
          if (newState is! PeopleStateBase) return false;

          if (oldState is! PeopleStateBase) return true;

          return oldState.data != newState.data;
        },
        listener: (context, state) {
          if (state is PeopleStateError) {
            context.showSnackBar(text: state.message, color: KlmColors.errorRed);
          }
        },
        builder: (context, state) {
          if (state is! PeopleStateBase) return const SizedBox();

          final data = state.data;
          final showSkeletonLoading = !data.isAllUsersLoaded && !data.isLoading;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: KlmTextField(
                  controller: _controller,
                  onChanged: (search) {
                    context.read<PeopleBloc>().add(
                      PeopleEventEditSearch(text: search),
                    );
                  },
                  hint: 'Search',
                ),
              ),
              if (!data.isLoading && data.users.isEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'No one found',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              Expanded(
                child: ListView.builder(
                  key: const Key('users_scroll_view'),
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: data.users.length + (showSkeletonLoading ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (showSkeletonLoading && i == data.users.length) {
                      return _UserCard(user: User.loading(), isLoading: true);
                    }
                    return _UserCard(
                      key: Key('user_card_${data.users[i].id}'),
                      user: data.users[i],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// widgets
class _PagingListener extends StatefulWidget {
  const _PagingListener({
    required this.scrollController,
    required this.child,
    super.key,
  });

  final Widget child;
  final ScrollController scrollController;

  @override
  State<_PagingListener> createState() => _PagingListenerState();
}

class _PagingListenerState extends State<_PagingListener> {
  /// callbacks
  @override
  void initState() {
    widget.scrollController.addListener(_onScrollListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScrollListener);
    super.dispose();
  }

  /// listeners
  void _onScrollListener() {
    if (widget.scrollController.offset >
        widget.scrollController.position.maxScrollExtent - 30) {
      context.read<PeopleBloc>().add(const PeopleEventLoadMore());
    }
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PeopleBloc, PeopleState>(
      buildWhen: (oldState, newState) {
        if (newState is! PeopleStateBase) return false;

        if (oldState is! PeopleStateBase) return true;

        return oldState.data.isLoading != newState.data.isLoading;
      },
      builder: (context, state) {
        return AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          actions: state is PeopleStateBase && state.data.isLoading
              ? const [AppBarLoadingAction()]
              : null,
          title: Text(
            'People',
            style: context.textTheme.bodyLarge?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: const KlmBackButton(),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
