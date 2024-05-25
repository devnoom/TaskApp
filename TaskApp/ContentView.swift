//
//  ContentView.swift
//  TaskApp
//
//  Created by MacBook Air on 23.05.24.
//
import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    var isCompleted: Bool
}

// MARK: - Content View
struct ContentView: View {
    @State private var tasks = [
        Task(title: "Mobile App Research", date: "4 Oct", isCompleted: false),
        Task(title: "Prepare Wireframe for Main Flow", date: "4 Oct", isCompleted: true),
        Task(title: "Prepare Screens", date: "4 Oct", isCompleted: true),
        Task(title: "Website Research", date: "5 Oct", isCompleted: true),
        Task(title: "Prepare Wireframe for Main Flow", date: "5 Oct", isCompleted: true),
        Task(title: "Prepare Screens", date: "5 Oct", isCompleted: true)
    ]
    
    var body: some View {
        let completedTasks = tasks.filter { $0.isCompleted }.count
        let totalTasks = tasks.count
        let uncompletedTasks = tasks.filter { !$0.isCompleted }.count
        
        return VStack {
            TaskSummaryView(
                completedTasks: completedTasks,
                totalTasks: totalTasks,
                uncompletedTasks: uncompletedTasks,
                completeAllAction: {
                    completeAllTasks()
                }
            )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Progress Section
                    Text("Progress")
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Daily Task")
                            .font(.headline)
                            .bold()
                        Text("\(completedTasks)/\(totalTasks) Task Completed")
                        
                        HStack {
                            Text("Keep working")
                                .font(.footnote)
                            Spacer()
                            Text("\(Int(Double(completedTasks) / Double(totalTasks) * 100))%")
                        }
                        .font(.subheadline)
                        
                        let progressValue: Double = totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0.0
                        
                        ProgressView(value: progressValue)
                            .progressViewStyle(LightBlueProgressViewStyle(height: 20))
                    }
                    .padding(.horizontal, 10)
                    
                    Text("Completed Tasks")
                        .font(.headline)
                        .padding(.horizontal, 10)
                    
                    ForEach(tasks.indices.filter { tasks[$0].isCompleted }, id: \.self) { index in
                        TaskRow(task: $tasks[index])
                            .padding(.horizontal, 10)
                    }
                    
                    Text("Uncompleted Tasks")
                        .font(.headline)
                        .padding(.horizontal, 10)
                        .padding(.top)
                    
                    ForEach(tasks.indices.filter { !tasks[$0].isCompleted }, id: \.self) { index in
                        TaskRow(task: $tasks[index])
                            .padding(.horizontal, 10)
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .background(Color(UIColor.systemGray5))
    }
    
    private func completeAllTasks() {
        for index in tasks.indices {
            tasks[index].isCompleted = true
        }
    }
}

// MARK: - Task Summary View
struct TaskSummaryView: View {
    var completedTasks: Int
    var totalTasks: Int
    var uncompletedTasks: Int
    var completeAllAction: () -> Void
    
    var body: some View {
       
        VStack(alignment: .leading, spacing: 20) {
            VStack {
                HStack {
                    if uncompletedTasks > 0 {
                        Text("You have \(uncompletedTasks) tasks to complete")
                            .font(.title2)
                            .bold()
                            .frame(width: 200)
                    } else {
                        Text("დაწერე 100 და წაი დეისვენე.")
                            .font(.title2)
                            .bold()
                            .frame(width: 200)
                    }
                    Spacer()
                    
                    ZStack {
                        Image("GOAT!")
                            .resizable()
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                        
                        ZStack {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 30, height: 30)
                            
                            Text("\(uncompletedTasks)")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .offset(x: 20, y: 20)
                    }
                }
                Button(action: completeAllAction) {
                    Text("Complete All")
                        .frame(width: 365, height: 60)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.green.opacity(0.5)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

// MARK: - Progress View
struct LightBlueProgressViewStyle: ProgressViewStyle {
    var height: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            let progressBarWidth = geometry.size.width
            let width = progressBarWidth * CGFloat(configuration.fractionCompleted ?? 0)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .frame(height: height)
                    .foregroundColor(Color.blue.opacity(0.1))
                RoundedRectangle(cornerRadius: height / 2)
                    .frame(width: width, height: height)
                    .foregroundColor(Color.blue.opacity(0.4))
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.25), Color.clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(RoundedRectangle(cornerRadius: height / 2))
                    )
            }
        }
        .frame(height: height)
    }
}

// MARK: - Task Row
struct TaskRow: View {
    @Binding var task: Task

    private func randomColor() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(randomColor())
                .frame(width: 10)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.vertical, 5)
                Text(task.date)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.vertical, 5)
            }
            .padding(.leading, 10)
            
            Spacer()
            
            Button(action: {
                task.isCompleted.toggle()
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .blue : .gray)
            }
            .padding(.trailing, 8)
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal, 10)
        .padding(.bottom, 8)
    }
}

// MARK: - ContentView Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
