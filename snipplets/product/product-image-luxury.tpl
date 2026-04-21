{% set has_multiple_slides = product.media_count > 1 or product.video_url %}

<div class="luxury-gallery-container js-luxury-gallery" data-store="product-image-{{ product.id }}">
    <div class="luxury-gallery-wrapper">
        
        {# Imagen Principal #}
        <div class="luxury-main-image-col">
            <div class="js-luxury-main-slider swiper-container product-detail-slider h-100">
                <div class="swiper-wrapper h-100">
                    {% for media in product.media %}
                        <div id="luxury-image-{{ loop.index0 }}" class="swiper-slide luxury-main-slide js-product-slide h-100" data-image="{{media.id}}" data-image-position="{{loop.index0}}">
                            <a href="{{ media | product_image_url('original') }}" data-fancybox="product-gallery" class="luxury-main-link d-block h-100">
                                <img 
                                    src="{{ media | product_image_url('large') }}" 
                                    data-src="{{ media | product_image_url('original') }}"
                                    data-srcset="{{ media | product_image_url('large') }} 480w, {{ media | product_image_url('huge') }} 640w, {{ media | product_image_url('original') }} 1024w"
                                    class="luxury-main-img img-fluid lazyload js-product-slide-img" 
                                    alt="{{ media.alt }}"
                                    loading="lazy">
                            </a>
                        </div>
                    {% endfor %}
                </div>
                
                {# Paginación para Mobile #}
                <div class="luxury-pagination d-md-none js-luxury-pagination"></div>
            </div>
        </div>

        {# Miniaturas Verticales #}
        {% if has_multiple_slides %}
            <div class="luxury-thumbs-col d-none d-md-flex">
                <div class="js-luxury-thumbs swiper-container">
                    <div class="swiper-wrapper">
                        {% for media in product.media %}
                            <div class="swiper-slide luxury-thumb-slide js-luxury-thumb" data-image-position="{{ loop.index0 }}">
                                <img src="{{ media | product_image_url('thumb') }}" alt="{{ media.alt }}" class="luxury-thumb-img {% if loop.first %}active{% endif %}" loading="lazy">
                            </div>
                        {% endfor %}
                    </div>
                </div>
            </div>
        {% endif %}

    </div>
</div>
