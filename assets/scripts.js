(() => {
    const navHandler = (() => {
        const nav = document.querySelector('.js-nav');
        const navTrigger = document.querySelector('.js-burger');

        navTrigger.addEventListener('click', event => {
            nav.classList.toggle('nav--open');
        });
    })();
})();