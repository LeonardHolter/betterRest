//
//  ContentView.swift
//  BetterRest
//
//  Created by Leonard Holter on 21/02/2024.
//
import CoreML
import SwiftUI


struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    
   static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }

    var body: some View {
        NavigationStack{

                Form {
                    Section("When do you want to wake up?") {
                        
                        
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                        
                    }
                    .onChange(of: wakeUp) {
                        calculateBedtime()
                    }
                    Section("Desired amount of sleep") {
                        

                        
                        
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in:    4...12, step: 0.25)
                        
                    }
               
                    .onChange(of: sleepAmount) {
                        calculateBedtime()
                        
                    }
                    Section("Dail coffee intake") {
                        
                        Picker("^[\(coffeAmount) cup](inflect: true)", selection: $coffeAmount) {
                            ForEach(1..<20) {cup in
                                Text("^[\(cup) cup](inflect: true)")
                            }
                           
                        }
                        
                        }
                    .onChange(of: coffeAmount) {
                        calculateBedtime()
                        

                        
                    }
                    
                    Section("Ideal betime") {
                        Text(alertMessage)
                    }
                    
                    Image("coffee")
                        
                    
                }
                .navigationTitle("BetterRest")
                
                
                
        
            
            
        }
        
    }
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 3600
            let minute = (components.minute ?? 0) * 60
            
            
            let prediciton = try model.prediction(wake: Int64(hour + minute), estimatedSleep: sleepAmount, coffee: Int64(coffeAmount))
            
            let sleepTime = wakeUp - prediciton.actualSleep
            
            alertTitle = "Your ideal bedtime is..."
            
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        }
        
        catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        
        showingAlert = true
        
    }
    
  
    
    }
#Preview {
    ContentView()
}
