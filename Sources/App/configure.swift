import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor",
        database: Environment.get("DATABASE_NAME") ?? "myxvapor",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.views.use(.leaf)

    
    // MARK: Migrations
    
    app.migrations.add(UserModel.UserModelMigration())
    app.migrations.add(TweetModel.TweetModelMigration())
    app.migrations.add(RetweetModel.RetweetModelMigration())
    app.migrations.add(LikesModel.LikesModelMigration())
    app.migrations.add(FollowersModel.FollowersModelMigration())
    app.migrations.add(BlockedModel.BlockedModelMigration())
    app.migrations.add(BlacklistModel.BlacklistModelMigration())

    // MARK: Seeds
    
    app.migrations.add(AdminSeed())
    
    app.logger.logLevel = .trace
    
    // register routes
    try routes(app)
}
