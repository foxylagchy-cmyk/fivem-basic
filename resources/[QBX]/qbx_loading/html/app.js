const { ref } = Vue;

// Customize language for dialog menus and carousels here

const load = Vue.createApp({
    setup() {
        return {
            slides: [
                {
                    text: "You can add/remove items, vehicles, jobs & gangs through the shared folder.",
                    subText: "Photo captured by: Markyoo#8068",
                    image: "assets/images/1.png",
                },
                {
                    text: "Find any issues or want to suggest feature requests? Head to our github and create an issue!",
                    subText: "Photo captured by: ihyajb#9723",
                    image: "assets/images/2.png",
                },
                {
                    text: "All server-specific adjustments can be made in the config.lua files throughout the build.",
                    subText: "Photo captured by: FLAPZ[INACTIV]#9925",
                    image: "assets/images/3.png",
                },
                {
                    text: "For additional support please join our community at discord.gg/qbox",
                    subText: "Photo captured by: Robinerino#1312",
                    image: "assets/images/4.png",
                },
            ],

            downloadCardTitle: "Downloading Qbox Server",
            downloadCardDescription: "Hold tight while we begin downloading all the resources/assets required to play on QBox Server. \n\nAfter download has been finished successfully, you'll be placed into the server and this screen will disappear. Please don't leave or turn off your PC. ",

            settingsCardTitle: "Settings",
            audioTrackDescription: "When disabled the current audio-track playing will be stopped.",
            playAudioDescription: "When disabled carousel images will stop cycling and remain on the last shown.",
            playVideoDescription: "When disabled video will stop playing and remain paused.",

            keybindTitle: "Default Keybinds",

            keybinds: [
                [
                    { key: "TAB", label: "Open Inventory" },
                    { key: "`", label: "Cycle Proximity" },
                    { key: "M", label: "Open Phone" },
                    { key: "B", label: "Toggle Seat Belt" },
                    { key: "L ALT", label: "Open Target Menu" },
                    { key: "F1", label: "Radial Menu" },
                    { key: "I", label: "Open Hud Menu" },
                    { key: "L ALT", label: "Talk Over Radio" },
                ],
                [
                    { key: "L", label: "Vehicle Locks" },
                    { key: "G", label: "Toggle Engine" },
                    { key: "B", label: "Pointer Emote" },
                    { key: "HOME", label: "Open Scoreboard" },
                    { key: "Z", label: "Keybind Slots" },
                    { key: "X", label: "Hands Up Emote" },
                    { key: "NUM", label: "Use Item Slots" },
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

const handlers = {
    loadProgress({ loadFraction }) {
        document.querySelector(".thingy").style.width = loadFraction * 100 + "%";
    },
};

window.addEventListener("message", function (e) {
    (handlers[e.data.eventName] || function () {})(e.data);
});
