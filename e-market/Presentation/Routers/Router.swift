//
//  Router.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import SwiftUI
import Combine

final class Router: ObservableObject {
  public init() {}
  
  @Published public var navigationPath = NavigationPath()
  // Need LinkedList for navigateBack(to destination: YourDestination) because NavigationPath can not do this. we need to create itself.
  var linkedList = LinkedList<RouterDestination>()

  func navigate(to destination: RouterDestination) {
    linkedList.append(destination)
    navigationPath.append(destination)
  }
  
  func navigateBack() {
    guard linkedList.count > 0 else { return }
    linkedList.removeLast()
    navigationPath.removeLast()
  }
  
  func navigateBack(to destination: RouterDestination) {
    guard let lastIndex: Int = linkedList.lastIndex(where: { $0 == destination }) else {
      linkedList.removeAll()
      navigationPath.removeLast(navigationPath.count)
      return
    }
    let removeIndex = linkedList.count - lastIndex
    let isOutOfStack = removeIndex < 0
    guard !isOutOfStack else { return }
    linkedList.removeLast(removeIndex)
    navigationPath.removeLast(removeIndex)
  }
  
  func navigateBack(step: Int) {
    let isOutOfStack = linkedList.count - step < 0
    guard !isOutOfStack else { return }
    linkedList.removeLast(step)
    navigationPath.removeLast(step)
  }
  
  func navigateToRoot() {
    navigationPath.removeLast(navigationPath.count)
    linkedList.removeAll()
  }
  
}
