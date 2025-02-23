//
//  RatingView.swift
//  Snowboard Scribe
//
//  Created by Ben Hofbauer on 2/23/25.
//

import SwiftUI

enum Rating:String, CaseIterable, Codable {
    case green
    case blue
    case black
    case double
    
    var color: Color {
        switch self {
        case .green: return Color.green
        case .blue: return Color.blue
        case .black, .double: return Color.black
        }
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let topPoint = CGPoint(x: rect.midX, y: rect.minY)
        let bottomPoint = CGPoint(x: rect.midX, y: rect.maxY)
        let leftPoint = CGPoint(x: rect.minX + 0.1 * rect.maxX, y: rect.midY)
        let rightPoint = CGPoint(x: 0.9 * rect.maxX, y: rect.midY)
        
        path.move(to: topPoint)
        path.addLine(to: leftPoint)
        path.addLine(to: bottomPoint)
        path.addLine(to: rightPoint)
        path.closeSubpath()

        return path
    }
}

struct DoubleDiamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let fTopPoint = CGPoint(x: rect.midX * 0.5, y: rect.minY)
        let fBottomPoint = CGPoint(x: rect.midX * 0.5, y: rect.maxY)
        let fLeftPoint = CGPoint(x: rect.minX, y: rect.midY)
        let fRightPoint = CGPoint(x: rect.midX, y: rect.midY)
        
        let sTopPoint = CGPoint(x: rect.maxX * 0.75, y: rect.minY)
        let sBottomPoint = CGPoint(x: rect.maxX * 0.75, y: rect.maxY)
        let sRightPoint = CGPoint(x: rect.maxX, y: rect.midY)
        
        path.move(to: fTopPoint)
        path.addLine(to: fLeftPoint)
        path.addLine(to: fBottomPoint)
        path.addLine(to: fRightPoint)
        path.closeSubpath()
        
        path.move(to: sTopPoint)
        path.addLine(to: fRightPoint)
        path.addLine(to: sBottomPoint)
        path.addLine(to: sRightPoint)
        path.closeSubpath()
        
        return path
    }
}

@available(iOS 17, *)
struct RatingView: View {
    @Bindable var trail: Trail
    var dimension: CGFloat = 20
    var paddingDimension: CGFloat = 10
    
    func choose(_ color:String) {
        if color == "g" {
            if trail.rating != Rating.green {
                trail.rating = Rating.green
            }
        }
        
        else if color == "b" {
            if trail.rating != Rating.blue {
                trail.rating = Rating.blue
            }
        }
        
        else if color == "bla" {
            if trail.rating != Rating.black {
                trail.rating = Rating.black
            }
        }
        
        else if color == "db" {
            if trail.rating != Rating.double {
                trail.rating = Rating.double
            }
        }
    }
    
    var body: some View {
        HStack {
            Button(action: {choose("g")}) {
                if trail.rating == Rating.green {
                    Circle()
                        .frame(width:dimension)
                        .foregroundStyle(.green)
                        .padding(paddingDimension)
                        .background(.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: CGFloat(15.0)))
                } else {
                    Circle()
                        .frame(width:dimension)
                        .foregroundStyle(.green)
                        .padding(paddingDimension)
                }
            }
            .buttonStyle(.plain)
            
            Button(action: {choose("b")}) {
                if trail.rating == Rating.blue {
                    Rectangle()
                        .frame(width: dimension, height: dimension)
                        .foregroundStyle(.blue)
                        .padding(paddingDimension)
                        .background(.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: CGFloat(15.0)))
                } else {
                    Rectangle()
                        .frame(width: dimension, height: dimension)
                        .foregroundStyle(.blue)
                        .padding(paddingDimension)
                }
            }
            .buttonStyle(.plain)
            
            Button(action: {choose("bla")}) {
                if trail.rating == Rating.black {
                    Diamond()
                        .frame(width: dimension, height: dimension)
                        .foregroundStyle(.black)
                        .padding(paddingDimension)
                        .background(.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: CGFloat(15.0)))
                } else {
                    Diamond()
                        .frame(width: dimension, height: dimension)
                        .foregroundStyle(.black)
                        .padding(paddingDimension)
                }
            }
            .buttonStyle(.plain)
            
            Button(action: {choose("db")}) {
                if trail.rating == Rating.double {
                    DoubleDiamond()
                        .frame(width: dimension, height: dimension)
                        .foregroundStyle(.black)
                        .padding(paddingDimension)
                        .background(.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: CGFloat(15.0)))
                } else {
                    DoubleDiamond()
                        .frame(width: dimension, height: dimension)
                        .foregroundStyle(.black)
                        .padding(paddingDimension)
                }
            }
            .buttonStyle(.plain)
                
        }
    }
}

#Preview {
    if #available(iOS 17, *) {
        RatingView(trail: Trail(date: Date.now, rating: Rating.green, enjoyment: 0.0, name: ""))
    } else {
        // Fallback on earlier versions
    }
}
