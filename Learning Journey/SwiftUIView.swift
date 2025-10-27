import SwiftUI
import FSCalendar

// Define a reusable dark brown color for the unselected date circles
extension UIColor {
    // This color is a close approximation of the dark brown in your screenshot.
    // Feel free to fine-tune the RGB values if needed.
    static let darkChocolate = UIColor(red: 40/255, green: 25/255, blue: 10/255, alpha: 1.0)
}

// MARK: - CalendarPageView (The Destination View)

struct CalendarPageView: View {
    // Initialize the date to the one visible in the screenshot (October 27, 2025)
    @State private var selectedDate = Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 27))!

    @Environment(\.dismiss) var dismiss // For the custom back button

    var body: some View {
        ZStack {
            // 1. Black Background extending to all edges
            Color.black
                .ignoresSafeArea(.all) // Ensures it covers notch and home indicator area
            
            VStack(spacing: 0) {
                // --- Custom Header ---
                // Replicates the "All activities" header and back button, ignoring safe area
                HStack {
                    // Custom Back button
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("All activities")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for right-side balance (e.g., status bar icons)
                    Image(systemName: "ellipsis") // Using ellipsis as a placeholder for other toolbar items
                        .font(.title)
                        .foregroundColor(.clear) // Make it clear to just take up space
                }
                .padding(.horizontal)
                .padding(.top, 60) // Push content below the status bar/notch
                .padding(.bottom, 20) // Spacing below the header
                
                // --- Separator Line ---
                // Based on your target image, there's a thin line below the top header
                Divider()
                    .background(Color.gray.opacity(0.5))
                    .padding(.horizontal)
                    .padding(.bottom, 20) // Spacing above the calendar
                
                // --- FSCalendar Component ---
                // The frame height ensures multiple months are visible and scrollable within the VStack.
                // You can adjust this height as needed to fit your design.
                FSCalendarRepresentable(selectedDate: $selectedDate)
                    .frame(height: 700) // Ample height to show several months
                    .padding(.bottom, 50) // Space at the bottom if scrolling
            }
        }
        // IMPORTANT: Hide the default SwiftUI navigation bar
        // This allows our custom header to take full control and ignore safe area.
        .navigationBarHidden(true)
    }
}


// MARK: - FSCalendarRepresentable (UIViewRepresentable for FSCalendar)

// Renamed from FSCalendarView to avoid confusion if you have another CalendarView
struct FSCalendarRepresentable: UIViewRepresentable {
    @Binding var selectedDate: Date

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator

        // --- Configuration ---
        calendar.scrollDirection = .vertical // To show multiple months, matching screenshot
        calendar.scope = .month // Keeps month view, but scrolls vertically
        
        // 💡 CRUCIAL: Hide days from previous/next month, as seen in your target screenshot
        calendar.placeholderType = .none
        
        calendar.backgroundColor = UIColor.black // Ensure calendar background is black
        
        // Ensure month title is centered and visible
        calendar.appearance.headerTitleAlignment = .center
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        calendar.appearance.headerTitleColor = UIColor.white
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        // Weekday appearance (Sun, Mon, Tue...)
        calendar.appearance.weekdayTextColor = UIColor.orange
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 14, weight: .medium)

        // 💡 CRUCIAL for circular look: Set cells to be perfectly round
        //calendar.appearance.cellShape = .circle
        calendar.appearance.borderRadius = 1.0 // Ensures it's a full circle if width == height

        // Select the initial date
        calendar.select(selectedDate)
        
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        // Only update selection if the bound date changes from outside
        if uiView.selectedDate != selectedDate {
             uiView.select(selectedDate)
        }
        // Reload data to ensure custom appearance delegate methods are re-applied
        uiView.reloadData()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator (Delegate and DataSource)
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        var parent: FSCalendarRepresentable

        init(_ parent: FSCalendarRepresentable) {
            self.parent = parent
        }

        // --- FSCalendarDelegate ---
        // Updates the SwiftUI @Binding when a date is selected in the calendar UI
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
        
        // --- FSCalendarDelegateAppearance (for custom colors/shapes) ---

        // 💡 1. Provide the fill color for *default (unselected)* dates
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
            // Apply dark brown for all days that are not the currently selected one
            // This ensures every day gets a background unless it's explicitly selected.
            if !calendar.selectedDates.contains(date) {
                return .darkChocolate
            }
            return nil // Let fillSelectionColorFor handle selected dates
        }

        // 💡 2. Provide the fill color for *selected* dates
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
            // Return orange for the selected date
            return UIColor.orange
        }

        // 💡 3. Provide the title color for *default (unselected)* dates
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            // Ensure white text on the dark brown circle
            return UIColor.white
        }

        // 💡 4. Provide the title color for *selected* dates
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
            // Ensure white text on the orange circle
            return UIColor.white
        }
    }
}

