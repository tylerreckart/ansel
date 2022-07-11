//
//  ContentView.swift
//  Lumen
//
//  Created by Tyler Reckart on 7/9/22.
//

import SwiftUI
import CoreData

struct DataFieldStyle: TextFieldStyle {
    @Binding var focused: Bool
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(focused ? .white : Color(.systemGray6))
        )
    }
}

struct GroupBoxWithFill: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack {
                configuration.label
                    .font(.headline)
                Spacer()
            }
            
            configuration.content
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(.white))
    }
}

struct ContentView: View {
    @State private var aperture: String = ""
    @State private var iso: String = ""
    @State private var shutter_speed: String = ""
    @State private var bellows_draw: String = ""
    @State private var focal_length: String = ""
    @State private var extension_factor: String = "No compensation necessary"
    @State private var calculated_factor: Bool = false
    @State private var compensated_aperture: String = ""
    @State private var priority_mode: String = "aperture"
    
    @State private var aperture_input_focused: Bool = false
    @State private var shutter_input_focused: Bool = false
    @State private var focal_input_focused: Bool = false
    @State private var draw_input_focused: Bool = false

    var body: some View {
        return NavigationView {
            VStack(alignment: .leading) {
                VStack {
                    TextField("Aperture", text: $aperture, onEditingChanged: { edit in
                        self.aperture_input_focused = edit
                    })
                        .textFieldStyle(DataFieldStyle(focused: $aperture_input_focused))
                    
                    TextField("Shutter Speed", text: $shutter_speed, onEditingChanged: { edit in
                        self.shutter_input_focused = edit
                    })
                        .textFieldStyle(DataFieldStyle(focused: $shutter_input_focused))
                    
                    TextField("Focal Length (mm)", text: $focal_length, onEditingChanged: { edit in
                        self.focal_input_focused = edit
                    })
                        .textFieldStyle(DataFieldStyle(focused: $focal_input_focused))
                        .keyboardType(.decimalPad)
                    
                    TextField("Bellows Draw (mm)", text: $bellows_draw, onEditingChanged: { edit in
                        self.draw_input_focused = edit
                    })
                        .textFieldStyle(DataFieldStyle(focused: $draw_input_focused))
                        .keyboardType(.decimalPad)
                    
                    VStack {
                        HStack {
                            Button(action: {
                                self.priority_mode = "aperture"
                            }) {
                                Image(systemName: "camera.aperture")
                                    .imageScale(.small)
                                Text("Aperture Priority")
                                    .font(.system(.caption))
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(self.priority_mode == "aperture" ? .white : .blue)
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(self.priority_mode == "aperture" ? .blue : .clear)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(.blue, lineWidth: 1)
                            )


                            Button(action: {
                                self.priority_mode = "shutter"
                            }) {
                                Image(systemName: "camera.shutter.button")
                                    .imageScale(.small)
                                Text("Shutter Priority")
                                    .font(.system(.caption))
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(self.priority_mode == "shutter" ? .white : .green)
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(self.priority_mode == "shutter" ? .green : .clear)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(.green, lineWidth: 1)
                            )
                        }

                        Button(action: calculate) {
                            Image(systemName: "equal.square")
                                .imageScale(.small)
                            Text("Calculate")
                                .font(.system(.caption))
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(.black)
                        .cornerRadius(6)
                    }
                }
                .padding()
                .background(.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                .padding(.bottom)
    
                if self.calculated_factor == true {
                    VStack {
                        VStack {
                            Text("Bellows Extension Factor")
                                .font(.system(.caption))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.gray)
                            Text(extension_factor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.bottom)
                        
                        if (self.priority_mode == "aperture") {
                            VStack {
                                Text("Aperture Compensation")
                                    .font(.system(.caption))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.gray)
                                HStack {
                                    Image(systemName: "f.cursive")
                                        .imageScale(.medium)
                                    Text(compensated_aperture)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }

                        if (self.priority_mode == "shutter") {
                            VStack {
                                Text("Shutter Compensation")
                                    .font(.system(.caption))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.gray)
                                Text("32 seconds")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 10)
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
        }
    }
    
    public func calculate() {
        let bellows_draw = Int(self.bellows_draw) ?? 1;
        let focal_length = Int(self.focal_length) ?? 1;
        
        // (Extension/FocalLength) **2
        let factor = Float(pow(Float(bellows_draw/focal_length), 2))
        
        if focal_length > 0 && bellows_draw > 0 {
            self.extension_factor = "\(Int(factor))"
            self.calculated_factor = true
            
            let aperture_compensation = log(factor)/log(2)

            self.compensated_aperture = "\(Int(aperture_compensation * (Float(aperture) ?? 1)!))"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
