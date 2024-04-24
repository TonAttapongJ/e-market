//
//  RouterDestination.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import SwiftUI

enum RouterDestination {
  case home(viewModel: HomeViewModel)
  case cartView(viewModel: CartViewModel)
}

extension RouterDestination: Equatable {
  static func == (lhs: RouterDestination, rhs: RouterDestination) -> Bool {
    switch (lhs, rhs) {
    case (.home, .home): return true
    case (.cartView, .cartView): return true
    default: return false
    }
  }
}

extension RouterDestination: Hashable {
  public func hash(into hasher: inout Hasher) {
    switch self {
    case .home: hasher.combine(0)
    case .cartView: hasher.combine(1)
    }
  }
}

protocol RouterFactory {
  associatedtype Body : View
  func makeBody(for destination: RouterDestination) -> Self.Body
}

class RouterFactoryView: RouterFactory {
  public init() {}
  @ViewBuilder
  public func makeBody(for destination: RouterDestination) -> some View {
    switch destination {
    case .home(let viewModel):
      HomeView(viewModel: viewModel)
    case .cartView(let viewModel):
      CartView(viewModel: viewModel)
    }
  }
}
