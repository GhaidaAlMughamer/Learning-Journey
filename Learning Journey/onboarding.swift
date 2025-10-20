

import SwiftUI

struct ContentView: View {
    @State private var selectedTime = "Week"
    let options = ["Week", "Month", "Year"]

    var body: some View {
        ZStack {
            // Background
            Color("Ablack").ignoresSafeArea()
            
            VStack(spacing: 32) {
                
                // 🔥 Flame with Liquid Glass Circle
                ZStack {
                    Circle()
                        .fill(Color("Ablack").opacity(0.25)) // transparent base
                        .background(
                            VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                                .clipShape(Circle())
                        )
                        .overlay(
                            Circle()
                                .stroke(Color("white").opacity(0.2), lineWidth: 1)
                        )
                        .frame(width: 120, height: 120)
                        .shadow(color: Color("Ablack").opacity(0.6), radius: 8, x: 0, y: 2)
                        .shadow(color: Color("orange").opacity(0.3), radius: 15, x: 0, y: 0)
                    
                    Image(systemName: "flame.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundColor(Color("orange"))
                }
                .padding(.top, 40)
                
                // 🧠 Text content
                VStack(alignment: .leading, spacing: 6) {
                    Text("Hello Learner")
                        .font(.custom("SF Pro title Bold", size: 32))
                        .foregroundColor(Color("white"))
                    
                    Text("This app will help you learn everyday!")
                        .font(.custom("SF Pro Text Regular", size: 16))
                        .foregroundColor(Color(.gray))
                        .padding(.bottom, 24)
                    
                    Text("I want to learn")
                        .font(.custom("SF Pro Text Semibold", size: 24))
                        .foregroundColor(Color("white"))
                    
                    //Text("Swift")
                      //  .font(.custom("SF Pro Text Regular", size: 16))
                        //.foregroundColor(Color("Bgray"))
                        //.padding(.bottom, 16)
                    TextField("Placeholder", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    
                    Divider()
                        .background(Color("Bgray").opacity(0.3))
                    
                    Text("I want to learn it in a")
                        .font(.custom("SF Pro Text Semibold", size: 24))
                        .foregroundColor(Color("white"))
                        .padding(.top, 32)
                }
                
                // ⏱ Time selection buttons
                HStack(spacing: 1) {
                    ForEach(options, id: \.self) { option in
                        Button {
                            withAnimation { selectedTime = option }
                        } label: {
                            Text(option)
                                .font(.custom("SF Pro Text bold", size: 15))
                                .padding(.vertical, 16)
                                .padding(.horizontal, 30)
                                .background(
                                    Capsule()
                                        .fill(
                                            selectedTime == option
                                            ? Color("Dorange")
                                            : Color("Bgray").opacity(0.3)
                                        )
                                        .background(
                                            VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                                                .clipShape(Capsule())
                                        )
                                )
                                .foregroundColor(Color("white"))
                        }
                    }
                }
                
                Spacer()
                
                Button {
                                   print("Start learning tapped")
                               } label: {
                                   Text("Start learning")
                                       .font(.custom("SF Pro Text bold", size: 17))
                                       .foregroundColor(Color("white"))
                                       .padding(.vertical, 14)
                                       .frame(maxWidth: 180)
                                       .background(Color("Dorange"))
                                       .clipShape(Capsule())
                                       .shadow(color: Color("Ablack").opacity(0.4), radius: 4, x: 0, y: 2)
                               }
                               .padding(.horizontal, 24)
                               .padding(.bottom, 30)
                           }
                           .padding(.horizontal, 24)
                           .padding(.top, 60)
                       }
                   }
               }

               #Preview {
                   ContentView()
               }

// MARK: - Frosted Blur Effect
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
