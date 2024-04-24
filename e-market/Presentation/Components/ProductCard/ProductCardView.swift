//
//  ProductCardView.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductCardView: View {
  @StateObject var viewModel: ProductCardViewModel
  var didTapAddProductToCard: ((DisplayProductCardViewModel) -> Void)?
  
  init(
    viewModel: ProductCardViewModel,
    didTapAddProductToCard: ((DisplayProductCardViewModel) -> Void)?
  ) {
    _viewModel = StateObject(wrappedValue: viewModel)
    self.didTapAddProductToCard = didTapAddProductToCard
  }

    var body: some View {
      VStack(alignment: .leading, spacing: 8) {
        WebImage(url: URL(string: viewModel.displayViewModel.imageUrl))
          .resizable()
          .frame(height: UIScreen.main.bounds.height * 0.30)
          .padding(.top, 0)
        
        Text(viewModel.displayViewModel.name)
          .fontWeight(.semibold)
          .font(.system(size: 18))
          .lineLimit(2)
          .padding(.top, 8)

        Text(viewModel.displayViewModel.price)
          .fontWeight(.regular)
          .font(.system(size: 15))
          .lineLimit(2)
          .padding(.top, 8)
        Button(action: {
          didTapAddProductToCard?(viewModel.displayViewModel)
        }) {
            Text("Add to card")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
        }
        Spacer()
      }
    }
}

#Preview {
  ProductCardView(viewModel: ProductCardViewModel(displayViewModel: DisplayProductCardViewModel(name: "tea", price: "25", imageUrl: "www")), didTapAddProductToCard: { _ in })
}
