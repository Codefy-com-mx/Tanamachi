<section class="scrolly-banner-wrapper" style="overflow: hidden; width: 100%;">
    <div class="scrolly-banner-container position-relative" style="width: 100%; height: 100vh; overflow: hidden; background-color: {{ settings.scrolly_banner_background_color | default('#FFFFFF') }};">
        
        {% if settings.scrolly_banner_bg_images or settings.scrolly_banner_fg_images %}
            
            <!-- CAPA ESCRITORIO: Manteniendo imágenes superpuestas (fondo + frente 50%) -->
            <div id="scrolly-desktop-layer" style="display: none; width: 100%; height: 100%;">
                {% if settings.scrolly_banner_bg_images %}
                    {% for slide in settings.scrolly_banner_bg_images %}
                        <div class="scrolly-bg-frame" data-index="{{ loop.index0 }}" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-image: url('{{ slide.image | static_url | settings_image_url('1920p') }}'); background-size: cover; background-repeat: no-repeat; background-position: center; z-index: 1; visibility: hidden;"></div>
                    {% endfor %}
                {% endif %}

                {% if settings.scrolly_banner_fg_images %}
                    {% for slide in settings.scrolly_banner_fg_images %}
                        <div class="scrolly-fg-frame" data-index="{{ loop.index0 }}" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; z-index: 2; visibility: hidden;">
                            <div style="position: relative; max-width: 50%; max-height: 50vh; display: inline-block;">
                                <img src="{{ slide.image | static_url | settings_image_url('1920p') }}" style="max-width: 100%; max-height: 50vh; width: auto; height: auto; display: block;" alt="">
                                {% if slide.link %}
                                    <a href="{{ slide.link | setting_url }}" style="position: absolute; top:0; left:0; width:100%; height:100%; z-index: 10;"></a>
                                {% endif %}
                            </div>
                        </div>
                    {% endfor %}
                {% endif %}
            </div>

            <!-- CAPA MÓVIL: Única secuencia, imágenes adaptadas (cover), sin superposiciones -->
            <div id="scrolly-mobile-layer" style="display: none; width: 100%; height: 100%;">
                {# Unimos imágenes de fondo #}
                {% if settings.scrolly_banner_bg_images %}
                    {% for slide in settings.scrolly_banner_bg_images %}
                        <div class="scrolly-mobile-frame" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; visibility: hidden;">
                            <img src="{{ slide.image | static_url | settings_image_url('1920p') }}" style="width: 100%; height: 100%; object-fit: cover; object-position: center; display: block;" alt="">
                        </div>
                    {% endfor %}
                {% endif %}
                
                {# Unimos imágenes que en escritorio eran superpuestas, tratándolas aquí como pantallas de un único nivel #}
                {% if settings.scrolly_banner_fg_images %}
                    {% for slide in settings.scrolly_banner_fg_images %}
                        <div class="scrolly-mobile-frame" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; visibility: hidden;">
                            <img src="{{ slide.image | static_url | settings_image_url('1920p') }}" style="width: 100%; height: 100%; object-fit: cover; object-position: center; display: block;" alt="">
                            {% if slide.link %}
                                <a href="{{ slide.link | setting_url }}" style="position: absolute; top:0; left:0; width:100%; height:100%; z-index: 10;"></a>
                            {% endif %}
                        </div>
                    {% endfor %}
                {% endif %}
            </div>

            <!-- CAPA DE OSCURECIMIENTO (OVERLAY) -->
            {% if settings.scrolly_banner_overlay_opacity and settings.scrolly_banner_overlay_opacity > 0 %}
                <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, {{ settings.scrolly_banner_overlay_opacity }}); z-index: 50; pointer-events: none;"></div>
            {% endif %}

            <!-- CAPA FIJA SUPERIOR: Texto Central y Botón (No participa en la animación) -->
            {% if settings.scrolly_banner_text or settings.scrolly_banner_button_text %}
                <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center; z-index: 100; pointer-events: none;">
                    
                    {% if settings.scrolly_banner_text %}
                        <h2 style="font-size: clamp(3rem, 7vw, 6rem); font-weight: 800; color: {{ settings.scrolly_banner_text_color | default('#FFF') }}; margin-bottom: 25px; text-align: center; line-height: 1; letter-spacing: -0.04em; pointer-events: auto;">
                            {{ settings.scrolly_banner_text | translate }}
                        </h2>
                    {% endif %}
                    
                    {% if settings.scrolly_banner_button_text %}
                        <a href="{{ settings.scrolly_banner_button_link | default('#') | setting_url }}" style="display: inline-block; padding: 12px 36px; border-radius: 50px; background: transparent; border: 1.5px solid {{ settings.scrolly_banner_btn_text_color | default('#FFF') }}; color: {{ settings.scrolly_banner_btn_text_color | default('#FFF') }}; font-size: 15px; font-weight: 500; text-decoration: none; pointer-events: auto; transition: all 0.3s ease;">
                            {{ settings.scrolly_banner_button_text | translate }}
                        </a>
                    {% endif %}
                </div>
            {% endif %}

        {% else %}
            <div class="text-center py-5">
                <div class="subtitle mt-3">Agrega las imágenes de la secuencia en el administrador.</div>
            </div>
        {% endif %}
        
    </div>
</section>

<script>
document.addEventListener("DOMContentLoaded", function() {
    function initScrollyBanner() {
        if (typeof gsap === 'undefined' || typeof ScrollTrigger === 'undefined') {
            setTimeout(initScrollyBanner, 100);
            return;
        }
        
        gsap.registerPlugin(ScrollTrigger);

        var wrapper = document.querySelector('.scrolly-banner-wrapper');
        if (!wrapper) return;

        var isMobile = window.innerWidth <= 1024; // Resolvemos entorno responsivo incluyendo teléfonos y tabletas (<=1024px)
        var desktopLayer = document.getElementById('scrolly-desktop-layer');
        var mobileLayer = document.getElementById('scrolly-mobile-layer');

        if (desktopLayer && mobileLayer) {
            if (isMobile) {
                // Activamos único visor para móvil y destruímos HTML de escritorio para evitar que se pinte en memoria
                mobileLayer.style.display = 'block';
                desktopLayer.parentNode.removeChild(desktopLayer);
            } else {
                desktopLayer.style.display = 'block';
                mobileLayer.parentNode.removeChild(mobileLayer);
            }
        }

        var progressState = { scroll: 0, mouse: 0, current: 0 };
        var maxCount = 0;
        
        var bgFrames = wrapper.querySelectorAll('.scrolly-bg-frame');
        var fgFrames = wrapper.querySelectorAll('.scrolly-fg-frame');
        var mobileFrames = wrapper.querySelectorAll('.scrolly-mobile-frame');

        if (isMobile) {
            maxCount = mobileFrames.length;
            if (mobileFrames.length > 0) mobileFrames[0].style.visibility = 'visible';
        } else {
            maxCount = Math.max(bgFrames.length, fgFrames.length);
            if (bgFrames.length > 0) bgFrames[0].style.visibility = 'visible';
            if (fgFrames.length > 0) fgFrames[0].style.visibility = 'visible';
        }

        if (maxCount === 0) return;

        // Función unificada que sabe qué fotogramas debe animar dependiendo del dispositivo
        var renderFrame = function() {
            var targetProgress = Math.max(progressState.scroll, progressState.mouse);
            
            gsap.to(progressState, {
                current: targetProgress,
                duration: 0.1, 
                overwrite: true,
                onUpdate: function() {
                    // Animación tipo secuencia rápida única visual
                    if (isMobile) {
                        var mIndex = Math.min(mobileFrames.length - 1, Math.floor(progressState.current * mobileFrames.length));
                        mobileFrames.forEach(function(frame, i) {
                            frame.style.visibility = (i === mIndex) ? 'visible' : 'hidden';
                        });
                    } else {
                        // Animación superpuesta
                        if (bgFrames.length > 0) {
                            var bgIndex = Math.min(bgFrames.length - 1, Math.floor(progressState.current * bgFrames.length));
                            bgFrames.forEach(function(frame, i) {
                                frame.style.visibility = (i === bgIndex) ? 'visible' : 'hidden';
                            });
                        }
                        if (fgFrames.length > 0) {
                            var fgIndex = Math.min(fgFrames.length - 1, Math.floor(progressState.current * fgFrames.length));
                            fgFrames.forEach(function(frame, i) {
                                frame.style.visibility = (i === fgIndex) ? 'visible' : 'hidden';
                            });
                        }
                    }
                }
            });
        };

        // ScrollTrigger atado directamente al envoltorio, con pin común.
        ScrollTrigger.create({
            trigger: wrapper,
            start: "top top",     
            end: "+=" + (Math.max(1500, maxCount * 250)),        
            pin: true,
            onUpdate: function(self) {
                progressState.scroll = self.progress;
                renderFrame();
            }
        });

        // Mouse Interactivity (solo Escritorio)
        if (!isMobile) {
            var mouseMoveHandler = function(e) {
                var rawProgress = e.clientX / window.innerWidth;
                progressState.mouse = Math.min(1, Math.max(0, (rawProgress - 0.05) * 1.1));
                renderFrame();
            };
            
            var mouseLeaveHandler = function() {
                progressState.mouse = 0;
                renderFrame();
            };

            wrapper.addEventListener('mousemove', mouseMoveHandler);
            wrapper.addEventListener('mouseleave', mouseLeaveHandler);
        }

    }
    
    initScrollyBanner();
});
</script>
