// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedBlog {
    // State variables
    address public owner;
    Post[] public posts;

    // Events
    event NewPost(address indexed author, string title, uint256 creationTime);
    event UpdatePost(address indexed author, uint256 indexed index, string newTitle, string newContent, uint256 lastUpdateTime);
    event DeletePost(address indexed author, uint256 indexed index);
    event ShareOnExternalPlatform(address indexed author, string title, string externalPlatform);

    // Struct for representing a blog post
    struct Post {
        address author;
        string title;
        string content;
        uint256 creationTime;
        uint256 lastUpdateTime;
        string[] tags;
        bool published;
    }

    // Modifier to restrict access to only the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Constructor to set the owner
    constructor() {
        owner = msg.sender;
    }

    // Function to create a new blog post
    function createPost(string memory _title, string memory _content, string[] memory _tags) external onlyOwner {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_content).length > 0, "Content cannot be empty");

        Post memory newPost = Post({
            author: msg.sender,
            title: _title,
            content: _content,
            creationTime: block.timestamp,
            lastUpdateTime: block.timestamp,
            tags: _tags,
            published: false
        });

        posts.push(newPost);

        emit NewPost(msg.sender, _title, newPost.creationTime);
    }

    // Function to update an existing blog post and optionally publish it
    function updatePost(uint256 _index, string memory _newTitle, string memory _newContent, bool _publish) external {
        require(_index < posts.length, "Post index out of bounds");
        require(msg.sender == posts[_index].author, "Only the author can update this post");
        require(bytes(_newTitle).length > 0, "New title cannot be empty");
        require(bytes(_newContent).length > 0, "New content cannot be empty");

        posts[_index].title = _newTitle;
        posts[_index].content = _newContent;
        posts[_index].lastUpdateTime = block.timestamp;

        if (_publish && !posts[_index].published) {
            posts[_index].published = true;
            emit UpdatePost(msg.sender, _index, _newTitle, _newContent, posts[_index].lastUpdateTime);
        } else if (!_publish) {
            emit UpdatePost(msg.sender, _index, _newTitle, _newContent, posts[_index].lastUpdateTime);
        }
    }

    // Function to delete a blog post
    function deletePost(uint256 _index) external {
        require(_index < posts.length, "Post index out of bounds");
        require(msg.sender == posts[_index].author, "Only the author can delete this post");

        posts[_index] = posts[posts.length - 1];
        posts.pop();

        emit DeletePost(msg.sender, _index);
    }

    // Function to retrieve details of a blog post
    function getPost(uint256 _index) external view returns (address, string memory, string memory, uint256, uint256, string[] memory, bool) {
        require(_index < posts.length, "Post index out of bounds");

        Post storage post = posts[_index];
        return (post.author, post.title, post.content, post.creationTime, post.lastUpdateTime, post.tags, post.published);
    }

    // Function to get the total number of blog posts
    function getNumberOfPosts() external view returns (uint256) {
        return posts.length;
    }

    // Function to get basic details of a blog post by ID
    function getPostById(uint256 _index) external view returns (address, string memory, string memory) {
        require(_index < posts.length, "Post index out of bounds");

        Post storage post = posts[_index];
        return (post.author, post.title, post.content);
    }

    // Function to share a blog post on an external platform
    function shareOnExternalPlatform(uint256 _index, string memory _externalPlatform) external {
        require(_index < posts.length, "Post index out of bounds");
        require(bytes(_externalPlatform).length > 0, "External platform cannot be empty");

        emit ShareOnExternalPlatform(posts[_index].author, posts[_index].title, _externalPlatform);
    }
}
