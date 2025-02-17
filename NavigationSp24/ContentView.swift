import SwiftUI
import WebKit
import GoogleGenerativeAI
import MarkdownUI

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct ContentView: View {
    @StateObject var viewModel = SummarizeViewModel()
    @State var transcript: String = ""
    @State private var path = NavigationPath()
    @State private var isLoading: Bool = false
    @State private var isError: Bool = false
    
    var body: some View {
        NavigationStack(path: $path) {
            
            
            ScrollView(.horizontal) {
                HStack{
                    let vid1 = URL(string: "https://www.youtube.com/embed/ZNIiewyOHSI?autoplay=1&controls=1")!
                    
                    WebView(url: vid1)
                        .frame(width: 168.75, height: 300)
                    
                    let vid2 = URL(string: "https://youtube.com/embed/3zJxc1jYkok?si=daHBwdP324Z_TOpG?autoplay=1&controls=1")!
                    
                    WebView(url: vid2)
                        .frame(width: 168.75, height: 300)
                    
                    let vid3 = URL(string: "https://youtube.com/embed/I-x1NnvfNxY?si=tAHVUd5BIwxCqeWU?autoplay=1&controls=1")!
                    
                    WebView(url: vid3)
                        .frame(width: 168.75, height: 300)
                    
                    let vid4 = URL(string: "https://youtube.com/embed/cgzGUQpIhyg?si=2utbwRpZ3t1RiE5a?autoplay=1&controls=1")!
                    
                    WebView(url: vid4)
                        .frame(width: 168.75, height: 300)
                }
            }
            VStack {
                if isLoading {
                    Text("Loading transcript...")
                        .padding()
                        .font(.body)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                } else if isError {
                    Text("Error fetching transcript")
                        .padding()
                        .font(.body)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                } else {
                    Markdown("\(viewModel.outputText)")
                        .padding()
                        .font(.body)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                
                Button(action: fetchTranscript) {
                    Text("Fetch Transcript")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
        
        func onSummarizeTapped() {
            Task {
                await viewModel.summarize(transcript: transcript)
            }
        }
        
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
    }





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

