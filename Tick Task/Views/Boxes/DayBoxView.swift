//
//  DayBoxView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 07/07/2024.
//

import SwiftUI

struct DayBoxView: View {
    @Environment(\.managedObjectContext) private var moc
    var tasks: [Task]
    var date: Date
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    
                    Text(dateFormatted(date))
    
                    Text("•")
                        .foregroundStyle(.secondary)
                    
                    Text(dayFormatted(date))
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                }
                ForEach(tasks) { task in
                    TaskRow(task: task)
                }
            }
            Spacer()

        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 15))
        .shadow(radius: 5)
    }
    
    private func dateFormatted(_ date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let formatter = DateFormatter()

        if calendar.isDate(date, inSameDayAs: today) {
            return "Today"
        } else if calendar.isDate(date, inSameDayAs: tomorrow) {
            return "Tomorrow"
        } else {
            formatter.dateFormat = "d MMM"
            return formatter.string(from: date)
        }
    }
    
    private func dayFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)

    }
}

#Preview {
    DayBoxView(tasks: [Task(context: PersistenceController.preview.container.viewContext)], date: Date())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .previewLayout(.sizeThatFits)
}
