import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:kepleomax/core/navigation/pages.dart';

typedef AppPages = List<AppPage>;

const mainNavigatorKey = 'MainNavigator';

class AppNavigator extends StatefulWidget {
  const AppNavigator({
    required this.initialState,
    required this.navigatorKey,
    super.key,
  });

  final AppPages initialState;
  final String navigatorKey;

  static AppNavigatorState? of(BuildContext context) =>
      context.findAncestorStateOfType<AppNavigatorState>();

  static AppNavigatorState? withKeyOf(BuildContext context, String key) {
    AppNavigatorState? state = context.findAncestorStateOfType<AppNavigatorState>();

    while (true) {
      if (state == null) return null;
      if (state.navigatorKey == key) return state;

      state = state.context.findAncestorStateOfType<AppNavigatorState>();
    }
  }

  static void change(BuildContext context, AppPages Function(AppPages pages) fn) =>
      of(context)?.change(fn);

  static void push(BuildContext context, AppPage page) => of(context)?.push(page);

  static void pop(BuildContext context) => of(context)?.pop();

  static void popIfType<T extends AppPage>(BuildContext context) =>
      of(context)?.popIfType<T>();

  static void popAll(BuildContext context) => of(context)?.popAll();

  static Future<void>? showGeneralDialog(BuildContext context, Widget dialog) =>
      of(context)?.showGeneralDialog(context, dialog);

  static Future<void>? showModalBottomSheet(
    BuildContext context,
    Widget bottomSheet,
  ) => of(context)?.showModalBottomSheet(context, bottomSheet);

  @override
  State<AppNavigator> createState() => AppNavigatorState();
}

class AppNavigatorState extends State<AppNavigator> with WidgetsBindingObserver {
  AppPages get state => _state;
  late AppPages _state;
  static bool _isDialogOpened = false;

  @override
  void initState() {
    _state = widget.initialState;
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void change(AppPages Function(AppPages pages) fn) {
    if (!mounted) return;

    final next = fn(_state.toList());

    if (next.isEmpty || listEquals(_state, next)) return;
    _state = next;

    setState(() {});
  }

  void push(AppPage page) {
    if (_state.map((pg) => pg.name).contains(page.name)) {
      /// this page already exists, but if with other key, then need to replace
      final index = _state.indexWhere((pg) => pg.name == page.name);
      if (_state[index].key == page.key) {
        /// not recreating page
        change((state) => _state.sublist(0, index + 1));
      } else {
        change((state) => [..._state.sublist(0, index), page]);
      }
    } else {
      change((state) => [...state, page]);
    }
  }

  void pop() => change((state) {
    if (state.length > 1) state.removeLast();
    return state;
  });

  void popIfType<T extends AppPage>() {
    if (state.last is T) {
      pop();
    }
  }

  bool lastIs<T extends AppPage>() => state.last is T;

  void popAll() => change((state) {
    return [state[0]];
  });

  String get navigatorKey => widget.navigatorKey;

  @override
  Future<bool> didPopRoute() async {
    if (_isDialogOpened) return false;
    if (_state.length <= 1) return false;
    _onDidRemovePage(_state.last);
    return true;
  }

  Future<void> showGeneralDialog(BuildContext context, Widget dialog) async {
    _isDialogOpened = true;
    await material.showGeneralDialog(
      context: context,
      useRootNavigator: true,
      pageBuilder: (context, _, _) => _PopScope(child: dialog),
    );
    _isDialogOpened = false;
  }

  Future<void> showModalBottomSheet(BuildContext context, Widget bottomSheet) async {
    _isDialogOpened = true;
    await material.showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PopScope(child: bottomSheet),
      isDismissible: false,
      //enableDrag: false,
    );
    _isDialogOpened = false;
  }

  void _onDidRemovePage(Page<Object?> page) {
    change(
      (pages) => pages
        ..toList()
        ..removeWhere((e) => e.key == page.key),
    );
  }

  @override
  Widget build(BuildContext context) => Navigator(
    key: Key(navigatorKey),
    pages: _state,
    onDidRemovePage: _onDidRemovePage,
  );
}

class _PopScope extends StatefulWidget {
  const _PopScope({required this.child});

  final Widget child;

  @override
  State<_PopScope> createState() => _PopScopeState();
}

class _PopScopeState extends State<_PopScope> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
