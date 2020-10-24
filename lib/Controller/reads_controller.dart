import 'package:fave_reads/fave_reads.dart';

import 'package:fave_reads/model/read.dart';

class ReadsController extends ResourceController {
  ReadsController(this.context);
  ManagedContext context;

  @Operation.get()
  Future<Response> getAllRead() async {
    print('Hello ');
    final readQuery = Query<Read>(context);
    return Response.ok(await readQuery.fetch());
  }

  @Operation.get('id')
  Future<Response> getRead(@Bind.path('id') int id) async {
    final readQuery = Query<Read>(context)
      ..where((read) => read.id).equalTo(id);
    final read = await readQuery.fetchOne();

    if (read == null) {
      return Response.notFound(body: 'Item not found');
    }
    return Response.ok(read);
  }

  @Operation.post()
  Future<Response> insertNewRead(@Bind.body() Read read) async {
    final readQuery = Query<Read>(context)..values = read;
    final insertRead = await readQuery.insert();

    return Response.ok(insertRead);
  }

  @Operation.delete('id')
  Future<Response> deleteRead(@Bind.path('id') int id) async {
    final readQuery = Query<Read>(context)
      ..where((read) => read.id).equalTo(id);

    final int read = await readQuery.delete();

    if (read == 0) {
      return Response.notFound(body: 'Item not found');
    }

    return Response.ok('Delete $read items ');
  }

  @Operation.put('id')
  Future<Response> updateRead(
      @Bind.body() Read read, @Bind.path('id') int id) async {
    final readQuery = Query<Read>(context)
      ..values = read
      ..where((data) => data.id).equalTo(id);

    final updateQuery = await readQuery.updateOne();

    if (updateQuery == null) {
      return Response.notFound(body: 'Item not found');
    }
    return Response.ok(updateQuery);
  }
}
