document.addEventListener('DOMContentLoaded', () => {
    const videos = document.querySelectorAll('.reel-item video');

    videos.forEach(video => {
        video.addEventListener('play', () => {
            videos.forEach(v => {
                if (v !== video) {
                    v.pause();
                }
            });
        });
    });
});
