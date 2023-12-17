// Inisialisasi Web3.js
const web3 = new Web3('https://mainnet.infura.io/v3/YOUR_INFURA_API_KEY');

// Mendefinisikan objek kontrak (masukkan alamat kontrak dan ABI di sini)
const contractAddress = 'YOUR_CONTRACT_ADDRESS';
const contractABI = [...]; // Isi dengan ABI kontrak Anda
const decentralizedBlogContract = new web3.eth.Contract(contractABI, contractAddress);

// Fungsi untuk membuat postingan blog
async function createPost() {
    const title = document.getElementById('postTitle').value;
    const content = document.getElementById('postContent').value;

    // Memanggil fungsi createPost dari kontrak pintar
    await decentralizedBlogContract.methods.createPost(title, content, []).send({ from: 'YOUR_WALLET_ADDRESS' });

    // Refresh tampilan setelah membuat postingan
    updateBlogPosts();
}

// Fungsi untuk memperbarui tampilan postingan blog
async function updateBlogPosts() {
    const blogPostsElement = document.getElementById('blogPosts');
    blogPostsElement.innerHTML = ''; // Mengosongkan konten sebelumnya

    // Mendapatkan jumlah postingan
    const numberOfPosts = await decentralizedBlogContract.methods.getNumberOfPosts().call();

    // Menampilkan setiap postingan
    for (let i = 0; i < numberOfPosts; i++) {
        const postDetails = await decentralizedBlogContract.methods.getPost(i).call();
        const postElement = document.createElement('div');
        postElement.innerHTML = `<strong>${postDetails[1]}</strong><br>${postDetails[2]}<br><em>Author: ${postDetails[0]}</em><br><br>`;
        blogPostsElement.appendChild(postElement);
    }
}

// Memanggil fungsi untuk memperbarui tampilan saat halaman dimuat
window.onload = updateBlogPosts;
