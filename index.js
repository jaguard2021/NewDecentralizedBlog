// Tambahkan import MetaMaskSDK di sini
import { MetaMaskSDK } from '@metamask/sdk';

const MMSDK = new MetaMaskSDK({
    dappMetadata: {
        name: "Decentralized Blog",
        url: window.location.host,
    }
    // Opsi lainnya
});

const ethereum = MMSDK.getProvider();

// Fungsi yang mungkin Anda perlukan dapat ditambahkan di sini
function createPost() {
    // Logika untuk membuat postingan blog
    console.log("Create post function");
}

// Fungsi untuk menggantikan connectWallet()
function connectWallet() {
    ethereum.request({ method: 'eth_requestAccounts', params: [] })
    .then((accounts) => {
        alert("Wallet connected! Account: " + accounts[0]);
        // Tambahkan logika tambahan jika diperlukan
    })
    .catch((error) => {
        console.error("Error connecting wallet:", error.message);
        // Handle error jika diperlukan
    });
}
