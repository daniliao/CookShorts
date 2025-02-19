# Detailed Development Notes

## Hi Linda:D [This video from Google](https://youtu.be/eipyWlJQExg?si=Xxbm_91OveWO8bwe) shows how to build a swift app with Gemini


<img width="500" alt="Screenshot 2025-02-17 at 10 02 26 AM" src="https://github.com/user-attachments/assets/e0c5c1e4-9391-4824-83be-604233fb54f4" />
<img src="https://media.giphy.com/media/p5jIRzm2N2oCRMnfm4/giphy.gif" width="200" height="434">

## Get YouTube Transcript

### Get Transcript by passing videoID to fetchTranscript(videoID: videoID)
```swift
func fetchTranscript() {
            let videoID = "5WBuk8MLkv0"
            isLoading = true
            isError = false
            
            fetchTranscript(videoID: videoID) { result in
                DispatchQueue.main.async {
                    isLoading = false
                }
                
                switch result {
                case .success(let newTranscript):
                    DispatchQueue.main.async {
                        transcript = newTranscript
                        onSummarizeTapped() // If successfully got transcript, send it to gemini
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        isError = true
                        transcript = "Error: \(error.localizedDescription)"
                    }
                }
            }
        }
```
TODO: Modify 'videoID' when YouTube Search API result is working

### Request transcript from local hosted server using <a href="https://github.com/daniliao/getTranscriptServer" target="_blank">getTranscriptServer</a>

Send request to http://127.0.0.1:8000/transcript

Converts JSON into array of dictionaries and joins them with spaces " " in between 

```swift
func fetchTranscript(videoID: String, completion: @escaping (Result<String, Error>) -> Void) {
            let urlString = "http://127.0.0.1:8000/transcript?video_id=\(videoID)"
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let transcript = json?["transcript"] as? [[String: Any]] {
                        let fullTranscript = transcript.compactMap { $0["text"] as? String }.joined(separator: " ")
                        completion(.success(fullTranscript))
                    } else {
                        completion(.failure(NSError(domain: "Parsing error", code: 0, userInfo: nil)))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
```

## Use Gemini API to summarize transcript into ingredients and instructions

### Send transcript to from ContentView.swift to SummarizeViewModel.swift

```swift
func onSummarizeTapped() {
            Task {
                await viewModel.summarize(transcript: transcript)
            }
        }
```

### Prompt gemini to get ingredients and instructions @ SummarizeViewModel.swift

```swift
let prompt = "Summarize the following YouTube recipe transcript into two sections: Ingredients and Instructions. The Ingredients section should list all ingredients with their quantities, formatted as bullet points. The Instructions section should be numbered, with each step describing the cooking process in a concise manner:  \(transcript)"

      let outputContentStream = model.generateContentStream(prompt)

      // stream response
      for try await outputContent in outputContentStream {
        guard let line = outputContent.text else {
          return
        }
```


