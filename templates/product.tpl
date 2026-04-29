<div id="single-product" class="js-has-new-shipping js-product-detail js-product-container js-shipping-calculator-container pb-4 pt-md-4 pb-md-3 {% if settings.luxury_gallery %}js-luxury-pdp luxury-pdp{% endif %}" data-variants="{{product.variants_object | json_encode }}" data-store="product-detail">
    {% set description_content = product.description is not empty or settings.show_product_fb_comment_box %}

    <div class="{% if settings.luxury_gallery %}container-fluid p-0{% else %}container mt-4 mt-md-0 mb-3 pt-md-1{% endif %} {% if description_content and settings.full_width_description %}mb-md-0{% endif %}">
        <div class="row no-gutters">
            <div class="{% if settings.luxury_gallery %}col-md-6 luxury-gallery-col{% else %}col-md-7{% endif %} pb-3 pr-md-2">
                {% if settings.luxury_gallery %}
                    {% include 'snipplets/product/product-image-luxury.tpl' %}
                {% else %}
                    {% include 'snipplets/product/product-image.tpl' %}
                {% endif %}
            </div>
            <div class="col {% if settings.luxury_gallery %}col-md-6 luxury-info-col{% endif %}" data-store="product-info-{{ product.id }}">
                {% include 'snipplets/product/product-form.tpl' %}
                {% if not settings.full_width_description and not settings.luxury_gallery %}
                    {% include 'snipplets/product/product-description.tpl' %}
                {% endif %}
            </div>
        </div>
        
        {# Product description full width #}

        {% if settings.full_width_description %}
            {% include 'snipplets/product/product-description.tpl' %}
        {% endif %}

    </div>
</div>

{# Related products #}
{% include 'snipplets/product/product-related.tpl' %}