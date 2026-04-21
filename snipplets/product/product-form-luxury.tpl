<div class="luxury-form-container">
    
    {# 1. Nombre del producto en mayúsculas #}
    <h1 class="js-product-name">{{ product.name }}</h1>

    {# 2. Precio #}
    <div class="price-container mb-4" data-store="product-price-{{ product.id }}">
        <div class="js-price-container">
            <span class="js-price-display" id="price_display" data-product-price="{{ product.price }}">
                {{ product.price | money }}
            </span>
            {% if product.compare_at_price %}
                <span class="js-compare-price-display price-compare ml-2 opacity-50" style="text-decoration: line-through;">
                    {{ product.compare_at_price | money }}
                </span>
            {% endif %}
        </div>
    </div>

    {# 3. Descripción compacta #}
    <div class="product-description mb-5">
        {{ product.description }}
    </div>

    <form id="product_form" class="js-product-form" method="post" action="{{ store.cart_url }}">
        <input type="hidden" name="add_to_cart" value="{{product.id}}" />
        
        {# 4 & 5. Variantes de Talla y Color #}
        {% if product.variations %}
            {% for variation in product.variations %}
                <div class="variant-block js-product-variants-group" data-variation-id="{{ variation.id }}">
                    <label class="variant-label">SELECT {{ variation.name }}</label>
                    <div class="variant-options">
                        {% for option in variation.options %}
                            <button type="button" 
                                    class="js-luxury-variant-btn btn-variant-luxury {% if product.default_options[variation.id] is same as(option.id) %}selected{% endif %}" 
                                    data-option="{{ option.id }}" 
                                    data-variation-id="{{ variation.id }}">
                                {{ option.name }}
                            </button>
                        {% endfor %}
                    </div>
                    {# Hidden select for native functionality #}
                    <select id="variation_{{ loop.index }}" name="variation[{{ variation.id }}]" class="js-variation-option d-none">
                        {% for option in variation.options %}
                            <option value="{{ option.id }}" {% if product.default_options[variation.id] is same as(option.id) %}selected="selected"{% endif %}>
                                {{ option.name }}
                            </option>
                        {% endfor %}
                    </select>
                </div>
            {% endfor %}
        {% endif %}

        {# 6. Botón ADD TO BAG #}
        <div class="js-buy-button-container mt-5">
            {% set state = store.is_catalog ? 'catalog' : (product.available ? product.display_price ? 'cart' : 'contact' : 'nostock') %}
            {% set texts = {'cart': "ADD TO BAG", 'contact': "CONTACT US", 'nostock': "OUT OF STOCK", 'catalog': "CATALOG"} %}
            
            <input type="submit" class="js-addtocart js-prod-submit-form btn-add-to-cart {{ state }}" value="{{ texts[state] | translate }}" {% if state == 'nostock' %}disabled{% endif %} />
        </div>

        {# 7. Texto informativo de pickup #}
        <div class="pickup-info mt-4">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
            Available for in-store pickup
        </div>
    </form>

    {# 8. Acordeones #}
    <div class="luxury-accordions-wrapper mt-5">
        {% include 'snipplets/product/product-accordion.tpl' with { accordion_title: 'Sizing', accordion_content: 'Standard fit. Model is 1.75m and wears size M.' } %}
        {% include 'snipplets/product/product-accordion.tpl' with { accordion_title: 'Care instructions', accordion_content: 'Hand wash cold. Do not bleach. Dry flat.' } %}
        {% include 'snipplets/product/product-accordion.tpl' with { accordion_title: 'Materials', accordion_content: '100% Organic Cotton. Sourced in Japan.' } %}
        {% include 'snipplets/product/product-accordion.tpl' with { accordion_title: 'Shipping & Returns', accordion_content: 'Free worldwide shipping on orders over $200. 14-day return policy.' } %}
    </div>

</div>
