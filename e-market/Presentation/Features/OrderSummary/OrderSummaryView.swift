//
//  OrderSummaryView.swift
//  e-market
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import SwiftUI
import SDWebImageSwiftUI

struct OrderSummaryView: View {
  @StateObject var viewModel: OrderSummaryViewModel
  @EnvironmentObject var router: Router
  @State private var showingConfirmation = false
  let imageSize = UIScreen.main.bounds.width * 0.2

  public init(viewModel: OrderSummaryViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        ForEach(viewModel.productModels, id: \.name) { item in
          HStack {
            WebImage(url: URL(string: item.imageUrl))
              .resizable()
              .frame(width: imageSize, height: imageSize)
              .padding(.top, 0)
            VStack(alignment: .leading) {
              Text(item.name)
                .fontWeight(.semibold)
                .font(.system(size: 18))
                .lineLimit(2)
              
              HStack {
                Text("Quantity")
                Spacer()
                Text("\(item.quantity)")
                  .padding(.horizontal, 8)
              }
              
              HStack {
                Text("Price: ")
                Spacer()
                Text("\(item.price * Double(item.quantity), specifier: "%.2f")")
              }
            }
          }
          .alert(isPresented: $showingConfirmation) {
            Alert(
              title: Text("Confirmation"),
              message: Text("Are you sure you want to remove this item?"),
              primaryButton: .destructive(Text("Remove")) {
                //TODO: Todo
              },
              secondaryButton: .cancel()
            )
          }
        }
        Spacer()
      }.padding(16)
        .navigationTitle("Order Summary")
    }
  }
}

#Preview {
  OrderSummaryView(viewModel: OrderSummaryViewModel(productModels: []))
}
