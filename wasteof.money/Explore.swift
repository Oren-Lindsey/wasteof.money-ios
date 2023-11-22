//
//  Explore.swift
//  wasteof.money
//
//  Created by Oren Lindsey on 10/26/23.
//

import SwiftUI
class ExploreObject: ObservableObject {
    @Published var posts: [ExplorePostType]
    @Published var since: String
    init() {
            self.posts = []
            self.since = ""
        }
}
class ExploreType: Hashable, Codable {
    static func == (lhs: ExploreType, rhs: ExploreType) -> Bool {
        return lhs.posts == rhs.posts && lhs.since == rhs.since
    }
    var posts: [ExplorePostType]
    var since: String
    func hash(into hasher: inout Hasher) {
        hasher.combine(posts)
        hasher.combine(since)
    }
}
class ExplorePostType: Hashable, Codable {
    static func == (lhs: ExplorePostType, rhs: ExplorePostType) -> Bool {
        return lhs._id == rhs._id && lhs.content == rhs.content && lhs.time == rhs.time && rhs.__order == lhs.__order && lhs.comments == rhs.comments && lhs.loves == rhs.loves && lhs.reposts == rhs.reposts && lhs.poster == rhs.poster && lhs.revisions == rhs.revisions && lhs.edited == rhs.edited && lhs.repost == rhs.repost
    }
    let _id: String
    let content: String
    let time: Int
    let __order: Int
    let comments: Int
    let loves: Int
    let reposts: Int
    let poster: Poster
    let revisions: [Revision]
    let edited: Optional<Int>
    let repost: Optional<PostType>
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
        hasher.combine(content)
        hasher.combine(time)
        hasher.combine(__order)
        hasher.combine(comments)
        hasher.combine(loves)
        hasher.combine(reposts)
        hasher.combine(poster)
        hasher.combine(revisions)
        hasher.combine(edited)
        hasher.combine(repost)
    }
}
struct ExploreUser: Hashable, Codable {
    let name: String
    let id: String
    let bio: String
    let verified: Bool
    let beta: Bool
    let permissions: Permissions
    let links: [Link]
    let history: History
    let stats: ExploreStats
    let color: String
}
struct Permissions: Hashable, Codable {
    let admin: Bool
    let banned: Bool
}
struct Link: Hashable, Codable {
    let label: String
    let url: String
}
class ExploreUsersObject: ObservableObject {
    @Published var users: [ExploreUser]
    init() {
            self.users = []
        }
}
//struct ExploreUsers: Hashable, Codable [ExploreUser]
struct ExploreStats: Hashable, Codable {
    let followers: Int
}
struct History: Hashable, Codable {
    let joined: Int
}
struct Explore: View {
    let timeframeOptions = ["day", "week", "month", "all"]
    @State private var selection = "day"
    @EnvironmentObject var session: Session
    @StateObject var explore: ExploreObject = ExploreObject()
    @StateObject var exploreusers: ExploreUsersObject = ExploreUsersObject()
    var body: some View {
        NavigationStack {
            ScrollView {
                /*HStack {
                    Text("Explore")
                        .font(.largeTitle)
                        .padding([.horizontal])
                    Spacer()
                    /*Picker("Select a timeframe", selection: $selection) {
                     ForEach(timeframeOptions, id: \.self) {
                     Text($0)
                     }.onReceive {
                     self.viewmodel.fetchExplore(timeframe: self.selection)
                     }
                     }*/
                    Text("Sort: \(selection)")
                        .onChange(of: selection) {
                            fetchExplore(timeframe: selection.lowercased())
                        }
                    Menu {
                        //ForEach(timeframeOptions, id: \.self) {
                        //Text($0)
                        /*Button(action: viewModel.fetchExplore(timeframe: $0)) {
                         Label($0)
                         }*/
                        Picker("Select a timeframe", selection: $selection) {
                            ForEach(timeframeOptions, id: \.self) {
                                /*Text($0)
                                 }*/
                                Text($0)
                            }
                        }
                        //}
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .padding([.trailing])
                    }
                }*/
                if (explore.posts.count < 1) {
                    ProgressView()
                } else {
                    HStack {
                        Text("Top Posts")
                            .padding([.horizontal])
                            .font(.title2)
                        Spacer()
                    }
                    /*LazyVGrid(columns: layout) {
                     ForEach(viewModel.feed.posts.indices, id: \.self) { i in
                     PostPreview(_id: feedposts[i]._id, content: feedposts[i].content, time: feedposts[i].time, comments: feedposts[i].comments, loves: feedposts[i].loves, reposts: feedposts[i].reposts, poster: Poster(name: feedposts[i].poster.name, id: feedposts[i].poster.id), revisions: feedposts[i].revisions, edited: feedposts[i].edited)
                     }
                     }*/
                    /*PostPreview(_id: feedposts[i]._id, content: feedposts[i].content, time: feedposts[i].time, comments: feedposts[i].comments, loves: feedposts[i].loves, reposts: feedposts[i].reposts, poster: Poster(name: feedposts[i].poster.name, id: feedposts[i].poster.id), revisions: feedposts[i].revisions, edited: feedposts[i].edited)
                     //.padding([.horizontal], 16)*/
                    ForEach(explore.posts.indices, id: \.self) { i in
                        /*if i == exploreposts.count - 1 {
                         PostPreview(_id: exploreposts[i]._id, content: exploreposts[i].content, time: exploreposts[i].time, comments: exploreposts[i].comments, loves: exploreposts[i].loves, reposts: exploreposts[i].reposts, poster: Poster(name: exploreposts[i].poster.name, id: exploreposts[i].poster.id, color: exploreposts[i].poster.color), revisions: exploreposts[i].revisions, edited: exploreposts[i].edited)
                         } else {
                         PostPreview(_id: exploreposts[i]._id, content: exploreposts[i].content, time: exploreposts[i].time, comments: exploreposts[i].comments, loves: exploreposts[i].loves, reposts: exploreposts[i].reposts, poster: Poster(name: exploreposts[i].poster.name, id: exploreposts[i].poster.id, color: exploreposts[i].poster.color), revisions: exploreposts[i].revisions, edited: exploreposts[i].edited)//.padding([.horizontal], 16)
                         }*/
                        NavigationLink {
                            Post(commentsState: CommentsObject(), _id: explore.posts[i]._id, content: explore.posts[i].content, time: explore.posts[i].time, comments: explore.posts[i].comments, loves: explore.posts[i].loves, reposts: explore.posts[i].reposts, poster: explore.posts[i].poster, revisions: explore.posts[i].revisions, repost: explore.posts[i].repost)
                        } label: {
                            PostPreview(_id: explore.posts[i]._id, content: explore.posts[i].content, time: explore.posts[i].time, comments: explore.posts[i].comments, loves: explore.posts[i].loves, reposts: explore.posts[i].reposts, poster: Poster(name: explore.posts[i].poster.name, id: explore.posts[i].poster.id, color: explore.posts[i].poster.color), revisions: explore.posts[i].revisions, edited: explore.posts[i].edited, repost: explore.posts[i].repost, navigation: true, recursion: 1).environmentObject(session).frame(minHeight: 100)
                        }
                    }.padding([.horizontal], 8)
                }
                
                if (exploreusers.users.count < 1) {
                    EmptyView()
                } else {
                    HStack {
                        Text("Top Users")
                            .padding([.horizontal])
                            .font(.title2)
                        Spacer()
                    }
                    let exploreusers = exploreusers
                    /*LazyVGrid(columns: layout) {
                     ForEach(viewModel.feed.posts.indices, id: \.self) { i in
                     PostPreview(_id: feedposts[i]._id, content: feedposts[i].content, time: feedposts[i].time, comments: feedposts[i].comments, loves: feedposts[i].loves, reposts: feedposts[i].reposts, poster: Poster(name: feedposts[i].poster.name, id: feedposts[i].poster.id), revisions: feedposts[i].revisions, edited: feedposts[i].edited)
                     }
                     }*/
                    /*PostPreview(_id: feedposts[i]._id, content: feedposts[i].content, time: feedposts[i].time, comments: feedposts[i].comments, loves: feedposts[i].loves, reposts: feedposts[i].reposts, poster: Poster(name: feedposts[i].poster.name, id: feedposts[i].poster.id), revisions: feedposts[i].revisions, edited: feedposts[i].edited)
                     //.padding([.horizontal], 16)*/
                    //List {
                    VStack {
                        ForEach(exploreusers.users.indices, id: \.self) { i in
                            if i == exploreusers.users.count - 1 {
                                UserPreview(name: exploreusers.users[i].name, id: exploreusers.users[i].id, bio: exploreusers.users[i].bio, verified: exploreusers.users[i].verified, beta: exploreusers.users[i].beta, permissions: exploreusers.users[i].permissions, links: exploreusers.users[i].links, history: exploreusers.users[i].history, stats: exploreusers.users[i].stats, color: exploreusers.users[i].color)
                                    .padding([.bottom], 96)
                            } else {
                                UserPreview(name: exploreusers.users[i].name, id: exploreusers.users[i].id, bio: exploreusers.users[i].bio, verified: exploreusers.users[i].verified, beta: exploreusers.users[i].beta, permissions: exploreusers.users[i].permissions, links: exploreusers.users[i].links, history: exploreusers.users[i].history, stats: exploreusers.users[i].stats, color: exploreusers.users[i].color)//.padding([.horizontal], 16)
                            }
                        }
                    }.padding([.horizontal], 8)
                }
            }.onAppear {
                fetchExplore(timeframe: selection)
                fetchUsers()
            }.ignoresSafeArea(.all, edges: [.bottom, .horizontal]).refreshable {
                fetchExplore(timeframe: selection)
                fetchUsers()
            }.navigationTitle("Explore").toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Menu {
                        //ForEach(timeframeOptions, id: \.self) {
                        //Text($0)
                        /*Button(action: viewModel.fetchExplore(timeframe: $0)) {
                         Label($0)
                         }*/
                        Picker("Select a timeframe", selection: $selection) {
                            ForEach(timeframeOptions, id: \.self) {
                                /*Text($0)
                                 }*/
                                Text($0)
                            }
                        }
                        //}
                    } label: {
                        Label("Sort", systemImage: "line.3.horizontal.decrease.circle.fill")
                    }.onChange(of: selection) {
                        fetchExplore(timeframe: selection.lowercased())
                    }
                }
            }
        }
    }
    func fetchExplore(timeframe: String) {
        guard let url = URL(string: "https://api.wasteof.money/explore/posts/trending?timeframe=\(timeframe)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print(error!)
                return
            }
            do {
                DispatchQueue.main.async {
                    self.explore.posts = []
                }
                let api = try JSONDecoder().decode(ExploreType.self, from:data)
                DispatchQueue.main.async {
                    /*if add {
                        self?.feed.last = api.last
                        self?.feed.posts += api.posts
                    } else {
                        self?.feed = api
                    }*/
                    self.explore.posts = api.posts
                    self.explore.since = api.since
                }
            } catch {
                print(error)
                do {
                    let apierror = try JSONDecoder().decode(ApiError.self, from:data)
                    print(apierror.error)
                } catch {
                    print(error)
                    print(String(bytes: data, encoding: .utf8)!)
                }
            }
        }
        task.resume()
    }
    func fetchUsers() {
        //feed = FeedType(posts: [], last: false)
        guard let url = URL(string: "https://api.wasteof.money/explore/users/top") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print(error!)
                return
            }
            do {
                let api = try JSONDecoder().decode([ExploreUser].self, from:data)
                DispatchQueue.main.async {
                    /*if add {
                        self?.feed.last = api.last
                        self?.feed.posts += api.posts
                    } else {
                        self?.feed = api
                    }*/
                    self.exploreusers.users = api
                    //print(api)
                }
            } catch {
                print(error)
                do {
                    let apierror = try JSONDecoder().decode(ApiError.self, from:data)
                    print(apierror.error)
                } catch {
                    print(error)
                    print(String(bytes: data, encoding: .utf8)!)
                }
            }
        }
        task.resume()
    }
}
/*#Preview {
    Explore()
}*/
