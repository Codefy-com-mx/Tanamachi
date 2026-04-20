<section class="gsap-scroll-pin-wrapper {% if not settings.gsap_banner_full %}container{% else %}container-fluid p-0{% endif %}" data-store="gsap-banner">
    <div class="gsap-pinned-container js-gsap-pinned-container">
        {% for slide in settings.gsap_banner %}
            <div class="gsap-slide js-gsap-slide" style="z-index: {{ loop.index }}; {% if loop.first %}opacity: 1;{% else %}opacity: 0;{% endif %}">
                <div class="gsap-slide-bg" style="background-image: url('{{ slide.image | static_url | settings_image_url('1920w') }}');"></div>
                
                {% if slide.title or slide.description or slide.button %}
                <div class="gsap-slide-content container">
                    {% if slide.title %}
                        <h2 class="gsap-slide-title" style="color: {{ slide.color | default('#ffffff') }}">{{ slide.title }}</h2>
                    {% endif %}
                    {% if slide.description %}
                        <p class="gsap-slide-desc" style="color: {{ slide.color | default('#ffffff') }}">{{ slide.description }}</p>
                    {% endif %}
                    {% if slide.button and slide.link %}
                        <a href="{{ slide.link }}" class="btn btn-primary gsap-slide-btn">{{ slide.button }}</a>
                    {% endif %}
                </div>
                {% endif %}
            </div>
        {% endfor %}
    </div>
</section>

<style>
.gsap-scroll-pin-wrapper {
    width: 100%;
}
.gsap-pinned-container {
    height: 100vh; /* Premium full screen height when pinned */
    width: 100%;
    position: relative;
    overflow: hidden;
    background: var(--main-background, #000);
}
.gsap-slide {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #000;
}
.gsap-slide-bg {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%; 
    background-size: cover;
    background-position: center;
    z-index: -1;
    filter: brightness(0.85); 
}
.gsap-slide-content {
    text-align: center;
    max-width: 800px;
    padding: 0 20px;
    pointer-events: none; 
    z-index: 3;
    position: relative;
}
.gsap-slide-content a {
    pointer-events: auto;
}
.gsap-slide-title {
    font-size: clamp(3rem, 6vw, 6rem);
    font-weight: 400;
    line-height: 1.1;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    margin-bottom: 20px;
    font-family: var(--font-headings, inherit);
}
.gsap-slide-desc {
    font-size: clamp(1rem, 2vw, 1.25rem);
    margin-bottom: 30px;
    font-family: var(--font-rest, inherit);
    font-weight: 300;
}
.gsap-slide-btn {
    text-transform: uppercase;
    letter-spacing: 1px;
    padding: 12px 30px;
    font-size: 0.85rem;
    transition: all 0.3s ease;
}

/* Opcional: Altura en celulares */
@media (max-width: 768px) {
    .gsap-pinned-container {
        /* Para evitar problemas con la barra de navegación del celular si cambia el alto visible */
        height: 100svh;
    }
}
</style>

<script>
LS.ready.then(function() {
    function initGSAPScrollBanner() {
        if (typeof gsap === "undefined" || typeof ScrollTrigger === "undefined") {
            setTimeout(initGSAPScrollBanner, 200);
            return;
        }

        gsap.registerPlugin(ScrollTrigger);

        const bannerWrapper = document.querySelector(".gsap-scroll-pin-wrapper");
        const pinnedContainer = document.querySelector(".js-gsap-pinned-container");
        if (!bannerWrapper || !pinnedContainer) return;
        
        const slides = pinnedContainer.querySelectorAll(".js-gsap-slide");
        // Si no hay imágenes o solo hay 1, el contenedor se comporta normal (sin pining y sin cambiar)
        if (slides.length <= 1) {
            // Asegurar que sea visible si solo es uno
            if(slides.length === 1) {
                gsap.set(slides[0], { opacity: 1 });
            }
            return; 
        }

        /* 
         * ¿Cuánto scroll requiere el usuario? 
         * Asignamos un 100% de la altura de la página (+=100%) por cada diapositiva nueva que queremos mostrar.
         * Así, al dividir la distancia en el timeline, se sentirá proporcionado.
         */
        const scrollDistance = (slides.length - 1) * 100;

        const tl = gsap.timeline({
            scrollTrigger: {
                trigger: pinnedContainer,
                start: "top top", // Inicia al hacer tope arriba en pantalla
                end: `+=${scrollDistance}%`, // Límite del pinning proporcional a las fotos
                pin: true,        // Clava la sección
                scrub: 0.5,       // Enlaza la animación con el scroll natural. Con un valor (ej: 0.5) le da "suavidad" e inercia extra.
                anticipatePin: 1  // Previene un repiqueteo visual justo en el momento del anclaje
            }
        });

        // Iteramos las fotos para armar el timeline
        // Slide index 0 ya está en opacity 1, animamos a partir de la 1 en adelante
        for (let i = 1; i < slides.length; i++) {
            
            // Opcional: efecto de Zoom a la foto que se está yendo (la i - 1) 
            // de forma sincrónica (-=1)
            tl.to(slides[i - 1].querySelector('.gsap-slide-bg'), {
                scale: 1.1,
                ease: "none",
                duration: 1
            }, "+=0") // Empieza de inmediato (o despues de la anterior)

            // Fade-in a la foto nueva que entra al mismo tiempo (-=1)
            .to(slides[i], {
                opacity: 1,
                ease: "none",
                duration: 1
            }, "<"); // El "<" indica que empieza EXACTAMENTE al mismo tiempo que la animación previa
            
        }
    }

    initGSAPScrollBanner();
});
</script>
