# Detailed Development Notes

<img width="500" alt="Screenshot 2025-02-17 at 10 02 26 AM" src="https://github.com/user-attachments/assets/e0c5c1e4-9391-4824-83be-604233fb54f4" />
<img src="https://media.giphy.com/media/p5jIRzm2N2oCRMnfm4/giphy.gif" width="200" height="434">

## Get YouTube Transcript

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
                        onSummarizeTapped()
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

## Use Gemini API to make recipe | Ingredients and Instructions

### Send transcript to SummarizeViewModel.swift for Gemini

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
```


