//
//  TaskDateAndTimeBoxView.swift
//  Tick Task
//
//  Created by Yusuf Burak on 09/07/2024.
//

import SwiftUI

struct TaskDateAndTimeBoxView: View {
    
    @Binding var dueDate: Date
    @Binding var isDueTime: Bool
    @Binding var dueTime: Date?
    
    var body: some View {
        
        VStack {
            
            DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                .background(Color.gray.opacity(0))
                .padding(.top, 5)
            
            Divider()
                .padding(.vertical, 5)
            
            if #available(iOS 17.0, *) {
                
                Toggle("Has Due Time", isOn: $isDueTime)
                    .padding(.bottom, 5)
                    .onChange(of: isDueTime) {
                        if isDueTime {
                            dueTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: dueDate)
                        } else {
                            dueTime = nil
                        }
                    }
                
            } else {
                
                Toggle("Has Due Time", isOn: $isDueTime)
                    .padding(.bottom, 5)
                    .onChange(of: isDueTime, perform: { value in
                        if value {
                            dueTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: dueDate)
                        } else {
                            dueTime = nil
                        }
                    })

            }
            
            if isDueTime {
                Divider()

                DatePicker("Due Time", selection: Binding(
                    get: { dueTime ?? Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: dueDate)! },
                    set: { dueTime = $0 }
                ), displayedComponents: .hourAndMinute)
                .onAppear {
                    UIDatePicker.appearance().minuteInterval = 15
                }
                .padding(.vertical, 5)

            }
            
        }
        .environment(\.colorScheme, .light)

        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color("BoxBackground"))
        .overlay(
            RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                .stroke(Color.black, lineWidth: 3)
        )
        .clipShape(.rect(cornerRadius: 15))
    }
    
}

#Preview {
    struct Preview: View {
        @State var dueDate: Date = Date()
        @State var isDueTime: Bool = false
        @State var dueTime: Date? = Date()
        var body: some View {
            TaskDateAndTimeBoxView(dueDate: $dueDate, isDueTime: $isDueTime, dueTime: $dueTime)
        }
    }
    return Preview()
}
