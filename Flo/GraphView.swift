//
//  GraphView.swift
//  Flo
//
//  Created by CPU11808 on 4/17/17.
//  Copyright © 2017 CPU11808. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {
    

    @IBInspectable var startColor: UIColor = UIColor(colorLiteralRed: 250.0/255,
                                                     green: 233.0/255,
                                                     blue: 222.0/255,
                                                     alpha: 1.0)
    @IBInspectable var endColor: UIColor = UIColor(colorLiteralRed: 252.0/255,
                                                   green: 79.0/255,
                                                   blue: 8.0/255,
                                                   alpha: 1.0)
    
    //Weekly sample data
    var graphPoints:[Int] = [4, 2, 6, 4, 5, 8, 3]
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        var path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: UIRectCorner.allCorners,
                                cornerRadii: CGSize(width: 8.0, height: 8.0))
        path.addClip()
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)
        
        var startPoint = CGPoint.zero
        var endPoint  = CGPoint(x:0, y:rect.height)
        context?.drawLinearGradient(gradient!,
                                    start: startPoint,
                                    end: endPoint,
                                    options: CGGradientDrawingOptions(rawValue: 0))
        
        let margin:CGFloat = 20.0
        let columnXPoint = { (column:Int) -> CGFloat in
            //Calculate gap between points
            let spacer = (width - margin*2 - 4) /
                CGFloat((self.graphPoints.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = maxElement(graphPoints)
        let columnYPoint = { (graphPoint:Int) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            y = graphHeight + topBorder - y
            return y
        }
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        var graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x:columnXPoint(0),
                                   y:columnYPoint(graphPoints[0])))
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x:columnXPoint(i),
                                    y:columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        //graphPath.stroke()
        context?.saveGState()
        
        var clippingPath = graphPath.copy() as! UIBezierPath
        clippingPath.addLine(to: CGPoint(
            x: columnXPoint(graphPoints.count - 1),
            y:height))
        clippingPath.addLine(to: CGPoint(
            x:columnXPoint(0),
            y:height))
        clippingPath.close()
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue)
        startPoint = CGPoint(x:margin, y: highestYPoint)
        endPoint = CGPoint(x:margin, y:self.bounds.height)
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        context?.restoreGState()
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        //Draw the circles on top of graph stroke
        for i in 0..<graphPoints.count {
            var point = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalIn:
                CGRect(origin: point,
                       size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
        
        //Draw horizontal graph lines on the top of everything
        var linePath = UIBezierPath()
        
        //top line
        linePath.move(to: CGPoint(x:margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin,
                                        y:topBorder))
        
        //center line
        linePath.move(to: CGPoint(x:margin,
                                     y: graphHeight/2 + topBorder))
        linePath.addLine(to: CGPoint(x:width - margin,
                                        y:graphHeight/2 + topBorder))
        
        //bottom line
        linePath.move(to: CGPoint(x:margin,
                                     y:height - bottomBorder))
        linePath.addLine(to: CGPoint(x:width - margin,
                                        y:height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
    }
    
    func maxElement(_ array: Array<Int>) -> (Int) {
        return 8
    }
    

}
