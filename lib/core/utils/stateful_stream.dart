import 'dart:async';

class StatefulStreamController<T> {
  StatefulStreamController({T? initialValue}) : _currentValue = initialValue;

  T? _currentValue;
  final _controller = StreamController<T>.broadcast();

  T? get currentValue => _currentValue;

  Stream<T> get stream => _controller.stream;

  void add(T event, {bool notify = true}) {
    if (notify) {
      _controller.add(event);
    }
    _currentValue = event;
  }

  Future<void> close() => _controller.close();
}
