//
//  GearSheet.swift
//  Aspen
//
//  Created by Tyler Reckart on 8/31/22.
//

import SwiftUI

struct GearSheet: View {
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("userAccentColor") var userAccentColor: Color = .accentColor
    
    @Binding var addedCameraData: Set<Camera>
    @Binding var addedFilmData: Set<Emulsion>
    @Binding var addedLensData: Set<Lens>

    @FetchRequest(
      entity: Camera.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Camera.manufacturer, ascending: true)
      ]
    ) var cameras: FetchedResults<Camera>
    
    @FetchRequest(
      entity: Lens.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Lens.manufacturer, ascending: true)
      ]
    ) var lenses: FetchedResults<Lens>
    
    @FetchRequest(
      entity: Emulsion.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Emulsion.manufacturer, ascending: true)
      ]
    ) var emulsions: FetchedResults<Emulsion>
    
    @State private var selectedCameras: [Camera] = []
    @State private var selectedLenses: [Lens] = []
    @State private var selectedEmulsions: [Emulsion] = []

    var body: some View {
        NavigationView {
            List {
                if cameras.count > 0 {
                    Section(header: Text("Cameras").textCase(.none).font(.system(size: 12))) {
                        ForEach(cameras, id: \.self) { result in
                            Button(action: {
                                addCamera(camera: result)
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(result.manufacturer!)
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))
                                        Text(result.model!)
                                            .foregroundColor(.primary)
                                    }
                                    .padding([.top, .bottom], 1)
                                    
                                    if selectedCameras.filter({ $0.id == result.id }).first != nil {
                                        Spacer()
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title)
                                            .foregroundColor(userAccentColor)
                                    }
                                }
                            }
                        }
                    }
                }
                
                if lenses.count > 0 {
                    Section(header: Text("Lenses").textCase(.none).font(.system(size: 12))) {
                        ForEach(lenses, id: \.self) { result in
                            Button(action: {
                                addLens(lens: result)
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(result.manufacturer!)
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))
                                        Text("\(result.focalLength)mm f/\(result.maximumAperture.clean)")
                                            .foregroundColor(.primary)
                                    }
                                    .padding([.top, .bottom], 1)
                                    
                                    if selectedLenses.filter({ $0.id == result.id }).first != nil {
                                        Spacer()
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title)
                                            .foregroundColor(userAccentColor)
                                    }
                                }
                            }
                        }
                    }
                }
                
                if emulsions.count > 0 {
                    Section(header: Text("Film Emulsions").textCase(.none).font(.system(size: 12))) {
                        ForEach(emulsions, id: \.self) { result in
                            Button(action: {
                                addEmulsion(emulsion: result)
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(result.manufacturer!)
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))
                                        Text(result.name!)
                                            .foregroundColor(.primary)
                                    }
                                    .padding([.top, .bottom], 1)
                                    
                                    if selectedEmulsions.filter({ $0.id == result.id }).first != nil {
                                        Spacer()
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title)
                                            .foregroundColor(userAccentColor)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Gear")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                addedCameraData.forEach { camera in
                    selectedCameras.append(camera)
                }
                
                addedLensData.forEach { lens in
                    selectedLenses.append(lens)
                }
                
                addedFilmData.forEach { emulsion in
                    selectedEmulsions.append(emulsion)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        save()
                    }) {
                        Text("Save")
                            .fontWeight(.bold)
                            .foregroundColor(userAccentColor)
                    }
                }
            }
        }
    }
    
    func save() {
        addedCameraData = Set(selectedCameras)
        addedLensData = Set(selectedLenses)
        addedFilmData = Set(selectedEmulsions)

        presentationMode.wrappedValue.dismiss()
    }
    
    func addCamera(camera: Camera) {
        let match = selectedCameras.filter({ $0.id == camera.id }).first
        
        if match == nil {
            selectedCameras.append(camera)
        } else {
            selectedCameras = selectedCameras.filter {
                $0.id != camera.id
            }
        }
    }
    
    func addLens(lens: Lens) {
        let match = selectedCameras.filter({ $0.id == lens.id }).first
        
        if match == nil {
            selectedLenses.append(lens)
        } else {
            selectedLenses = selectedLenses.filter {
                $0.id != lens.id
            }
        }
    }
    
    func addEmulsion(emulsion: Emulsion) {
        let match = addedFilmData.filter({ $0.id == emulsion.id }).first
        
        if match == nil {
            selectedEmulsions.append(emulsion)
        } else {
            selectedEmulsions = selectedEmulsions.filter {
                $0.id != emulsion.id
            }
        }
    }
}
