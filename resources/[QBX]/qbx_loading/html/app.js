// --- Data ---
const slidesData = [
    {
        title: "Selamat Datang di Kota Ceria!",
        desc: "Gunakan akal sehat saat ber-Roleplay. Dilarang keras melakukan hal-hal yang melanggar aturan kota.",
        icon: "fas fa-star"
    },
    {
        title: "Butuh Bantuan?",
        desc: "Gunakan command /report di dalam game, atau buka tiket di Discord kami.",
        icon: "fas fa-headset"
    },
    {
        title: "Pekerjaan Realistis",
        desc: "Jadilah mekanik, polisi, dokter, atau jalani hidup di sisi gelap. Pilihan ada di tanganmu.",
        icon: "fas fa-briefcase"
    },
    {
        title: "Join Discord Kami",
        desc: "Dapatkan informasi terbaru, event, dan giveaway di discord.gg/kotaceria",
        icon: "fab fa-discord"
    }
];

const keybindsList = [
    { key: "TAB", label: "Buka Tas" },
    { key: "~", label: "Jarak Suara" },
    { key: "M", label: "Buka HP" },
    { key: "B", label: "Sabuk Pengaman" },
    { key: "ALT", label: "Menu Interaksi" },
    { key: "F1", label: "Menu Radial" },
    { key: "I", label: "Sembunyikan HUD" },
    { key: "CAPS", label: "Gunakan Radio" },
    { key: "L", label: "Kunci Kendaraan" },
    { key: "G", label: "Mesin Kendaraan" },
    { key: "X", label: "Angkat Tangan" },
    { key: "HOME", label: "Daftar Pemain" },
    { key: "U", label: "Ragdoll / Jatuh" },
    { key: "K", label: "Buka Bagasi" },
    { key: "1-5", label: "Gunakan Item" },
    { key: "Y", label: "Cruise Control" },
];

// --- Audio Logic ---
const audio = document.getElementById("audio");
audio.volume = 0.15;
let audioPlaying = true;
const audioIcon = document.getElementById("audio-icon");
const btnAudio = document.getElementById("btn-audio");

const audioFiles = [
    "assets/audio/kingdominblue.mp3",
];

audio.src = audioFiles[Math.floor(Math.random() * audioFiles.length)];

audio.play().catch(() => {
    audioPlaying = false;
    audioIcon.className = "fas fa-volume-mute";
});

function toggleAudio() {
    if (audio.paused) {
        audio.play();
        audioPlaying = true;
        audioIcon.className = "fas fa-volume-up";
    } else {
        audio.pause();
        audioPlaying = false;
        audioIcon.className = "fas fa-volume-mute";
    }
}

window.addEventListener("keydown", function(event) {
    if (event.code === "Space") toggleAudio();
});

btnAudio.addEventListener("click", toggleAudio);

// --- Slideshow Logic ---
let currentSlide = 0;
const bgImages = document.querySelectorAll(".bg-image");
const dots = document.querySelectorAll(".dot");
const cardTitle = document.getElementById("card-title");
const cardDesc = document.getElementById("card-desc");
const cardIcon = document.getElementById("card-icon");
const dynamicCard = document.getElementById("dynamic-card");
let slideInterval;

function updateSlide(index) {
    // Fade out text card
    dynamicCard.style.opacity = 0;
    dynamicCard.style.transform = "translateY(20px)";
    
    // Update Background
    bgImages.forEach(img => img.classList.remove("active"));
    bgImages[index].classList.add("active");
    
    // Update Dots
    dots.forEach(dot => dot.classList.remove("active"));
    dots[index].classList.add("active");
    
    setTimeout(() => {
        // Update Card Content
        cardTitle.textContent = slidesData[index].title;
        cardDesc.textContent = slidesData[index].desc;
        cardIcon.className = slidesData[index].icon;
        
        // Fade in
        dynamicCard.style.opacity = 1;
        dynamicCard.style.transform = "translateY(0)";
    }, 400); // Wait for transition
}

function nextSlide() {
    currentSlide = (currentSlide + 1) % bgImages.length;
    updateSlide(currentSlide);
    resetInterval();
}

function prevSlide() {
    currentSlide = (currentSlide - 1 + bgImages.length) % bgImages.length;
    updateSlide(currentSlide);
    resetInterval();
}

document.getElementById("next-slide").addEventListener("click", nextSlide);
document.getElementById("prev-slide").addEventListener("click", prevSlide);

