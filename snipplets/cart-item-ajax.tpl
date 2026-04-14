<div class="js-cart-item {% if item.product.is_non_shippable %}js-cart-item-non-shippable{% else %}js-cart-item-shippable{% endif %} cart-item row no-gutters mb-3 {% if cart_page %}align-items-md-center{% endif %}" data-item-id="{{ item.id }}" data-store="cart-item-{{ item.product.id }}" data-component="cart.line-item">

  {# Cart item image #}
  <div class="col-auto">
    <a href="{{ item.url }}" class="d-block cart-item-image-col {% if cart_page%}cart-item-image-col-md{% endif %}">
      <img src="{{ item.featured_image | product_image_url('medium') }}" class="img-fluid cart-item-image {% if cart_page %}cart-item-image-md{% endif %}" />
    </a>
  </div>
  <div class="col pl-3 align-items-center my-2">
    <div class="row align-items-center">
      
      <div class="col {% if cart_page %}col-md-5 pr-0 pr-md-3{% endif %}">

        {# Cart item name #}

        <div class="font-small mb-1 {% if cart_page %}font-md-body{% endif %}" data-component="line-item.name">
          <a href="{{ item.url }}" data-component="name.short-name">
            {{ item.short_name }}
            <small data-component="name.short-variant-name">{{ item.short_variant_name }}</small>
          </a>
          
          {{ component(
            'cart-labels', {
              group: true,
              subscription_label: true,
              labels_classes: {
                group: 'mt-1 mb-2',
                label: 'text-accent font-smallest font-md-small mb-1',
                subscription: 'font-smallest opacity-80 mt-1 mb-2',
              },
            })
          }}
        </div>

        {# Cart item subtotal #}
        
        <span class="js-cart-item-subtotal {% if cart_page %}col-md-2 px-0 text-md-center d-block d-md-none{% endif %}" data-line-item-id="{{ item.id }}" data-component="subtotal.value" data-component-value={{ item.subtotal | money }}'>{{ item.subtotal | money }}</span>
      </div>

      <div class="col-auto {% if cart_page %}col-md-7 p-md-0{% endif %} text-right">

        {% if cart_page %}
        <div class="row align-items-md-center d-block d-md-flex">
        {% endif %}

          <button type="button" class="btn btn-link font-small mb-2 pr-0 {% if cart_page %}d-inline-block d-md-none mr-3{% endif %}" onclick="LS.removeItem({{ item.id }}{% if not cart_page %}, true{% endif %})" data-component="line-item.remove">
            {{ "Borrar" | translate }}
          </button>

          {# Cart item quantity controls #}

          {% set cart_quantity_class = cart_page ? 'float-md-none m-md-auto ' : '' %}
          {% set cart_quantity_input_class = cart_page ? 'py-md-2 my-1' : '' %}

          <div class="cart-item-quantity {% if cart_page %}col-md-3 mb-2  mb-md-0 text-center{% endif %}" data-component="line-item.subtotal">
            {% set cart_qty_margin = '' %}
            {% if cart_page %}
              {% set cart_qty_margin = 'm-md-auto' %}
            {% endif %}
            {% embed "snipplets/forms/form-input.tpl" with{
              type_number: true, 
              input_value: item.quantity, 
              input_name: 'quantity[' ~ item.id ~ ']', 
              input_data_attr: 'item-id',
              input_data_val: item.id,
              input_group_custom_class: cart_quantity_class ~ 'form-quantity cart-item-quantity small p-0 ' ~ cart_qty_margin, 
              input_custom_class: 'js-cart-quantity-input text-center py-1 ' ~  cart_quantity_input_class, 
              input_label: false, input_append_content: true, 
              data_component: 'quantity.value',
              form_control_container_custom_class: 'js-cart-quantity-container col px-0'} %}
                {% block input_prepend_content %}
                <div class="form-row m-0 align-items-center">
                  <span class="js-cart-quantity-btn form-quantity-icon icon-35px font-small" onclick="LS.minusQuantity({{ item.id }}{% if not cart_page %}, true{% endif %})" data-component="quantity.minus">
                    <svg class="icon-inline"><use xlink:href="#minus"/></svg>
                  </span>
                {% endblock input_prepend_content %}
                {% block input_append_content %}
                  
                  {# Always place this spinner before the quantity input #}
            
                  <span class="js-cart-input-spinner cart-item-spinner" style="display: none;">
                    <svg class="icon-inline icon-spin icon-w-2em svg-icon-text"><use xlink:href="#spinner-third"/></svg>
                  </span>

                  <span class="js-cart-quantity-btn form-quantity-icon icon-35px font-small" onclick="LS.plusQuantity({{ item.id }}{% if not cart_page %}, true{% endif %})" data-component="quantity.plus">
                    <svg class="icon-inline"><use xlink:href="#plus"/></svg>
                  </span>
                </div>
                {% endblock input_append_content %}
            {% endembed %}
          </div>

          {% if cart_page %}
              
            {# Cart item unit price #}
            
            <span class="js-cart-item-unit-price cart-item-subtotal-short col-2 col-md-4 text-center p-0 d-none d-md-block" data-line-item-id="{{ item.id }}">{{ item.unit_price | money }}</span>

            <span class="js-cart-item-subtotal col-5 col-md-4 text-right text-md-center p-0 mt-2 mt-md-0 d-none d-md-block" data-line-item-id="{{ item.id }}" data-component="subtotal.value" data-component-value={{ item.subtotal | money }}'>{{ item.subtotal | money }}</span>

          {% endif %}

        {% if cart_page %}
        </div>
        {% endif %}
      </div>
    </div>
  </div>

  {% if cart_page %}
    
    {# Cart item delete #}
    <div class="col-auto d-none d-md-block text-center" >
      <button type="button" class="btn btn-link" onclick="LS.removeItem({{ item.id }}{% if not cart_page %}, true{% endif %})" data-component="line-item.remove">
        {{ "Borrar" | translate }}
      </button>
    </div>
  {% endif %}
</div>