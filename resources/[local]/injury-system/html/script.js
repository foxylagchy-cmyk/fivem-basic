window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.type) {
        case 'showBleedingScreen':
            showBleedingScreen(data.message);
            break;
            
        case 'showDeathScreen':
            showDeathScreen(data.message);
            break;
            
        case 'updateKnockTimer':
            updateKnockTimer(data.time);
            break;
            
        case 'updateDeathTimer':
            updateDeathTimer(data.time);
            break;
            
        case 'hideScreens':
            hideAllScreens();
            break;
    }
});

function showBleedingScreen(message) {
    hideAllScreens();
    
    const screen = document.getElementById('bleedingScreen');
    const messageEl = document.getElementById('bleedingMessage');
    
    if (message) {
        messageEl.textContent = message;
    }
    
    screen.classList.add('active');
}

function showDeathScreen(message) {
    hideAllScreens();
    
    const screen = document.getElementById('deathScreen');
    const messageEl = document.getElementById('deathMessage');
    
    if (message) {
        messageEl.textContent = message;
    }
    
    screen.classList.add('active');
}

function updateKnockTimer(time) {
    const timerEl = document.getElementById('knockTimer');
    if (timerEl) {
        timerEl.textContent = time;
        
        // Change color based on time
        if (time <= 10) {
            timerEl.style.color = '#ff3b30';
            timerEl.style.textShadow = '0 0 30px rgba(255, 59, 48, 0.8)';
        } else {
            timerEl.style.color = '#ffffff';
            timerEl.style.textShadow = '0 0 20px rgba(255, 255, 255, 0.3)';
        }
    }
}

function updateDeathTimer(time) {
    const timerEl = document.getElementById('deathTimer');
    if (timerEl) {
        timerEl.textContent = time;
    }
}

function hideAllScreens() {
    const screens = document.querySelectorAll('.screen');
    screens.forEach(screen => {
        screen.classList.remove('active');
    });
}

// Initialize - hide all screens on load
document.addEventListener('DOMContentLoaded', function() {
    hideAllScreens();
});
