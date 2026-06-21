// Array tips keren untuk roleplay
const tips = [
    "Gunakan /help jika kamu membutuhkan bantuan di dalam kota.",
    "Bermainlah sesuai karaktermu (In Character). Jangan bawa masalah OOC ke dalam game.",
    "Perhatikan sekitarmu, kota ini penuh dengan interaksi yang menarik.",
    "Bekerja keras adalah kunci untuk sukses di Kota Ceria.",
    "Gunakan seatbelt saat berkendara untuk keselamatan.",
    "Gunakan /report jika kamu menemukan bug atau rulebreaker."
];

let currentTip = 0;
const tipElement = document.getElementById('tip-text');

// Rotasi tips setiap 5 detik
setInterval(() => {
    tipElement.style.opacity = 0;
    
    setTimeout(() => {
        currentTip = (currentTip + 1) % tips.length;
        tipElement.innerText = tips[currentTip];
        tipElement.style.transition = 'opacity 0.5s ease';
        tipElement.style.opacity = 1;
    }, 500);
}, 5000);

// Integrasi dengan NUI Native FiveM untuk event loading
let loadProgress = 0;

window.addEventListener('message', function(e) {
    if(e.data.eventName === 'loadProgress') {
        // Update bar progres
        loadProgress = parseInt(e.data.loadFraction * 100);
        document.getElementById('progress-fill').style.width = loadProgress + '%';
    }
});

// Event native FiveM lainnya yang bisa ditangkap:
// Handlers
const handlers = {
    startInitFunctionOrder(data) {
        document.getElementById('status-text').innerText = "Inisialisasi sistem kota...";
    },
    initFunctionInvoking(data) {
        document.getElementById('status-text').innerText = "Memuat skrip " + data.name + "...";
    },
    startDataFileEntries(data) {
        document.getElementById('status-text').innerText = "Memuat aset peta...";
    },
    performMapLoadFunction(data) {
        document.getElementById('status-text').innerText = "Mempersiapkan dunia...";
    },
    onLogLine(data) {
        document.getElementById('status-text').innerText = data.message;
    }
};

window.addEventListener('message', function(e) {
    if(handlers[e.data.eventName]) {
        handlers[e.data.eventName](e.data);
    }
});
