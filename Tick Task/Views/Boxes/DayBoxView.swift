//
//  DayBoxView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 07/07/2024.
//

import CoreData
import SwiftUI

struct DayBoxView: View {
    
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest var taskGroup: FetchedResults<TaskGroup>
    
    var tasks: [Task]
    var date: Date
    
    init(tasks: [Task], date: Date) {
        self.tasks = tasks
        self.date = date
        
        let fetchRequest: NSFetchRequest<TaskGroup> = TaskGroup.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.fetchLimit = 1
        _taskGroup = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    
                    Text(dateFormatted(date))
    
                    Text("•")
                        .foregroundStyle(.secondary)
                    
                    Text(dayFormatted(date))
                        .foregroundStyle(.secondary)
                    
                    if isFolded {
                        Image(systemName: "\(tasks.count).circle")
                            .font(.title3)
                            .padding(.leading, 10)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            toggleFoldedState()
                        }
                    } label: {
                        Image(systemName: isFolded ? "chevron.down" : "chevron.up")
                            .foregroundStyle(.gray)
                            .padding(.trailing, 5)
                    }
                    
                }
                if !isFolded {
                    ForEach(tasks) { task in
                        TaskRow(task: task)
                    }
                }
            }
            Spacer()

        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 15))
        .shadow(radius: 5)
    }
    
    private var isFolded: Bool {
        taskGroup.first?.isFolded ?? false
    }
    
    private func toggleFoldedState() {
        if let group = taskGroup.first {
            group.isFolded.toggle()
        } else {
            let newGroup = TaskGroup(context: moc)
            newGroup.date = date
            newGroup.isFolded = true
        }
        saveContext()
    }
    
    private func loadFoldedState() {
        if taskGroup.first == nil {
            let newGroup = TaskGroup(context: moc)
            newGroup.date = date
            newGroup.isFolded = false
            saveContext()
        }
    }
    
    private func saveContext() {
        try? moc.save()
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
