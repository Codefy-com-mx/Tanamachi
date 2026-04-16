<section class="scrolly-banner-wrapper" style="overflow: hidden; width: 100%;">
    <div class="scrolly-banner-container position-relative" style="width: 100%; height: 100vh; overflow: hidden; background-color: {{ settings.scrolly_banner_background_color | default('#FFFFFF') }};">
        
        {% if settings.scrolly_banner_images %}
            {% for slide in settings.scrolly_banner_images %}
                <div class="scrolly-frame" data-index="{{ loop.index0 }}" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-image: url('{{ slide.image | static_url | settings_image_url('1920p') }}'); background-size: {% if loop.first %}cover{% else %}contain{% endif %}; background-repeat: no-repeat; background-position: center; z-index: {{ loop.index }}; {% if not loop.first %}visibility: hidden;{% else %}visibility: visible;{% endif %}">
                    {% if slide.link %}
                        <a href="{{ slide.link | setting_url }}" style="position: absolute; top:0; left:0; width:100%; height:100%; z-index: 10;"></a>
                    {% endif %}
                </div>
            {% endfor %}
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
        
        var frames = wrapper.querySelectorAll('.scrolly-frame');
        var frameCount = frames.length;
        if (frameCount === 0) return;

        var progressState = { scroll: 0, mouse: 0, current: 0 };
        
        function renderFrame() {
            var targetProgress = Math.max(progressState.scroll, progressState.mouse);
            
            gsap.to(progressState, {
                current: targetProgress,
                duration: 0.1, 
                overwrite: true,
                onUpdate: function() {
                    var index = Math.min(frameCount - 1, Math.floor(progressState.current * frameCount));
                    
                    frames.forEach(function(frame, i) {
                        // Siempre mantener el primer frame (fondo) visible
                        if (i === 0) {
                            frame.style.visibility = 'visible';
                        } else {
                            frame.style.visibility = (i === index) ? 'visible' : 'hidden';
                        }
                    });
                }
            });
        }

        // Driver 1: ScrollTrigger (Pinning)
        ScrollTrigger.create({
            trigger: wrapper,
            start: "top top",     
            end: "+=" + (Math.max(1500, frameCount * 250)),        
            pin: true,
            onUpdate: function(self) {
                progressState.scroll = self.progress;
                renderFrame();
            }
        });

        // Driver 2: Mouse Movement (PC only)
        if (window.innerWidth > 768) {
            wrapper.addEventListener('mousemove', function(e) {
                var rawProgress = e.clientX / window.innerWidth;
                progressState.mouse = Math.min(1, Math.max(0, (rawProgress - 0.05) * 1.1));
                renderFrame();
            });
            
            wrapper.addEventListener('mouseleave', function() {
                progressState.mouse = 0;
                renderFrame();
            });
        }
    }
    
    // Start initialization
    initScrollyBanner();
});
</script>
