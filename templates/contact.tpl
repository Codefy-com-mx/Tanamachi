<div class="container-fluid px-1">
	{% embed "snipplets/page-header.tpl" with {container: false, hide_breadcrumbs: true} %}
		{% if is_order_cancellation %}
			{% set form_title = "Pedí la cancelación de tu última compra" | translate %}
		{% else %}
			{% set form_title = "Contacto" | translate %}
		{% endif %}
		{% block page_header_text %}{{ form_title }}{% endblock page_header_text %}
	{% endembed %}
</div>

{% set has_contact_info = store.whatsapp or store.phone or store.email or store.address or store.blog or store.contact_intro %}
{% set is_order_cancellation_without_id = params.order_cancellation_without_id == 'true' %}

<section class="contact-page visible-when-content-ready mb-5">
	<div class="container-fluid px-1">
		<div class="row justify-content-center">
			<div class="col-md-8 col-lg-6">
				{% if has_contact_info and not is_order_cancellation %}
					<div class="contact-info text-center mb-5">
						{% if store.contact_intro %}
							<p class="mb-4 font-large">{{ store.contact_intro }}</p>
						{% endif %}
						<h2 class="h3 mb-4 font-weight-bold">{{ 'Nuestros canales' | translate }}</h2>
						<div class="d-flex justify-content-center">
							{% include "snipplets/contact-links.tpl" with {with_icons: true} %}
						</div>
					</div>
				{% endif %}

				<div class="contact-form-container bg-white p-4 p-md-5 border-radius-small shadow-lg mb-5">
					<h2 class="h3 mb-4 font-weight-bold text-center">{{ 'Envianos un mensaje' | translate }}</h2>
					
					{% if product %}  
						<div class="row align-items-center mb-4 justify-content-center">
							<div class="col-auto text-center">
								<img src="{{ product.featured_image | product_image_url('thumb') }}" title="{{ product.name }}" alt="{{ product.name }}" class="d-block mx-auto img-fluid border-radius-small" />
								<p class="mt-2 mb-0 font-weight-bold">{{ product.name | a_tag(product.url) }}</p>
							</div>
						</div>
					{% endif %}

					{% if contact %}
						{% if contact.success %}
							<div class="alert alert-success text-center">
								{{ "¡Gracias por contactarnos! Vamos a responderte apenas veamos tu mensaje." | translate }}
							</div>
						{% endif %}
					{% endif %}

					{% embed "snipplets/forms/form.tpl" with{form_id: 'contact-form', form_custom_class: 'js-winnie-pooh-form', form_action: '/winnie-pooh', submit_custom_class: 'btn-block btn-lg btn-primary', submit_name: 'contact', submit_text: 'Enviar' | translate, data_store: 'contact-form' }  %}
						{% block form_body %}
							<div class="winnie-pooh hidden">
								<input type="text" id="winnie-pooh" name="winnie-pooh">
							</div>
							<input type="hidden" value="{{ product.id }}" name="product"/>

							{% embed "snipplets/forms/form-input.tpl" with{input_for: 'name', type_text: true, input_name: 'name', input_id: 'name', input_label_text: 'Nombre' | translate, input_placeholder: 'Tu nombre completo' | translate } %}
							{% endembed %}

							{% embed "snipplets/forms/form-input.tpl" with{input_for: 'email', type_email: true, input_name: 'email', input_id: 'email', input_label_text: 'Email' | translate, input_placeholder: 'tuemail@ejemplo.com' | translate } %}
							{% endembed %}

							{% embed "snipplets/forms/form-input.tpl" with{input_for: 'phone', type_tel: true, input_name: 'phone', input_id: 'phone', input_label_text: 'Teléfono' | translate, input_placeholder: 'Tu número de teléfono' | translate } %}
							{% endembed %}

							{% embed "snipplets/forms/form-input.tpl" with{text_area: true, input_for: 'message', input_name: 'message', input_id: 'message', input_rows: '5', input_label_text: 'Mensaje' | translate, input_placeholder: '¿En qué podemos ayudarte?' | translate } %}
							{% endembed %}
						{% endblock %}
					{% endembed %}
				</div>
			</div>
		</div>
	</div>
</section>