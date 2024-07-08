//
//  TaskBox.swift
//  Tick Task
//
//  Created by Yusuf Burak on 07/07/2024.
//

import SwiftUI

struct TaskBox: View {
    @Environment(\.managedObjectContext) private var moc
    var tasks: [Task]
    var date: Date
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text(dateFormatted(date))
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
        .clipShape(.rect(cornerRadius: 20))
        .shadow(radius: 5)
        .padding()
    }
    
    private func dateFormatted(_ date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let formatter = DateFormatter()

        if calendar.isDate(date, inSameDayAs: today) {
            formatter.dateFormat = "EEEE"
            let day = formatter.string(from: date)
            return "Today • \(day)"
        } else if calendar.isDate(date, inSameDayAs: tomorrow) {
            formatter.dateFormat = "EEEE"
            let day = formatter.string(from: date)
            return "Tomorrow • \(day)"
        } else {
            formatter.dateFormat = "d MMMM, EEEE"
            return formatter.string(from: date)
        }
    }
}

#Preview {
    TaskBox(tasks: [Task(context: PersistenceController.preview.container.viewContext)], date: Date())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .previewLayout(.sizeThatFits)
}
