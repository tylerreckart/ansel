//
//  FilterFactor.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/17/22.
//
import SwiftUI

struct FilterFactor: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var priority_mode: PriorityMode = .aperture

    @State private var shutter_speed: String = ""
    @State private var aperture: String = ""

    @State private var f_stop_reduction: Double = 1
    @State private var compensated_shutter: Double = 0
    @State private var compensated_aperture: Double = 0

    @State private var selected: FilterDropdownOption = FilterDropdownOption(key: "1", value: 1)

    @State private var calculated_factor: Bool = false
    
    @State private var showingHistorySheet: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                FilterForm(
                    priority_mode: $priority_mode,
                    shutter_speed: $shutter_speed,
                    aperture: $aperture,
                    calculated_factor: $calculated_factor,
                    calculate: self.calculate,
                    reset: self.reset,
                    selected: $selected
                )
            }
            .padding([.leading, .trailing, .bottom])
            .background(.background)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
            .padding([.leading, .trailing, .bottom])

            if self.compensated_shutter > 0 {
                CalculatedResultCard(
                    label: "Adjusted shutter speed (seconds)",
                    icon: "clock.circle.fill",
                    result: "\(Int(round(compensated_shutter))) seconds",
                    background: Color(.systemPurple)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                .padding([.leading, .trailing, .bottom])
            }
            
            if self.compensated_aperture > 0 {
                CalculatedResultCard(
                    label: "Adjusted aperture",
                    icon: "f.cursive.circle.fill",
                    result: "f/\(Int(round(compensated_aperture)))",
                    background: Color(.systemGreen)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                .padding([.leading, .trailing, .bottom])
            }
        }
        .background(Color(.systemGray6))
        .navigationTitle("Filter Factor")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            HStack {
                Button(action: {
                    self.showingHistorySheet.toggle()
                }) {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                }
            }
        }
        .sheet(isPresented: $showingHistorySheet) {
            FilterHistorySheet()
        }
    }
    
    func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    private func calculate() {
        if self.priority_mode == .aperture {
            let adjustment = pow(2, self.selected.value)
            let adjusted_speed = Double(self.shutter_speed)! * adjustment

            self.compensated_shutter = adjusted_speed
        }
        
        if self.priority_mode == .shutter {
            let adjustment = pow(2, self.selected.value)
            let adjusted_aperture = Double(self.aperture)! * (adjustment / 2)

            self.compensated_aperture = closestValue(f_stops, adjusted_aperture)
        }
        
        self.calculated_factor = true
        
        save()
    }

    func save() {
        let filterData = FilterData(context: managedObjectContext)

        filterData.fStopReduction = selected.value
        filterData.compensatedAperture = self.compensated_aperture
        filterData.compensatedShutterSpeed = self.compensated_shutter
        filterData.timestamp = Date()

        saveContext()
    }
    
    private func reset() {
        self.calculated_factor = false
        self.compensated_aperture = 0
        self.compensated_shutter = 0
    }
}

struct Filter_Previews: PreviewProvider {
    static var previews: some View {
        FilterFactor()
    }
}
