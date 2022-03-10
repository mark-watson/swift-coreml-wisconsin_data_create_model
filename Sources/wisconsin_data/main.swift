import Foundation
import CoreML
import CreateML

func create_model() {
    if #available(macOS 10.14, *) {
        let fileUrl = URL(fileURLWithPath: "labeled_cancer_data.csv")
        print(fileUrl)
        if let dataTable = try? MLDataTable(contentsOf: fileUrl) {
            //print(dataTable)
            let regressorColumns = ["Cl.thickness", "Cell.size", "Cell.shape", "Marg.adhesion",
                                    "Epith.c.size", "Bare.nuclei", "Bl.cromatin", "Normal.nucleoli",
                                    "Mitoses", "Class"]
            
            // Classifier:
            let classifierTable = dataTable[regressorColumns]
            let (classifierEvaluationTable, classifierTrainingTable) = classifierTable.randomSplit(by: 0.20, seed: 5)
            let classifier = try! MLClassifier(trainingData: classifierTrainingTable,
                                              targetColumn: "Class")
            print("++ classifier.description:", classifier)
            /// Classifier training accuracy as a percentage
            let trainingError = classifier.trainingMetrics.classificationError
            let trainingAccuracy = (1.0 - trainingError) * 100
            print("trainingAccuracy:", trainingAccuracy)
            
            /// Classifier validation accuracy as a percentage
            let validationError = classifier.validationMetrics.classificationError
            print("validationError:", validationError)
            let validationAccuracy = (1.0 - validationError) * 100
            print("validationAccuracy:", validationAccuracy)
            /// Evaluate the classifier
            let classifierEvaluation = classifier.evaluation(on: classifierEvaluationTable)
            
            /// Classifier evaluation accuracy as a percentage
            let evaluationError = classifierEvaluation.classificationError
            print("evaluationError:", evaluationError)
            let evaluationAccuracy = (1.0 - evaluationError) * 100
            print("evaluationAccuracy:", evaluationAccuracy)
            
            let classifierMetadata = MLModelMetadata(author: "Mark Watson",
                                                     shortDescription: "Wisconsin Cancer Dataset",
                                                     version: "1.0")
            
            /// Save the trained classifier model to the Desktop.
            let _ =  try? classifier.write(to: URL(fileURLWithPath: "Sources/wisconsin_data/wisconsin.mlmodel"),
                                           metadata: classifierMetadata)
        }
    }
}

create_model()
