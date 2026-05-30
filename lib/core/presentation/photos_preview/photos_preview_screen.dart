import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gal/gal.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/presentation/klm_app_bar.dart';
import 'package:kepleomax/core/presentation/klm_cached_image.dart';
import 'package:num_remap/num_remap.dart';
import 'package:path_provider/path_provider.dart';

part 'photo.dart';
part 'swipe_view.dart';

typedef _GetAlpha = int Function({int minAlpha, int maxAlpha});

/// constants
const int _minAlpha = 150;
const int _distanceToReachMinAlpha = 100;
const int _distanceToClose = 150;
const double _maxScaleFactor = 4;
const double _swipeViewHeight = 2600;

/// must be < 0.5
const double _spaceBetweenPhotosRatio = 0.1;

const double _scaleFactorOnDoubleTapWhenOnlyYAxes = 1.5;

/// change carefully (cause * 1.668)
const double _scaleFactorOnDoubleTap = 2.5;

/// body
class PhotosPreviewScreen extends StatefulWidget {
  const PhotosPreviewScreen({
    required this.urls,
    this.initialIndex = 0,
    this.isOnePictureMode = false,
    super.key,
  });

  final List<String> urls;
  final int initialIndex;
  final bool isOnePictureMode;

  @override
  State<PhotosPreviewScreen> createState() => _PhotosPreviewScreenState();
}

class _PhotosPreviewScreenState extends State<PhotosPreviewScreen> {
  late int _index;
  bool _showAppBar = true;

  double? _defaultOffset;

  /// swipe up/down controller
  final ScrollController _scrollController = ScrollController();

  /// zoom controllers
  final _transformControllers = <TransformationController>[];

  late final _pageController = PageController(
    viewportFraction: 1,
    initialPage: _index,
  );

  /// callbacks
  @override
  void initState() {
    _index = widget.initialIndex;
    for (int i = 0; i < widget.urls.length; i++) {
      final controller = TransformationController();
      controller.addListener(_setState);
      _transformControllers.add(controller);
    }

    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      _defaultOffset = (_swipeViewHeight - context.screenSize.height) / 2;

      /// need setState to apply _defaultOffset to widgets (send them, that it's
      /// not null now)
      setState(() {});
      _scrollController.jumpTo(_defaultOffset!);
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    _scrollController.dispose();
    _pageController.dispose();
    for (final controller in _transformControllers) {
      controller.removeListener(_setState);
      controller.dispose();
    }
    super.dispose();
  }

  /// listeners/getters
  void _setState() => setState(() {});

  bool get _isInZoom => _transformControllers
      .where((controller) => controller.value.getMaxScaleOnAxis() >= 1.05)
      .isNotEmpty;

  /// build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: _showAppBar
          ? _AppBar(
              title: widget.isOnePictureMode
                  ? ''
                  : '${_index + 1}/${widget.urls.length}',
              getAlpha: _getAlpha,
              defaultOffset: _defaultOffset,
              scrollController: _scrollController,
              onSave: _saveToGallery,
            )
          : null,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showAppBar = !_showAppBar;
            if (_showAppBar) {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            } else {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
            }
          });
        },

        /// need here so zoom by double tap can work
        onDoubleTap: () {},
        child: _SwipeView(
          scrollController: _scrollController,
          onExit: () {
            Navigator.pop(context);
          },
          canScroll: () => !_isInZoom,
          child: SizedBox(
            height: _swipeViewHeight,
            child: PageView(
              physics: _isInZoom || widget.isOnePictureMode
                  ? const NeverScrollableScrollPhysics()
                  : null,
              controller: _pageController,
              onPageChanged: (newIndex) {
                setState(() {
                  _index = newIndex;
                });
              },
              children: widget.urls
                  .mapIndexed(
                    (i, url) => Stack(
                      children: [
                        _Background(
                          key: const Key('photos_background'),
                          scrollController: _scrollController,
                          getAlpha: _getAlpha,
                          defaultOffset: _defaultOffset,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: context.screenSize.height,
                              ),
                              child: _Photo(
                                key: Key('photo_${i}_$url'),
                                url: url,
                                transformationController: _transformControllers[i],
                              ),
                            ),
                          ],
                        ),
                        _SpaceIllusion(
                          key: const Key('photos_space_illusion'),
                          pageController: _pageController,
                          maxLinesWidth:
                              context.screenSize.width * _spaceBetweenPhotosRatio,
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  /// other methods
  Future<void> _saveToGallery() async {
    try {
      String savedTo = 'gallery';
      Directory? directory;
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        Directory? directory = Directory('/storage/emulated/0/Download');

        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
          savedTo = 'external storage';
        }
      }
      if (directory == null) throw Exception("Can't save image");
      final path = '${directory.path}/${widget.urls[_index]}';

      await Dio().download(flavor.imageUrl + widget.urls[_index], path);
      await Gal.putImage(path);
      if (mounted) {
        Fluttertoast.showToast(msg: 'Image saved to $savedTo');
      }
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      if (mounted) {
        Fluttertoast.showToast(msg: 'Failed to save image');
      }
    }
  }

  int _getAlpha({int minAlpha = _minAlpha, int maxAlpha = 255}) {
    if (!_scrollController.hasClients || _defaultOffset == null) return 0;
    final offset = _scrollController.offset;

    if (offset > _defaultOffset! + _distanceToReachMinAlpha ||
        offset < _defaultOffset! - _distanceToReachMinAlpha) {
      return minAlpha;
    }
    return _scrollController.offset
        .remap(
          _defaultOffset!,
          _defaultOffset! +
              (_distanceToReachMinAlpha * (offset > _defaultOffset! ? 1 : -1)),
          maxAlpha,
          minAlpha,
        )
        .toInt();
  }
}

/// widgets
class _Background extends StatefulWidget {
  const _Background({
    required this.scrollController,
    required this.getAlpha,
    required this.defaultOffset,
    super.key,
  });

  final ScrollController scrollController;
  final _GetAlpha getAlpha;
  final double? defaultOffset;

  @override
  State<_Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<_Background> {
  double? _lastOffset;

  /// callbacks
  @override
  void initState() {
    widget.scrollController.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_listener);
    super.dispose();
  }

  /// listeners
  void _listener() {
    if (!widget.scrollController.hasClients) return;
    final offset = widget.scrollController.offset;

    if (widget.defaultOffset == null) return;
    _lastOffset ??= widget.defaultOffset;

    if (!(_lastOffset! > widget.defaultOffset! + _distanceToReachMinAlpha ||
        _lastOffset! < widget.defaultOffset! - _distanceToReachMinAlpha)) {
      setState(() {});
    }
    _lastOffset = offset;
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.black.withAlpha(widget.getAlpha()));
  }
}

