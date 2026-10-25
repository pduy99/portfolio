// Case study demo video: landscape on wide screens, portrait on phones.
// Autoplays muted and looping, except for visitors who prefer reduced motion,
// and pauses while scrolled out of view so it does not burn battery.
(() => {
    const video = document.getElementById('demo-video');
    if (!video) return;

    const toggle = document.getElementById('demo-toggle');
    const sound = document.getElementById('demo-sound');
    const wide = window.matchMedia('(min-width: 768px)');
    const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

    // Paused by the visitor, as opposed to paused because it scrolled away.
    let pausedByUser = reducedMotion.matches;
    let inView = false;

    const showIcon = (button, visible) => {
        button.querySelectorAll('[data-icon]').forEach((icon) => {
            icon.classList.toggle('hidden', icon.dataset.icon !== visible);
        });
    };

    const syncButtons = () => {
        showIcon(toggle, video.paused ? 'play' : 'pause');
        toggle.setAttribute('aria-label', video.paused ? 'Play the demo' : 'Pause the demo');
        showIcon(sound, video.muted ? 'muted' : 'sound');
        sound.setAttribute('aria-label', video.muted ? 'Turn sound on' : 'Turn sound off');
    };

    const play = () => video.play().catch(() => syncButtons());

    const load = () => {
        const variant = wide.matches ? 'landscape' : 'portrait';
        const src = video.dataset[variant];
        if (video.getAttribute('src') === src) return;
        const time = video.currentTime;
        video.poster = video.dataset[variant + 'Poster'];
        video.src = src;
        video.currentTime = time;
        if (!pausedByUser && inView) play();
    };

    toggle.addEventListener('click', () => {
        if (video.paused) {
            pausedByUser = false;
            play();
        } else {
            pausedByUser = true;
            video.pause();
        }
    });

    sound.addEventListener('click', () => {
        video.muted = !video.muted;
        if (!video.muted && video.paused) {
            pausedByUser = false;
            play();
        }
        syncButtons();
    });

    ['play', 'pause', 'volumechange'].forEach((event) => video.addEventListener(event, syncButtons));
    wide.addEventListener('change', load);

    new IntersectionObserver(([entry]) => {
        inView = entry.isIntersecting;
        if (inView && !pausedByUser) play();
        else if (!inView && !video.paused) video.pause();
    }, { threshold: 0.25 }).observe(video);

    load();
    syncButtons();
})();
