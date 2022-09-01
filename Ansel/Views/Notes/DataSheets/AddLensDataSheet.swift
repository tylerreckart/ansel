//
//  AddLensDataSheet.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/30/22.
//

import SwiftUI

struct AddLensDataSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var addData: (Lens) -> Void

    @FetchRequest(
      entity: Lens.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Lens.manufacturer, ascending: true)
      ]
    ) var fetchedResults: FetchedResults<Lens>

    var body: some View {
        NavigationView {
            VStack {
                if fetchedResults.isEmpty {
                    VStack {
                        Spacer()
                        Text("Add a camera to get started")
                            .foregroundColor(Color(.systemGray))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                } else {
                    List {
                        ForEach(fetchedResults, id: \.self) { result in
                            Button(action: {
                                addData(result)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(result.manufacturer!)
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))
                                        Text("\(result.focalLength)mm f/\(result.maximumAperture.clean)")
                                    }
                                    .padding([.top, .bottom], 1)
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("Add a Lens")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    }
                    .foregroundColor(Color(.systemGray))
                }
            }
        }
    }
}
