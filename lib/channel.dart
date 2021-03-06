import 'package:fave_reads/Controller/reads_controller.dart';
import 'package:postgres/postgres.dart';
import 'fave_reads.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class FaveReadsChannel extends ApplicationChannel {
  ManagedContext context;

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config = ReadConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();

    // final pers = PostgreSQLPersistentStore.fromConnectionInfo(username, password, host, port, databaseName)

    // final con = PostgreSQLConnection('localhost', 5432, 'db_reads',
    //     username: 'postgres', password: 'arzel');

    // await con.open();
    // print("Conect to database");

    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName);
    context = ManagedContext(dataModel, persistentStore);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  // @override
  // Controller get entryPoint {
  //   final router = Router();

  //   router.route("/read").link(() => ReadsController(context));
  //   // Prefer to use `link` instead of `linkFunction`.
  //   // See: https://aqueduct.io/docs/http/request_controller/
  //   router.route("/example").linkFunction((request) async {
  //     return Response.ok({"key": "value"});
  //   });

  //   return router;
  // }

  @override
  Controller get entryPoint => Router()
    //final router = Router();
    // ..route("/read").linkFunction((request) async {
    //   switch (request.method) {
    //     case 'GET':
    //       //return Response.ok('Hello Get');
    //       return ReadsController(context).getAllRead();
    //     default:
    //       return Response.ok("Its not get");
    //   }
    // })
    //
    ..route("/read/[:id]").link(() => ReadsController(context))
    //
    ..route('/').linkFunction((request) =>
        Response.ok('Hello, World!')..contentType = ContentType.html);
  // Prefer to use `link` instead of `linkFunction`.
  // See: https://aqueduct.io/docs/http/request_controller/
  // ..route("/example").link((request) async {
  //   return Response.ok({"key": "value"});
  // });
  // //
  // ..route("/").link( () => Read)

}

class ReadConfig extends Configuration {
  ReadConfig(String path) : super.fromFile(File(path));
  DatabaseConfiguration database;
}
