//
//  CartView.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import SwiftUI

struct CartView: View {
  @StateObject var viewModel: CartViewModel
  @EnvironmentObject var router: Router
  let disableColor = Color(red: 0.8, green: 0.8, blue: 0.8)
  
  public init(viewModel: CartViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    VStack {
      Text("Cart")
      switch viewModel.viewState {
      case .start:
        EmptyView()
      case .loading:
        Spacer()
        ProgressView("Loading...")
          .progressViewStyle(CircularProgressViewStyle())
          .padding()
        Spacer()
      case .success:
        VStack {
          ForEach(viewModel.productModels, id: \.name) { item in
            Text("Placeholder \(item.name)")
          }
        }
      case .failed:
        Text("ERROR: SHOW SOME ERROR.")
      }
      
    }
    
  }
}

#Preview {
  CartView(viewModel: CartViewModel())
}
