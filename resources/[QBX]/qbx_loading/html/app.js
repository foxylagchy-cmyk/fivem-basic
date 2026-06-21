const { ref } = Vue;

// Customize language for dialog menus and carousels here

const load = Vue.createApp({
    setup() {
        return {
            slides: [
                {
                    text: "Selamat Datang di Kota Ceria Roleplay!",
                    subText: "Gunakan akal sehat saat ber-Roleplay. Dilarang keras melakukan hal-hal yang melanggar aturan kota.",
                    image: "assets/images/1.png",
                },
                {
                    text: "Butuh Bantuan atau Ingin Bertanya?",
                    subText: "Silakan gunakan command /report di dalam game, atau buka tiket di Discord kami.",
                    image: "assets/images/2.png",
                },
                {
                    text: "Sistem Keuangan & Pekerjaan yang Realistis",
                    subText: "Jadilah mekanik, polisi, dokter, atau bahkan jalani hidup di sisi gelap. Pilihan ada di tanganmu.",
                    image: "assets/images/3.png",
                },
                {
                    text: "Bergabunglah dengan Komunitas Discord Kami!",
                    subText: "discord.gg/kotaceria - Dapatkan informasi terbaru, event, dan giveaway.",
                    image: "assets/images/4.png",
                },
            ],

            downloadCardTitle: "Loading Kota Ceria...",
            downloadCardDescription: "Mohon tunggu sebentar, kami sedang menyiapkan aset, kendaraan, dan dunia untukmu.\n\nJangan tutup gamenya, kamu akan otomatis masuk ke kota setelah loading selesai. Siapkan mentalmu!",

            settingsCardTitle: "Pengaturan Loading",
            audioTrackDescription: "Matikan ini jika kamu tidak ingin mendengar musik latar belakang.",
            playAudioDescription: "Matikan ini jika kamu ingin gambar tidak berganti secara otomatis.",
            playVideoDescription: "Matikan ini jika kamu ingin menghentikan video latar belakang.",

            keybindTitle: "Tombol Default",

            keybinds: [
                [
                    { key: "TAB", label: "Buka Tas (Inventory)" },
                    { key: "~", label: "Jarak Suara (Proximity)" },
                    { key: "M", label: "Buka HP" },
                    { key: "B", label: "Sabuk Pengaman" },
                    { key: "L ALT", label: "Menu Interaksi (Mata)" },
                    { key: "F1", label: "Menu Radial" },
                    { key: "I", label: "Menu HUD" },
                    { key: "CAPS", label: "Bicara di Radio" },
                ],
                [
                    { key: "L", label: "Kunci Kendaraan" },
                    { key: "G", label: "Mesin Kendaraan" },
                    { key: "X", label: "Angkat Tangan" },
                    { key: "HOME", label: "Daftar Pemain" },
                    { key: "U", label: "Ragdoll (Pingsan)" },
                    { key: "K", label: "Buka Bagasi" },
                    { key: "1-5", label: "Gunakan Item" },
                    { key: "Y", label: "Cruise Control" },
                ],
            ],

            slidesImageCarousel: ref(0),
            slidesTextCarousel: ref(0),
            slidesCarouselAutoplay: ref(true),
            keybindsCarousel: ref(0),
            keybindsCarouselAutoplay: ref(true),
            playAudio: ref(true),
            playVideo: ref(true),
            download: ref(true),
            settings: ref(false),
        };
    },
});

load.use(Quasar, { config: {} });
load.mount("#loading-main");

$(document).ready(function () {
    var audioFiles = [
        "assets/audio/ambientgold.mp3",
        "assets/audio/chimes.mp3",
        "assets/audio/daze.mp3",
        "assets/audio/galaxy.mp3",
        "assets/audio/highwaynights.mp3",
        "assets/audio/meteorbinge.mp3",
    ];

    var randomSong = audioFiles[Math.floor(Math.random() * audioFiles.length)];

    $("#audio").attr("src", randomSong);

    $("#audio")[0].autoplay = true;

    $("#audio")[0].play();
});

var audio = document.getElementById("audio");
audio.volume = 0.05;

function toggleAudio() {
    var audio = document.getElementById("audio");
    if (audio.paused) {
        audio.play();
    } else {
        audio.pause();
    }
}

function toggleVideo() {
    var video = document.getElementById("video");
    if (video.paused) {
        video.play();
    } else {
        video.pause();
    }
}

// Bikin interaktif: Tekan Spasi untuk mutar/matikan musik
window.addEventListener("keydown", function(event) {
    if (event.code === "Space") {
        toggleAudio();
    }
});

const handlers = {
    loadProgress({ loadFraction }) {
        document.querySelector(".thingy").style.width = loadFraction * 100 + "%";
    },
};

window.addEventListener("message", function (e) {
    (handlers[e.data.eventName] || function () {})(e.data);
});
