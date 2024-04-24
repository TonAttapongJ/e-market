import SwiftUI

@main
struct e_marketApp: App {
  @ObservedObject var router = Router()
  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $router.navigationPath) {
        HomeView(viewModel: HomeViewModel())
          .navigationDestination(for: RouterDestination.self) { destination in
            RouterFactoryView().makeBody(for: destination)
          }
      }
      .environmentObject(router)
    }
  }
}
