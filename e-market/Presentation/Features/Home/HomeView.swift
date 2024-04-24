//
//  HomeView.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import SwiftUI


struct HomeView: View {
  @StateObject var viewModel: HomeViewModel
  @EnvironmentObject var router: Router
  @State private var isAddToCartViewPresented = false

  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  
  public init(viewModel: HomeViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    VStack(alignment: .leading) {
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
        ScrollView {
          ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            Text(viewModel.storeModel?.name ?? "")
              .fontWeight(.bold)
              .font(.system(size: 22))
              .lineLimit(2)
              .multilineTextAlignment(.center)
              .frame(maxWidth: .infinity)
            
            Button {
              //TODO: Implement Go to Cart
              router.navigate(to: .cartView(viewModel: CartViewModel()))
            } label: {
              ZStack {
                //TODO: Implement Badge
                var badgeCount: Int? = 4
                Image(systemName: "cart")
                  .foregroundColor(.black)
                  .padding(.bottom, 4)
                if let badgeCount = badgeCount, badgeCount > 0 {
                  Text("\(badgeCount)")
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding(4)
                    .background(Color.red)
                    .clipShape(Circle())
                    .offset(x: 10, y: -10)
                }
              }
            }
            .padding(.trailing, 16)
          }
          HStack {
            Text("Open: " + (viewModel.storeModel?.openingTime ?? "").toDateWithFormat())
              .fontWeight(.regular)
              .font(.system(size: 14))
              .lineLimit(2)
              .padding(.top, 8)
            Spacer()
          }.padding(.leading, 16)
          
          HStack {
            Text("Close: " + (viewModel.storeModel?.closingTime ?? "").toDateWithFormat())
              .fontWeight(.regular)
              .font(.system(size: 14))
              .lineLimit(2)
              .padding(.top, 4)
            Spacer()
          }.padding(.leading, 16)
          
          HStack {
            Text("Rating: ")
              .fontWeight(.regular)
              .font(.system(size: 14))
              .lineLimit(2)
            ForEach(1..<6) { index in
              let roundedRating = Double(index)
              let rating = (viewModel.storeModel?.rating ?? 0.0)
              let filled = roundedRating <= rating
              let imageName = filled ? "star.fill" : (rating - roundedRating >= -0.5 ? "star.lefthalf.fill" : "star")
              Image(systemName: imageName)
                .foregroundColor(.yellow)
            }
            Spacer()
          }
          .padding(.leading, 16)
          .padding(.top, 4)
          
          LazyVGrid(columns: columns, spacing: 20) {
            ForEach(viewModel.productModels, id: \.name) { item in
              ProductCardView(viewModel: viewModel.makeProductCardViewModel(product: item), didTapAddProductToCard: { selectedProduct in
                viewModel.setSelectedProduct(product: ProductModel(name: selectedProduct.name, price: Double(selectedProduct.price) ?? 0, imageUrl: selectedProduct.imageUrl))
                isAddToCartViewPresented = true
              })
            }
          }
          .padding()
        }
      case .failed:
        Spacer()
        Text(viewModel.errorMessage)
        Spacer()
      }
    }
    .sheet(isPresented: $isAddToCartViewPresented) {
      AddToCartView(viewModel: viewModel.makeAddToCartViewModel())
        .presentationDetents([.height(200)])
    }
  }
}

#Preview {
  HomeView(viewModel: .init(getStoreUseCase: GetStoreUseCaseImpl()))
}