dots.forEach((dot, index) => {
    dot.addEventListener("click", () => {
        currentSlide = index;
        updateSlide(currentSlide);
        resetInterval();
    });
});

function resetInterval() {
    clearInterval(slideInterval);
    slideInterval = setInterval(nextSlide, 7000); // Auto slide every 7s
}
resetInterval();

// --- Keybinds Modal Logic ---
const btnKeybinds = document.getElementById("btn-keybinds");
const modalKeybinds = document.getElementById("modal-keybinds");
const closeModal = document.getElementById("close-modal");
const keybindsContainer = document.getElementById("keybinds-container");

// Populate Keybinds
keybindsList.forEach(kb => {
    const el = document.createElement("div");
    el.className = "keybind-item";
    el.innerHTML = `
        <span class="keybind-label">${kb.label}</span>
        <span class="keybind-key">${kb.key}</span>
    `;
    keybindsContainer.appendChild(el);
});

btnKeybinds.addEventListener("click", () => {
    modalKeybinds.classList.add("active");
});

closeModal.addEventListener("click", () => {
    modalKeybinds.classList.remove("active");
});

modalKeybinds.addEventListener("click", (e) => {
    if(e.target === modalKeybinds) modalKeybinds.classList.remove("active");
});

// --- Tips Carousel ---
const tips = [
    "Tip: Gunakan /report jika menemukan pelanggaran di dalam kota.",
    "Tip: Hormati semua player, jadikan roleplay menyenangkan untuk semua.",
    "Tip: Jangan lupa makan dan minum agar karaktermu tetap sehat.",
    "Tip: Bergabunglah di Discord kami untuk informasi terbaru.",
    "Tip: Perhatikan sekitarmu, selalu gunakan akal sehat dalam Roleplay."
];

let currentTip = 0;
const tipsContainer = document.getElementById("tips-carousel");

setInterval(() => {
    tipsContainer.style.opacity = 0;
    setTimeout(() => {
        currentTip = (currentTip + 1) % tips.length;
        tipsContainer.innerHTML = `<p>${tips[currentTip]}</p>`;
        tipsContainer.style.opacity = 1;
    }, 500);
}, 5000);

// --- Particles Engine ---
const particlesContainer = document.getElementById('particles-container');
const particleCount = 40;

for (let i = 0; i < particleCount; i++) {
    const particle = document.createElement('div');
    particle.className = 'particle';
    const size = Math.random() * 5 + 2; 
    const posX = Math.random() * 100;
    const duration = Math.random() * 20 + 10;
    const delay = Math.random() * 20;
    
    particle.style.width = `${size}px`;
    particle.style.height = `${size}px`;
    particle.style.left = `${posX}%`;
    particle.style.animationDuration = `${duration}s`;
    particle.style.animationDelay = `${delay}s`;
    particlesContainer.appendChild(particle);
}

// --- Loading Event Handlers (FiveM) ---
const progressBar = document.getElementById("progress-bar");
const percentageText = document.getElementById("percentage");
const statusText = document.getElementById("status-text");

const handlers = {
    startInitFunctionOrder() { statusText.textContent = "Inisialisasi Core..."; },
    initFunctionInvoking() { statusText.textContent = "Memuat Resource..."; },
    startDataFileEntries() { statusText.textContent = "Memuat Data Game..."; },
    performMapLoadFunction() { statusText.textContent = "Memuat Peta..."; },
    loadProgress({ loadFraction }) {
        const percentage = Math.round(loadFraction * 100);
        
        if (progressBar) progressBar.style.width = percentage + "%";
        if (percentageText) percentageText.textContent = percentage + "%";
        
        if (percentage < 20) {
            statusText.textContent = "Memuat Aset Utama...";
        } else if (percentage < 40) {
            statusText.textContent = "Memuat Kendaraan Kustom...";
        } else if (percentage < 60) {
            statusText.textContent = "Memuat Peta & MLO...";
        } else if (percentage < 80) {
            statusText.textContent = "Memuat Skrip Server...";
        } else if (percentage < 95) {
            statusText.textContent = "Hampir Selesai...";
        } else {
            statusText.textContent = "Menyiapkan Spawn Pemain...";
        }
    },
};

window.addEventListener("message", function (e) {
    if (e.data.eventName) {
        (handlers[e.data.eventName] || function () {})(e.data);
    }
});
