{% embed "snipplets/page-header.tpl" %}
    {% block page_header_text %}{{ 'Orden #{1}' | translate(order.number) }}{% endblock page_header_text %}
{% endembed %}

<section class="account-page mt-3 mb-4">
    <div class="container" data-store="account-order-detail-{{ order.id }}">
    	<div class="row">
            <div class="col-md-4 mb-3">
                {% if log_entry %}
                    <h4>{{ 'Estado actual del envío' | translate }}:</h4>{{ log_entry }}
                {% endif %}
                <div class="font-small mb-2">
                    {{'Fecha' | translate}}: <strong>{{ order.date | i18n_date('%d/%m/%Y') }}</strong> 
                </div>
                <div class="font-small mb-2">
                    {{'Estado' | translate}}: <strong>{{ (order.status == 'open'? 'Abierta' : (order.status == 'closed'? 'Cerrada' : 'Cancelada')) | translate }}</strong>
                </div>
                <div class="font-small mb-2">
                    {{'Pago' | translate}}: <strong>{{ (order.payment_status == 'pending'? 'Pendiente' : (order.payment_status == 'authorized'? 'Autorizado' : (order.payment_status == 'paid'? 'Pagado' : (order.payment_status == 'voided'? 'Cancelado' : (order.payment_status == 'refunded'? 'Reintegrado' : 'Abandonado'))))) | translate }} </strong>
                </div>
                <div class="font-small mb-2">
                    {{'Medio de pago' | translate}}: <strong>{{ order.payment_name }}</strong>
                </div>

                {% if order.address %}
                    <div class="font-small mb-2">
                        {{'Envío' | translate}}: <strong>{{ (order.shipping_status == 'fulfilled'? 'Enviado' : 'No enviado') | translate }}</strong>
                    </div>
                    <div class="font-small mt-3 mb-2"> 
                        <strong>{{ 'Dirección de envío' | translate }}:</strong>
                        <span class="d-block d-block mt-1">
                            {{ order.address | format_address }}
                        </span>
                    </div>
                {% endif %}
            </div>
            <div class="col-md-8">
                <div class="mb-1 d-none d-md-block">
                    <div class="row">
                        <div class="col-6 mb-2 font-small">
                            {{ 'Producto' | translate }}
                        </div>
                        <div class="col-2 text-center mb-2 font-small">
                            {{ 'Precio' | translate }}
                        </div>
                        <div class="col-2 text-center mb-2 font-small">
                            {{ 'Cantidad' | translate }}
                        </div>
                        <div class="col-2 text-center mb-2 font-small">
                            {{ 'Total' | translate }}
                        </div>
                    </div>
                </div>
                <div class="order-detail card mb-3">
                    {% for item in order.items %}
                        <div class="order-item p-3 font-small">
                            <div class="row align-items-center">
                                <div class="col-7 col-md-6">
                                    <div class="row align-items-center">
                                        <div class="col-4 col-md-2 pr-0">
                                            <div class="card-img-square-container">
                                                {{ item.featured_image | product_image_url("small") | img_tag(item.featured_image.alt, {class: 'd-block card-img-square'}) }} 
                                            </div>
                                        </div>
                                        <div class="col-8 col-md-9">
                                            {{ item.name }} <span class="d-inline-block d-md-none text-center">x{{ item.quantity }}</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-2 d-none d-md-flex align-self-stretch justify-content-center">
                                    <span class="d-flex align-self-center">
                                        {{ item.unit_price | money }}
                                    </span>
                                </div>
                                <div class="col-2 d-none d-md-flex align-self-stretch justify-content-center">
                                    <span class="d-flex align-self-center">
                                        {{ item.quantity }}
                                    </span>
                                </div>
                                <div class="col-5 col-md-2 d-flex px-3 align-self-stretch justify-content-end justify-content-center-md">
                                    <span class="d-flex align-self-center">
                                        {{ item.subtotal | money }}
                                    </span>
                                </div>
                            </div>
                        </div>
                    {% endfor %}
                </div>
                {% if order.show_shipping_price %}
                    <div class="mb-2 text-right">
                        <strong class="font-small">{{ 'Costo de envío ({1})' | translate(order.shipping_name) }}:</strong>
                        {% if order.shipping == 0  %}
                            {{ 'Gratis' | translate }}
                        {% else %}
                            {{ order.shipping | money_long }}
                        {% endif %}
                    </div>
                {% else %}
                    <div class="mb-2 text-right">
                        <strong class="font-small">{{ 'Costo de envío ({1})' | translate(order.shipping_name) }}:</strong>
                        {{ 'A convenir' | translate }}
                    </div>
                {% endif %}
                {% if order.discount %}
                    <div class="mb-2 text-right">
                       <strong class="font-small">{{ 'Descuento ({1})' | translate(order.coupon) }}:</strong>
                        - {{ order.discount | money }}
                    </div>
                {% endif %}
                {% if order.shipping or order.discount %}
                    <div class="mb-2 text-right">
                        <strong class="font-small">{{ 'Subtotal' | translate }}:</strong>
                        {{ order.subtotal | money }}
                    </div>
                {% endif %}  
                <h3 class="font-huge mb-3 text-right">{{ 'Total' | translate }}: {{ order.total | money }}</h3>
                {% if order.pending %}
                    <div class="text-right">
                        <a class="btn btn-primary btn-big d-inline-block col col-md-4" href="{{ order.checkout_url | add_param('ref', 'orders_details') }}" target="_blank">{{ 'Realizar el pago' | translate }}</a>
                    </div>
                {% endif %}
            </div>
    	</div>
    </div>
</section>