class _SpaceIllusion extends StatefulWidget {
  const _SpaceIllusion({
    required this.pageController,
    required this.maxLinesWidth,
    super.key,
  });

  final PageController pageController;
  final double maxLinesWidth;

  @override
  State<_SpaceIllusion> createState() => _SpaceIllusionState();
}

class _SpaceIllusionState extends State<_SpaceIllusion> {
  /// callbacks
  @override
  void initState() {
    widget.pageController.addListener(_setState);
    super.initState();
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_setState);
    super.dispose();
  }

  /// listeners
  void _setState() => setState(() {});

  /// build
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: _getLeftLineWidth(),
          color: Colors.black,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            height: context.screenSize.height,
            width: _getRightLineWidth(),
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  //double get _maxLinesWidth => context.screenSize.width * 0.1;

  double get _viewPagePos =>
      widget.pageController.hasClients ? (widget.pageController.page ?? 0) % 1 : 0;

  /// move -> there
  /// 0 | _ratio | _ratio - 1 | 1
  /// right: fullyHidden | growing | decreases | fullyHidden
  /// left: growing | decreases | fullyHidden | fullyHidden

  double _getRightLineWidth() {
    final pos = _viewPagePos;
    const maxWidthOn = 1 - _spaceBetweenPhotosRatio;
    if (pos < _spaceBetweenPhotosRatio) {
      /// fullyHidden
      return 0;
    } else if (pos < maxWidthOn) {
      /// growing
      return pos.remap(
        _spaceBetweenPhotosRatio,
        maxWidthOn,
        0,
        widget.maxLinesWidth,
      );
    } else {
      /// decreasing
      return pos.remap(maxWidthOn, 1, widget.maxLinesWidth, 0);
    }
  }

  double _getLeftLineWidth() {
    final pos = _viewPagePos;
    const fullyHidden = 1 - _spaceBetweenPhotosRatio;
    if (pos < _spaceBetweenPhotosRatio) {
      /// growing
      return pos.remap(0, _spaceBetweenPhotosRatio, 0, widget.maxLinesWidth);
    } else if (pos < fullyHidden) {
      /// decreases
      return pos.remap(
        _spaceBetweenPhotosRatio,
        fullyHidden,
        widget.maxLinesWidth,
        0,
      );
    } else {
      /// fullyHidden
      return 0;
    }
  }
}

class _AppBar extends StatefulWidget implements PreferredSizeWidget {
  const _AppBar({
    required this.title,
    required this.getAlpha,
    required this.onSave,
    required this.defaultOffset,
    required this.scrollController,
  });

  final String title;
  final _GetAlpha getAlpha;
  final VoidCallback onSave;
  final double? defaultOffset;
  final ScrollController scrollController;

  @override
  State<_AppBar> createState() => _AppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarState extends State<_AppBar> {
  double? _lastOffset;

  /// callbacks
  @override
  void initState() {
    widget.scrollController.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_listener);
    super.dispose();
  }

  /// listeners
  void _listener() {
    if (!widget.scrollController.hasClients) return;
    final offset = widget.scrollController.offset;

    if (widget.defaultOffset == null) return;
    _lastOffset ??= widget.defaultOffset;

    if (!(_lastOffset! > widget.defaultOffset! + _distanceToReachMinAlpha ||
        _lastOffset! < widget.defaultOffset! - _distanceToReachMinAlpha)) {
      setState(() {});
    }
    _lastOffset = offset;
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black.withAlpha(
        widget.getAlpha(minAlpha: 0, maxAlpha: 130),
      ),
      foregroundColor: Colors.white.withAlpha(widget.getAlpha(minAlpha: 0)),
      surfaceTintColor: Colors.transparent,
      title: Text(widget.title),
      automaticallyImplyLeading: false,
      leading: KlmBackButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'save') {
              widget.onSave();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<String>(
              value: 'save',
              child: Text('Save to gallery'),
            ),
          ],
        ),
      ],
    );
  }
}
