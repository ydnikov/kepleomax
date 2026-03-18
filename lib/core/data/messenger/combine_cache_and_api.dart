import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/data/local_data_sources/messages_local_data_source.dart';
import 'package:kepleomax/core/models/message.dart';
import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';

/**
 * no conflict: (n)
 * cache: -----
 * api:   -----
 *
 * lastApiMessage id < lastCacheMessage id (out)
 * cache: -----
 * api:   --------
 *
 * lastApiMessage id > lastCacheMessage id (in)
 * cache: -----
 * api:   --
 *
 * don't get confused: ids are in the order: newer - bigger, older - lower
 *
 * gap_conflict:
 * cache: --  --
 * api:   ------
 *
 * EXAMPLES:
 * N_N
 * -----
 * -----
 * N_OUT
 * -----
 * -------
 * IN_IN
 * -----
 *  ---
 * OUT_N
 *  ----
 * -----
 */
class CombineCacheAndApi {
  const CombineCacheAndApi(this._messagesLocal);

  final MessagesLocalDataSource _messagesLocal;

  Iterable<MessageDto> combineLoad(
    List<MessageDto> cache,
    List<MessageDto> api, {
    int? limit,
  }) {
    return _of(cache, api).combine(cache, api, limit: limit);
  }

  Iterable<Message> combineLoadMore(
    List<Message> cache,
    List<MessageDto> api, {
    required int limit,
  }) {
    final cacheSubList = cache
        .where((m) => m.fromCache)
        .map((m) => m.toDto())
        .toList();

    final combined = _of(
      cacheSubList,
      api,
    ).combine(cacheSubList, api, limit: limit).map(Message.fromDto);
    return [...cache.where((m) => !m.fromCache), ...combined];
  }

  _Combiner _of(List<MessageDto> cache, List<MessageDto> api) {
    if (cache.isEmpty || api.isEmpty) {
      return _Any_NOut(_messagesLocal);
    }

    final isInCase =
        cache.where((m) => m.id == api.last.id).isNotEmpty &&
        cache.last.id != api.last.id;

    if (isInCase) {
      return _Any_In(_messagesLocal);
    } else {
      return _Any_NOut(_messagesLocal);
    }
  }
}

abstract class _Combiner {
  const _Combiner(this._local);

  final MessagesLocalDataSource _local;

  Iterable<MessageDto> combine(
    List<MessageDto> cache,
    List<MessageDto> api, {
    int? limit,
  });
}

class _Any_NOut extends _Combiner {
  _Any_NOut(super.local);

  @override
  Iterable<MessageDto> combine(
    List<MessageDto> cache,
    List<MessageDto> api, {
    int? limit,
  }) {
    _local.deleteAllWithIds(cache.map((m) => m.id)).whenComplete(() {
      _local.insertAll(api);
    });
    return api;
  }
}

class _Any_In extends _Combiner {
  _Any_In(super.local);

  @override
  Iterable<MessageDto> combine(
    List<MessageDto> cache,
    List<MessageDto> api, {
    int? limit,
  }) {
    if (api.length < (limit ?? AppConstants.msgPagingLimit)) {
      _local.deleteAllWithIds(cache.map((m) => m.id)).whenComplete(() {
        _local.insertAll(api);
      });
      return api;
    }

    _local
        .deleteAllWithIds(cache.where((m) => m.id >= api.last.id).map((m) => m.id))
        .whenComplete(() {
          _local.insertAll(api);
        });

    final newList = <MessageDto>[
      ...api,
      ...cache.sublist(cache.indexWhere((m) => m.id == api.last.id) + 1),
    ];
    return newList;
  }
}
