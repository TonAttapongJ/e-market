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
  @State private var showingConfirmation: Bool = false
  @FocusState private var addressFocused: Bool
  let imageSize = UIScreen.main.bounds.width * 0.2
  
  public init(viewModel: OrderSummaryViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {

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
                  message: Text("Are you sure you to confirm place order"),
                  primaryButton: .destructive(Text("Confirm")) {
                    self.viewModel.confirmOrder()
                  },
                  secondaryButton: .cancel()
                )
              }
            }
            HStack {
              Text("Total Price: ")
              Spacer()
              Text("\(viewModel.productModels.reduce(0) { $0 + ($1.price * Double($1.quantity)) }, specifier: "%.2f")")
                .fontWeight(.semibold)
                .font(.system(size: 18))
                .lineLimit(2)
            }
            
            Text("Address: ")
              .padding(.top, 8)
            ZStack(alignment: .topLeading) {
              TextEditor(text: $viewModel.addressText)
                .background(Color.white)
                .cornerRadius(8)
                .foregroundColor(.black)
                .accentColor(.blue)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                      HStack {
                        Spacer()
                        Button("Done") {
                          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                      }
                    }
                }
                .focused($addressFocused)
              if viewModel.addressText.isEmpty {
                Text("Enter your address")
                  .foregroundColor(.gray)
                  .padding(.top, 8)
                  .padding(.leading, 8)
                  .onTapGesture {
                    self.addressFocused = true
                  }
              }
            }
            .frame(height: 150)
            
            Spacer()
              .alert(isPresented: $viewModel.isShowError) {
                Alert(
                  title: Text("Error occure"),
                  message: Text("\(viewModel.errorMessage), Please try again later"),
                  dismissButton: .default(Text("OK"))
                )
              }
          }.padding(16)
            .navigationTitle("Order Summary")
        }
        VStack {
          Spacer()
          VStack {
            Button(action: {
              showingConfirmation = true
            }) {
              Text("Confirm Place Order")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(viewModel.addressText.isEmpty ? Color.gray : Color.black)
            .cornerRadius(10)
            .disabled(viewModel.addressText.isEmpty)
          }
          .background(Color.white)
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .bottom)
        .padding()
        
        VStack {
          ProgressView("Loading...")
            .progressViewStyle(CircularProgressViewStyle())
        }
        .frame(width: geometry.size.width / 3,
               height: geometry.size.height / 6)
        .background(Color.secondary.colorInvert())
        .foregroundColor(Color.primary)
        .cornerRadius(20)
        .opacity(self.viewModel.isLoading ? 1 : 0)

      }
      .onChange(of: viewModel.isNavigateToSuccessScreen, { oldValue, newValue in
        if newValue {
          router.navigate(to: .orderSuccess)
        }
      })
      .onTapGesture {
          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    }
  }
}

#Preview {
  OrderSummaryView(viewModel: OrderSummaryViewModel(productModels: []))
}
