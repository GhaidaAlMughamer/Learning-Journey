import SwiftUI
import ElegantCalendar

enum LogState {
    case unlogged
    case learned
    case freezed
}

struct log: View {
    @State private var currentLogState: LogState = .unlogged
    @State private var daysLearned: Int = 0
    @State private var freezesLeft: Int = 1

    private var isDayLogged: Bool {
        currentLogState != .unlogged
    }

    private var isFreezedButtonDisabled: Bool {
        isDayLogged || freezesLeft == 0
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("Ablack").ignoresSafeArea()

                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        CalendarView()

                        HStack {
                            Text("Learning Swift")
                                .font(.headline)
                                .foregroundColor(Color("white"))
                            Spacer()
                        }
                        .padding(.horizontal)

                        StatsRow(daysLearned: daysLearned, freezesLeft: freezesLeft)
                    }
                    .padding(.horizontal)

                    MainLogCircle(
                        currentLogState: $currentLogState,
                        isDayLogged: isDayLogged,
                        daysLearned: $daysLearned
                    )

                    FreezedButton(
                        currentLogState: $currentLogState,
                        freezesLeft: $freezesLeft,
                        isDisabled: isFreezedButtonDisabled
                    )

                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Activity")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color("Ablack"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                HStack(spacing: 16) {
                    Button(action: { }) {
                        Image(systemName: "calendar")
                            .foregroundColor(Color("white"))
                    }
                    Button(action: { }) {
                        Image(systemName: "pencil.and.outline")
                            .foregroundColor(Color("white"))
                    }
                }
            }
        }
    }
}

struct CalendarView: View {
    let daysOfWeek = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

    private var today: Int {
        Calendar.current.component(.day, from: Date())
    }

    private var mockDates: [Int] {
        let range = 20...26
        return Array(range)
    }

    var body: some View {
        VStack(spacing: 9) {
            HStack {
                Text(Date.now.formatted(.dateTime.month().year()))
                    .font(.headline)
                    .foregroundColor(Color("white"))
                Image(systemName: "chevron.left")
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("orange"))
            }
            .padding(.horizontal)

            HStack {
                ForEach(daysOfWeek.prefix(mockDates.count), id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color("white").opacity(0.7))
                }
            }
            .padding(.horizontal)

            HStack(spacing: 10) {
                ForEach(mockDates, id: \.self) { date in
                    VStack(spacing: 4) {
                        Circle()
                            .fill(circleColor(for: date))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle()
                                    .stroke(
                                        date == today ? Color("white").opacity(0.5) : .clear,
                                        lineWidth: 2
                                    )
                            )
                            .overlay(
                                Text("\(date)")
                                    .font(.headline)
                                    .foregroundColor(Color("white"))
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .opacity(date == today ? 1.0 : 0.9)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 12)
        .background(Color("Bgray"))
        .cornerRadius(18)
    }

    private func circleColor(for date: Int) -> Color {
        if date == today {
            return Color("orange").opacity(0.9)
        } else if date < today {
            return Color("orange").opacity(0.4)
        } else {
            return Color("Bgray").opacity(0.5)
        }
    }
}

struct StatsRow: View {
    let daysLearned: Int
    let freezesLeft: Int

    private func learnedText(for count: Int) -> String {
        count == 1 ? "1 Day Learned" : "\(count) Days Learned"
    }

    private func freezeText(for count: Int) -> String {
        count == 1 ? "1 Day Freezed" : "\(count) Days Freezed"
    }

    var body: some View {
        HStack {
            CounterCard(
                iconName: "flame.fill",
                countText: learnedText(for: daysLearned),
                bgColor: Color("orange").opacity(0.4),
                fgColor: Color("orange")
            )

            CounterCard(
                iconName: "cube.fill",
                countText: freezeText(for: freezesLeft),
                bgColor: Color("blue").opacity(0.3),
                fgColor: Color("blue")
            )
        }
    }
}

struct CounterCard: View {
    let iconName: String
    let countText: String
    let bgColor: Color
    let fgColor: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Image(systemName: iconName)
                    .font(.title)
                    .foregroundColor(fgColor)

                Text(countText)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("white"))
            }
            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(bgColor)
        .cornerRadius(12)
    }
}

struct MainLogCircle: View {
    @Binding var currentLogState: LogState
    let isDayLogged: Bool
    @Binding var daysLearned: Int

    private var circleColor: Color {
        switch currentLogState {
        case .unlogged, .learned: return Color("orange")
        case .freezed: return Color("blue")
        }
    }

    private var circleOpacity: Double {
        switch currentLogState {
        case .unlogged, .freezed: return 1.0
        case .learned: return 0.6
        }
    }

    private var buttonText: String {
        switch currentLogState {
        case .unlogged: return "Log as\nLearned"
        case .learned: return "Learned\nToday"
        case .freezed: return "Day\nFreezed"
        }
    }

    var body: some View {
        Button(action: {
            if !isDayLogged {
                withAnimation(.spring()) {
                    currentLogState = .learned
                    daysLearned += 1
                }
            }
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [circleColor.opacity(0.8), circleColor]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .opacity(circleOpacity)
                    .shadow(color: circleColor.opacity(0.4), radius: 15, x: 0, y: 10)

                Text(buttonText)
                    .font(.title)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("white"))
            }
            .frame(width: 240, height: 240)
        }
        .disabled(isDayLogged)
    }
}

struct FreezedButton: View {
    @Binding var currentLogState: LogState
    @Binding var freezesLeft: Int
    let isDisabled: Bool

    var body: some View {
        Button(action: {
            if !isDisabled {
                withAnimation(.spring()) {
                    currentLogState = .freezed
                    freezesLeft -= 1
                }
            }
        }) {
            Text("Log as Freezed")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(isDisabled ? Color("white").opacity(0.5) : Color("white"))
                .frame(maxWidth: 200)
                .padding(.vertical, 12)
                .background(isDisabled ? Color("Bgray") : Color("blue").opacity(0.7))
                .cornerRadius(30)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.7 : 1.0)
    }
}

struct log_Previews: PreviewProvider {
    static var previews: some View {
        log()
    }
}
