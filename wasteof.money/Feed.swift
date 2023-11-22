//
//  Feed.swift
//  wasteof.money
//
//  Created by Oren Lindsey on 10/25/23.
//

import SwiftUI
//let username = "oren"
/*struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}*/
struct ApiError: Hashable, Codable {
    let error: String
}
class FeedType: Hashable, Codable {
    static func == (lhs: FeedType, rhs: FeedType) -> Bool {
        return lhs.posts == rhs.posts && lhs.last == rhs.last
    }
    
    var posts: [PostType]
    var last: Bool
    init() {
        self.posts = []
        self.last = true
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(posts)
        hasher.combine(last)
    }
}
class FeedObject: ObservableObject {
    @Published var posts: [PostType]
    @Published var last: Bool
    init() {
            self.posts = []
            self.last = true
        }
}
/*struct PostType: Hashable, Codable {
    let _id: String
    let content: String
    let time: Int
    let comments: Int
    let loves: Int
    let reposts: Int
    let poster: Poster
    let revisions: [Revision]
    let edited: Optional<Int>
}*/
class PostType: Hashable, Codable, Equatable {
    var _id: String
    var content: String
    var time: Int
    var comments: Int
    var loves: Int
    var reposts: Int
    var poster: Poster
    var revisions: [Revision]
    var edited: Optional<Int>
    var repost: Optional<PostType>
    init() {
        self._id = ""
        self.content = ""
        self.time = 0
        self.comments = 0
        self.loves = 0
        self.reposts = 0
        self.poster = Poster(name: "", id: "", color: "")
        self.revisions = []
        self.edited = nil
        self.repost = nil
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
        hasher.combine(content)
        hasher.combine(time)
        hasher.combine(comments)
        hasher.combine(loves)
        hasher.combine(reposts)
        hasher.combine(poster)
        hasher.combine(revisions)
        hasher.combine(edited)
        hasher.combine(repost)
    }
    static func ==(lhs: PostType, rhs: PostType) -> Bool {
        return lhs._id == rhs._id && lhs.content == rhs.content && lhs.time == rhs.time && lhs.comments == rhs.comments && lhs.loves == rhs.loves && lhs.reposts == rhs.reposts && lhs.revisions == rhs.revisions && lhs.edited == rhs.edited && lhs.repost == rhs.repost
    }
}
struct Feed: View {
    @State var page = 1
    @State var errorData: ApiError = ApiError(error: "")
    @StateObject var feed: FeedObject = FeedObject()
    @EnvironmentObject var session: Session
    //@EnvironmentObject var session : SessionObject
    //@FetchRequest(sortDescriptors: [SortDescriptor(from: \.name)]) var languages: FetchedResults<Session>
    //var session
    //let name = UserDefaults.defaults.string(forKey:"username")
    //@State private var scrollPosition: CGPoint = .zero
    func fetchFeed(user: String, add: Bool, page: Int) {
        guard let url = URL(string: "https://api.wasteof.money/users/\(user)/following/posts?page=\(page)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("error with the data: \(error!)")
                return
            }
            do {
                let api = try JSONDecoder().decode(FeedType.self, from:data)
                DispatchQueue.main.async {
                    if add {
                        feed.last = api.last
                        feed.posts += api.posts
                    } else {
                        feed.posts = api.posts
                        feed.last = api.last
                    }
                    errorData = ApiError(error: "")
                }
            } catch {
                print("error decoding: \(error)")
                do {
                    let apierror = try JSONDecoder().decode(ApiError.self, from:data)
                    print("api error: \(apierror)")
                    DispatchQueue.main.async {
                        errorData = apierror
                    }
                } catch {
                    print("error decoding 2: \(error)")
                    print(String(bytes: data, encoding: .utf8)!)
                }
            }
        }
        //print("fetching")
        task.resume()
    }
    var body: some View {
        //ScrollView {
        /*HStack {
            Text("Feed")
                .font(.largeTitle)
                .padding([.horizontal])
            Spacer()
        }*/
        if (feed.posts.count < 1) {
            ProgressView().onAppear {
                fetchFeed(user: session.username, add: false, page: 1)
            }
        } else {
            let feedposts = feed.posts
            /*LazyVGrid(columns: layout) {
             ForEach(viewModel.feed.posts.indices, id: \.self) { i in
             PostPreview(_id: feedposts[i]._id, content: feedposts[i].content, time: feedposts[i].time, comments: feedposts[i].comments, loves: feedposts[i].loves, reposts: feedposts[i].reposts, poster: Poster(name: feedposts[i].poster.name, id: feedposts[i].poster.id), revisions: feedposts[i].revisions, edited: feedposts[i].edited)
             }
             }*/
            /*PostPreview(_id: feedposts[i]._id, content: feedposts[i].content, time: feedposts[i].time, comments: feedposts[i].comments, loves: feedposts[i].loves, reposts: feedposts[i].reposts, poster: Poster(name: feedposts[i].poster.name, id: feedposts[i].poster.id), revisions: feedposts[i].revisions, edited: feedposts[i].edited)
             //.padding([.horizontal], 16)*/
            NavigationStack {
                ScrollView {
                    /*HStack {
                        Text("@\(session.username)'s Feed")
                            .font(.largeTitle)
                            .padding([.horizontal])
                        Spacer()
                    }*/
                    ForEach(feed.posts.indices, id: \.self) { i in
                        /*if i == feedposts.count - 1 {
                            NavigationLink {
                                Post(_id: feedposts[i]._id, content: feedposts[i].content, time: feedposts[i].time, comments: feedposts[i].comments, loves: feedposts[i].loves, reposts: feedposts[i].reposts, poster: Poster(name: feedposts[i].poster.name, id: feedposts[i].poster.id, color: feedposts[i].poster.color), revisions: feedposts[i].revisions, edited: feedposts[i].edited).environmentObject(session)
                            } label: {
                                PostPreview(_id: feedposts[i]._id, content: feedposts[i].content, time: feedposts[i].time, comments: feedposts[i].comments, loves: feedposts[i].loves, reposts: feedposts[i].reposts, poster: Poster(name: feedposts[i].poster.name, id: feedposts[i].poster.id, color: feedposts[i].poster.color), revisions: feedposts[i].revisions, edited: feedposts[i].edited)
                                    .environmentObject(session)
                            }.padding()
                        } else {*/
                            NavigationLink {
                                Post(commentsState: CommentsObject(), _id: feedposts[i]._id, content: feedposts[i].content, time: feedposts[i].time, comments: feedposts[i].comments, loves: feedposts[i].loves, reposts: feedposts[i].reposts, poster: Poster(name: feedposts[i].poster.name, id: feedposts[i].poster.id, color: feedposts[i].poster.color), revisions: feedposts[i].revisions, edited: feedposts[i].edited, repost: feedposts[i].repost).padding([.horizontal], 5).environmentObject(session).navigationTitle("Post by @\(feedposts[i].poster.name)")
                            } label: {
                                PostPreview(_id: feedposts[i]._id, content: feedposts[i].content, time: feedposts[i].time, comments: feedposts[i].comments, loves: feedposts[i].loves, reposts: feedposts[i].reposts, poster: Poster(name: feedposts[i].poster.name, id: feedposts[i].poster.id, color: feedposts[i].poster.color), revisions: feedposts[i].revisions, edited: feedposts[i].edited, repost: feedposts[i].repost, navigation: true, recursion: 1).environmentObject(session).frame(minHeight: 100)
                            }
                        //}
                    }
                    Button {
                        page += 1
                        fetchFeed(user: session.username, add:true, page: page)
                    } label: {
                        Text("Show more")
                    }.buttonStyle(.bordered).tint(.accentColor)
                }.padding([.horizontal], 5).navigationTitle("@\(session.username)'s Feed")
            }.padding([.top]).ignoresSafeArea(.all, edges: [.top]).refreshable {
                fetchFeed(user: session.username, add: false, page: 1)
            }
        }/*.coordinateSpace(name: "scroll").background(GeometryReader { geometry in
              Color.clear
              .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
              })
              .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
              self.scrollPosition = value
              }.onChange(of:scrollPosition) { value in
              print(value.x)
              }*/
             
        }
    }

/*#Preview {
    Feed(errorData: ApiError(error: ""), name: "oren")
}*/
