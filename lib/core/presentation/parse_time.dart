import 'package:intl/intl.dart';

class ParseTime {
  ParseTime._();

  static bool _isSingular(int count) {
    return count % 10 == 1 && count != 11;
  }

  static String toPassTime(DateTime dateTime) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final unixTime = dateTime.millisecondsSinceEpoch ~/ 1000;

    if (now - unixTime < 60) {
      return '${now - unixTime} sec ago';
    } else if (now - unixTime < 3600) {
      return '${(now - unixTime) ~/ 60} min ago';
    } else if (now - unixTime < 86400) {
      final count = (now - unixTime) ~/ 3600;
      return '$count ${_isSingular(count) ? 'hour' : 'hours'} ago';
    } else if (now - unixTime < 86400 * 7) {
      final count = (now - unixTime) ~/ 86400;
      return '$count ${_isSingular(count) ? 'day' : 'days'} ago';
    } else {
      return DateFormat(
        'MMM dd, y',
      ).format(DateTime.fromMillisecondsSinceEpoch(unixTime * 1000));
    }
  }

  static String toShortPassTime(DateTime dateTime) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final unixTime = dateTime.millisecondsSinceEpoch ~/ 1000;

    if (now - unixTime < 10) {
      return 'now';
    } else if (now - unixTime < 60) {
      return '${now - unixTime} s';
    } else if (now - unixTime < 3600) {
      return '${(now - unixTime) ~/ 60} m';
    } else if (now - unixTime < 86400) {
      return '${(now - unixTime) ~/ 3600} h';
    } else if (now - unixTime < 86400 * 7) {
      return '${(now - unixTime) ~/ 86400} d';
    } else if (now - unixTime < 86400 * 30) {
      return '${(now - unixTime) ~/ (86400 * 7)} w';
    } else if (DateTime.fromMillisecondsSinceEpoch(unixTime).year ==
        DateTime.now().year) {
      return DateFormat(
        'MMM dd',
      ).format(DateTime.fromMillisecondsSinceEpoch(unixTime * 1000));
    } else {
      return DateFormat(
        'MM/dd/yy',
      ).format(DateTime.fromMillisecondsSinceEpoch(unixTime * 1000));
    }
  }

  static String toPreciseDate(DateTime dateTime) {
    final date = DateFormat('MMM dd, y').format(dateTime);
    final time = DateFormat('hh:mm a').format(dateTime);

    return '$date at $time';
  }

  static String toTime(DateTime dateTime) => DateFormat.Hm().format(dateTime);

  static String toDuration(Duration duration) {
    if (duration.inMinutes == 0) {
      return '${duration.inSeconds} seconds';
    } else if (duration.inHours == 0) {
      return '${duration.inMinutes} minute${_isSingular(duration.inMinutes) ? '' : 's'}';
    } else {
      return '${duration.inHours} h ${duration.inMinutes} m';
    }
  }

  static String toStopwatch(Duration duration) {
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${minutes > 9 ? minutes : '0$minutes'}:${seconds > 9 ? seconds : '0$seconds'}';
    } else {
      return '${minutes > 9 ? minutes : '0$minutes'}:${seconds > 9 ? seconds : '0$seconds'}';
    }
  }

  static String toDate(DateTime dateTime) {
    final now = DateTime.now();
    if (dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year) {
      return 'Today';
    }

    final format = dateTime.year == now.year ? 'MMMM d' : 'MMM d, yyyy';

    return DateFormat(format).format(dateTime);
  }

  static String toOnlineStatus(DateTime lastActivityTime) {
    final lastActivityMillis = lastActivityTime.millisecondsSinceEpoch ~/ 1000;
    final now = DateTime.now();
    final nowMillis = now.millisecondsSinceEpoch ~/ 1000;

    if (lastActivityMillis + Duration.secondsPerDay > nowMillis) {
      return 'last seen at ${DateFormat.Hm().format(lastActivityTime)}';
    } else if (lastActivityTime.year == now.year) {
      return 'last seen ${DateFormat('dd MMM').format(lastActivityTime)} at ${DateFormat.Hm().format(lastActivityTime)}';
    } else if (lastActivityTime.year > 2010) {
      return 'last seen ${DateFormat('d/M/yy').format(lastActivityTime)}';
    } else {
      return 'last seen a long time ago';
    }
  }
}
