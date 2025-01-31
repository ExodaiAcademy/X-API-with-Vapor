import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    let indexPresenter = IndexPresenter()
    
    app.routes.get(use: indexPresenter.presentPage)
}
