window.addEventListener('message', function(event) {
    let data = event.data;

    if (data.action === "show") {
        document.getElementById("bodycam-container").style.display = "block";
        document.getElementById("player-name").innerText = data.name;
        document.getElementById("department-name").innerText = data.department;
    } else if (data.action === "hide") {
        document.getElementById("bodycam-container").style.display = "none";
    } else if (data.action === "notify") {
        data.messages.forEach((msg, index) => {
            setTimeout(() => {
                showNotification(msg, data.type);
            }, index * 300);
        });
    }
});

function showNotification(text, type) {
    const container = document.getElementById("notification-container");
    const notif = document.createElement("div");
    notif.className = `custom-notify ${type}`;
    notif.innerText = text;
    
    container.appendChild(notif);
    
    // Trigger reflow
    void notif.offsetWidth;
    notif.classList.add("show");
    
    setTimeout(() => {
        notif.classList.remove("show");
        setTimeout(() => {
            notif.remove();
        }, 300);
    }, 4000);
}

function updateTime() {
    const timeEl = document.getElementById("current-time");
    if (!timeEl) return;

    const now = new Date();
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    const day = days[now.getDay()];
    
    const date = String(now.getDate()).padStart(2, '0');
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const year = now.getFullYear();
    
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');

    timeEl.innerText = `${day}, ${date}/${month}/${year} ${hours}:${minutes}`;
}

setInterval(updateTime, 1000);
updateTime();
