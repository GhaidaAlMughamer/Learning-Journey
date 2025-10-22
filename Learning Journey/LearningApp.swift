import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - ContentView
struct ContentView: View {
    @State private var selectedTime = ""
    @State private var learningTopic = ""
    @State private var navigateToLog = false
    let options = ["Week", "Month", "Year"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color("Ablack").ignoresSafeArea()
                
                VStack(spacing: 32) {
                    // Flame
                    ZStack {
                        Circle()
                            .fill(Color("DDorange"))
                            .background(
                                VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                                    .clipShape(Circle())
                            )
                            .overlay(
                                Circle().stroke(Color("white").opacity(0.2), lineWidth: 1)
                            )
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "flame.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .foregroundColor(Color("orange"))
                    }
                    .padding(.top, 40)
                    
                    // Texts
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
                        
                        VStack(alignment: .leading, spacing: 1) {
                            TextField("Enter topic (e.g. Swift)", text: $learningTopic)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(Color(.gray).opacity(0.8))
                                .font(.custom("SF Pro Text Regular", size: 17))
                                .padding(.vertical, 1)
                                .background(Color("black"))
                            
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(Color("Bgray"))
                        }
                        .padding(.top, 1)
                        
                        Divider().background(Color("Bgray"))
                        
                        HStack {
                            Text("I want to learn it in a")
                                .font(.custom("SF Pro Text Semibold", size: 24))
                                .foregroundColor(Color("white"))
                                .padding(.top, 32)
                        }
                    }
                    
                    // Duration selection
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
                                            .fill(selectedTime == option ? Color("Dorange") : Color("Bgray").opacity(0.3))
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
                    
                    // Navigation to Log Page
                    NavigationLink(destination: LogView(), isActive: $navigateToLog) {
                        EmptyView()
                    }
                    
                    Button {
                        navigateToLog = true
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
}

// MARK: - Frosted Blur Effect
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
