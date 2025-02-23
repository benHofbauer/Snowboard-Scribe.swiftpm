//
//  SwiftUIView.swift
//  Snowboard Scribe
//
//  Created by Ben Hofbauer on 2/23/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct DayView: View {
    @Environment(\.modelContext) private var modelContext
    @State var expanded: Bool = true
    var rides:[Trail]
    var day:String
    
    var body: some View {
        Section("\(day)", isExpanded: $expanded) {
            ForEach(rides) { trail in
                NavigationLink {
                    TrailView(trail: trail, trailNo: 0, editing: true)
                } label: {
                    HStack {
                        Text(trail.name)
                        Spacer()
                        Text("\(Int(trail.enjoyment))/10")
                        Symbol(rating: trail.rating, paddingDimension: CGFloat(15), dimension: CGFloat(20))
                    }
                }
            }
            .onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(rides[index])
        }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        List {
            DayView(rides: [Trail(date: Date.now, rating: Rating.green, enjoyment: 0.0, name: ""),
                            Trail(date: Date.now, rating: Rating.green, enjoyment: 0.0, name: "")],
                    day: "Feb")
        }
        .listStyle(.sidebar)
    } else {
        // Fallback on earlier versions
    }
}
