import SwiftUI

@main
struct e_marketApp: App {
  @ObservedObject var router = Router()
  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $router.navigationPath) {
        HomeView(viewModel: HomeViewModel())
      }
      .environmentObject(router)
    }
  }
}
