{% if settings.pagination == 'infinite' %}
	{% paginate by 12 %}
{% else %}
	{% paginate by 24 %}
{% endif %}

{% embed "snipplets/page-header.tpl" with { hide_breadcrumbs: true, container: false } %}
	{% block page_header_text %}
		{% if products %}
			{{ 'Resultados de búsqueda' | translate }}
		{% else %}
			{{ "No encontramos nada para" | translate }}<span class="ml-2">"{{ query }}"</span>
		{% endif %}
	{% endblock page_header_text %}
	{% block page_header_aside %}
		{% include 'snipplets/grid/filters-modals.tpl' %}
	{% endblock page_header_aside %}
{% endembed %}
{% if products %}
	<div class="container-fluid px-1 mb-4">
		<h2 class="h5 pb-2 font-weight-normal text-left">
			{{ "Mostrando los resultados para" | translate }}<span class="ml-2 font-weight-bold">"{{ query }}"</span>
		</h2>
	</div>		
{% endif %}

<section class="js-category-controls-prev category-controls-sticky-detector"></section>

<section class="category-body overflow-none">
	<div class="container-fluid px-0 {% if search_filter and products %}mt-4{% endif %} mb-5">
		{% include 'snipplets/grid/product-list.tpl' %}
	</div>
</section>