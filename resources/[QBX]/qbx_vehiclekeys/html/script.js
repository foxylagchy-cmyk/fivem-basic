window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'playLockSound') {
        const audio = document.getElementById('lockAudio');
        audio.volume = data.volume || 0.5;
        audio.currentTime = 0;
        audio.play().catch(err => console.error('Audio play error:', err));
    }
});
