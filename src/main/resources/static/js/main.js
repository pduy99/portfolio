// Spotlight effect
document.addEventListener('DOMContentLoaded', () => {
    const spotlight = document.getElementById('spotlight');

    window.addEventListener('mousemove', (e) => {
        const { clientX, clientY } = e;
        spotlight.style.setProperty('--x', clientX + 'px');
        spotlight.style.setProperty('--y', clientY + 'px');
    });

    // Section highlight on scroll
    const sections = document.querySelectorAll('section[id]');
    const navItems = document.querySelectorAll('.nav a');

    window.addEventListener('scroll', () => {
        let current = '';
        sections.forEach(section => {
            const sectionTop = section.offsetTop;
            const sectionHeight = section.clientHeight;
            if (window.scrollY >= sectionTop - 300) {
                current = section.getAttribute('id');
            }
        });

        navItems.forEach(item => {
            item.classList.remove('active');
            if (item.getAttribute('href').substring(1) === current) {
                item.classList.add('active');
            }
        });
    });
});
