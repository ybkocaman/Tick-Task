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
                
                Image(systemName: isFolded ? "chevron.down" : "chevron.up")
                    .foregroundStyle(.gray)
                    .padding(.trailing, 5)
                
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.bouncy(duration: 0.7)) {
                    toggleFoldedState()
                }
            }
            
            if !isFolded {
                ForEach(sortedTasks) { task in
                    TaskRowView(task: task)
                }
                .animation(.easeInOut(duration: 0.5), value: sortedTasks)
            }
        }

        .padding()
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 15))
        .shadow(radius: 5)
    }
    
    
    private var sortedTasks: [Task] {
        tasks.sorted {
            if $0.isCompleted == $1.isCompleted {
                if $0.priority == $1.priority {
                    return ($0.dueTime ?? Date.distantFuture) < ($1.dueTime ?? Date.distantFuture)
                } else {
                    return $0.priority < $1.priority
                }
            } else {
                return !$0.isCompleted && $1.isCompleted
            }
        }
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
    DayBoxView(tasks: [Task(context: PersistenceManager.preview.container.viewContext)], date: Date())
        .environment(\.managedObjectContext, PersistenceManager.preview.container.viewContext)
        .previewLayout(.sizeThatFits)
}
