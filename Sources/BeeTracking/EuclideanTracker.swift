import SwiftFusion
import TensorFlow


// let trackWithEuclidean: Tracker = { frames, start 
//     // var centroids: [Vector2] = []
//     // // Some bounding box / centroid generator
//     // // CNN, Filter, etc.
//     // // centroids = getBoundingBoxes(frames).map{$0.center}

//     // // prediction: [OrientedBoundingBox]
//     // return prediction
// }


public struct EuclideanTracker {

    public let frames: [Tensor<Float>]
    public let objectDetector: Encoder
    public let patchSize: (Int, Int)

    public init (frames: [Tensor<Float>], objectDetector: Encoder, patchSize: (Int, Int)) 
    {
        self.frames = frames
        self.objectDetector = objectDetector
        self.patchSize = patchSize
    }

    public func runEuclideanTracker(start: Pose2) -> Pose2 {//[OrientedBoundingBox] {
        return Pose2(Rot2(0.0), Vector2(0.0, 0.0))
    }

}