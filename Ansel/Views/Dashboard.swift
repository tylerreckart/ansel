//
//  Dashboard.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/24/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct DroppableTileDelegate<DashboardTile: Equatable>: DropDelegate {
    let tile: DashboardTile
    var listData: [DashboardTile]

    @Binding var current: DashboardTile?
    @Binding var hasLocationChanged: Bool
    
    var moveAction: (IndexSet, Int) -> Void
    
    func dropEntered(info: DropInfo) {
        guard tile != current, let current = current else { return }
        guard let from = listData.firstIndex(of: current), let to = listData.firstIndex(of: tile) else { return }
        
        hasLocationChanged = true
        
        if listData[to] != current {
            moveAction(IndexSet(integer: from), to > from ? to + 1 : to)
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        hasLocationChanged = false
        current = nil
        return true
    }
}

struct DashboardTileView<Content: View, DashboardTile: Identifiable & Equatable>: View {
    @Binding var tiles: [DashboardTile]
    let content: (DashboardTile) -> Content
    let moveAction: (IndexSet, Int) -> Void
    
    @Binding var draggingTile: DashboardTile?

    @State private var hasLocationChanged: Bool = false
    
    init(
        tiles: Binding<[DashboardTile]>,
        draggingTile: Binding<DashboardTile?>,
        @ViewBuilder content: @escaping (DashboardTile) -> Content,
        moveAction: @escaping (IndexSet, Int) -> Void
    ) {
        self._tiles = tiles
        self.content = content
        self.moveAction = moveAction
        self._draggingTile = draggingTile
    }
    
    var body: some View {
        VStack {
            ForEach(tiles) { tile in
                VStack {
                    content(tile)
                        .onDrag {
                            draggingTile = tile
                            return NSItemProvider(object: "\(tile.id)" as NSString)
                        } preview: {
                            content(tile)
                                .frame(minWidth: 150, minHeight: 80)
                                .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                        .onDrop(
                            of: [UTType.text],
                            delegate: DroppableTileDelegate(
                                tile: tile,
                                listData: tiles,
                                current: $draggingTile,
                                hasLocationChanged: $hasLocationChanged
                            ) { from, to in
                                withAnimation {
                                    moveAction(from, to)
                                }
                            }
                        )
                }
            }
        }
    }
}

struct Dashboard: View {
    // TODO: Remove the stateful nature of this layout behavior. Should persist between sessions.
    @State private var layout: [DashboardTile] = dashboard_tiles
    @State private var activeTileIds: [String?] = dashboard_tiles.map { $0.id }
    @State var isEditing: Bool = false
    @State var draggingTile: DashboardTile?
    
    @State var showTileSheet: Bool = false
    
    func removeTile(id: String) -> Void {
        layout = layout.filter({ $0.id != id })
        activeTileIds = activeTileIds.filter({ $0 != id })
    }
    
    func addTile(tile: DashboardTile) -> Void {
        layout.append(tile)
        activeTileIds.append(tile.id)
    }

    var body: some View {
        return NavigationView {
            VStack {
                DashboardTileView(tiles: $layout, draggingTile: $draggingTile) { tile in
                    LinkedNavigationTile(
                        tile: tile,
                        draggingTile: $draggingTile,
                        isEditing: $isEditing,
                        removeTile: removeTile
                    )
                } moveAction: { from, to in
                    layout.move(fromOffsets: from, toOffset: to)
                }
                
                Spacer()
                
                DashboardToolbar(isEditing: $isEditing, showTileSheet: $showTileSheet)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.isEditing.toggle()
                    }) {
                        Label("Edit Dashboard", systemImage: "slider.horizontal.2.square.on.square")
                    }
                    .foregroundColor(Color(.systemBlue))
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Settings()) {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }
            .background(Color(.systemGray6))
            .sheet(isPresented: $showTileSheet) {
                TileSheet(
                    activeTileIds: $activeTileIds,
                    addTile: addTile,
                    showTileSheet: $showTileSheet
                )
            }
        }
    }
}