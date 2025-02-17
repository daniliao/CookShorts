//
//  SummarizeViewModel.swift
//  NavigationSp24
//
//  Created by Daniel on 2/16/25.
//

// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import GoogleGenerativeAI
import OSLog

@MainActor
class SummarizeViewModel: ObservableObject {
  private var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "generative-ai")

  @Published
  var outputText = ""

  @Published
  var errorMessage: String?

  @Published
  var inProgress = false

  private var model: GenerativeModel?

  init() {
    model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: APIKey.default)
  }

  func summarize(transcript: String) async {
    defer {
      inProgress = false
    }
    guard let model else {
      return
    }

    do {
      inProgress = true
      errorMessage = nil
      outputText = ""
      print("Transcript: \(transcript)")
        
      guard !transcript.isEmpty else {
          errorMessage = "Transcript is empty. Please try fetching again."
          return
      }

      let prompt = "Summarize the following YouTube recipe transcript into two sections: Ingredients and Instructions. The Ingredients section should list all ingredients with their quantities, formatted as bullet points. The Instructions section should be numbered, with each step describing the cooking process in a concise manner:  \(transcript)"

      let outputContentStream = model.generateContentStream(prompt)

      // stream response
      for try await outputContent in outputContentStream {
        guard let line = outputContent.text else {
          return
        }

        outputText = outputText + line
      }
    } catch {
      logger.error("\(error.localizedDescription)")
      errorMessage = error.localizedDescription
    }
  }
}
